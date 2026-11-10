"""Exercise the public preflight CLI with real Nix and disposable age secrets."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[2]
SECRET = "DOCTOR_TEST_PLAINTEXT_MUST_NOT_APPEAR"


class DoctorTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.base = Path(self.tmp.name)
        self.repo = self.base / "checkout with spaces"
        self.home = self.base / "home"
        self.bin = self.base / "bin"
        for path in (self.repo / "secrets", self.home, self.bin):
            path.mkdir(parents=True)
        host = self.repo / "nix/hosts/fixture"
        host.mkdir(parents=True)
        for name in ("default.nix", "configuration.nix"):
            (host / name).write_text("{}")
        (self.repo / "flake.lock").write_text("{}")
        self.env = dict(os.environ, HOME=str(self.home),
                        XDG_CACHE_HOME=str(self.home / "cache"),
                        XDG_CONFIG_HOME=str(self.home / "config"),
                        NIX_CONFIG="experimental-features = nix-command flakes",
                        PATH=f"{self.bin}:{os.environ['PATH']}")
        self.stub("id", 'if [ "$1" = -u ]; then echo 1000; else echo tester; fi')
        self.stub("uname", 'if [ "$1" = -m ]; then echo x86_64; else echo Linux; fi')
        self.stub("hostname", "echo fixture")
        self.stub("whoami", "echo tester")
        for tool in ("home-manager", "sudo", "xcode-select", "systemctl"):
            self.stub(tool, "exit 0")
        self.key = self.home / "key.txt"
        self.key.write_text(self.command("age-keygen").stdout)
        self.key.chmod(0o600)
        public = self.command("age-keygen", "-y", str(self.key)).stdout.strip()
        encrypted = self.command("sops", "--encrypt", "--age", public,
                                 "--input-type", "binary", "--output-type", "binary",
                                 "/dev/stdin", input=SECRET).stdout
        (self.repo / "secrets/ssh-config").write_text(encrypted)
        self.metadata()

    def command(self, *args, **kwargs):
        return subprocess.run(args, env=self.env, cwd=self.base, text=True,
                              capture_output=True, check=True, **kwargs)

    def stub(self, name, body):
        path = self.bin / name
        path.write_text(f"#!{shutil.which('bash')}\n" + body + "\n")
        path.chmod(0o755)

    def metadata(self, system="x86_64-linux", user="tester", checkout=None,
                 hostname="fixture", profiles=()):
        q = json.dumps
        (self.repo / "flake.nix").write_text(f"""{{ outputs = {{...}}: {{ lib.setup = {{
          hosts.{hostname} = {{ hostname = {q(hostname)}; system = {q(system)};
            profiles = [{" ".join(q(p) for p in profiles)}];
            common = {{ username = {q(user)}; homeDir = {q(str(self.home))};
              dotfilesDir = {q(str(checkout or self.repo))};
              sessionVariables.SOPS_AGE_KEY_FILE = {q(str(self.key))}; }}; }};
          outputs = {{ home = [{q(f"tester@{hostname}")}];
            darwin = [{q(hostname)}]; nixos = [{q(hostname)}]; }};
          profiles = ["graphical" "wayland"];
        }}; }}; }}""")

    def run_doctor(self, *args, code=0):
        result = subprocess.run([shutil.which("bash"), str(ROOT / "scripts/doctor"),
                                 "--flake", str(self.repo), "--target", "home", *args],
                                env=self.env, cwd=self.base, text=True, capture_output=True)
        self.assertEqual(result.returncode, code, result.stdout + result.stderr)
        self.assertNotIn(SECRET, result.stdout + result.stderr)
        self.assertNotIn("AGE-SECRET-KEY-", result.stdout + result.stderr)
        return result.stdout

    def snapshot(self):
        return {str(p): (p.read_bytes() if p.is_file() else None,
                        p.stat().st_mtime_ns, p.stat().st_mode)
                for p in self.base.rglob("*")}

    def test_ready_with_optional_gaps_and_no_writes(self):
        before = self.snapshot()
        out = self.run_doctor()
        self.assertIn("Output: tester@fixture", out)
        self.assertIn("Secret ssh-hosts: decrypts", out)
        self.assertIn("WARN  Secret amp-runner-work", out)
        self.assertIn("0 error(s)", out)
        self.assertEqual(before, self.snapshot())

    def runtime_fixture(self, hostname="fixture", system="x86_64-linux", profiles=()):
        self.metadata(hostname=hostname, system=system, profiles=profiles)
        host = self.repo / "nix/hosts" / hostname
        host.mkdir(exist_ok=True)
        (host / "default.nix").write_text("{}")
        (host / "configuration.nix").write_text("{}")
        self.stub("hostname", f"echo {hostname}")
        for tool in ("nu", "nvim"):
            self.stub(tool, "exit 0")
        # Readiness must never try to authenticate, sign or start a process.
        for tool in ("gpg", "ssh", "ssh-add", "op", "amp"):
            self.stub(tool, 'echo "unexpected stateful command" > stateful-command-attempt; exit 99')
        rendered = self.home / ".ssh/config.d/hosts"
        rendered.parent.mkdir(parents=True)
        rendered.write_text(SECRET)
        rendered.chmod(0o400)
        return rendered

    def test_runtime_headless_is_read_only_and_requires_rendered_secret(self):
        rendered = self.runtime_fixture()
        before = self.snapshot()
        out = self.run_doctor("--runtime")
        self.assertIn("Rendered SSH hosts: present with private permissions", out)
        self.assertNotIn("1Password SSH", out)
        self.assertNotIn("amp-runner-", out)
        self.assertNotIn("unexpected stateful command", out)
        self.assertEqual(before, self.snapshot())
        rendered.chmod(0o644)
        self.assertIn("Rendered SSH hosts: expected mode", self.run_doctor("--runtime", code=1))
        rendered.unlink()
        self.assertIn("Rendered SSH hosts: missing", self.run_doctor("--runtime", code=1))

    def test_runtime_linux_distinguishes_desktop_and_optional_runners(self):
        self.runtime_fixture(hostname="nixos", profiles=("graphical", "wayland"))
        self.env["XDG_CURRENT_DESKTOP"] = "niri"
        self.env["XDG_RUNTIME_DIR"] = str(self.home / "runtime")
        # One runner is up, one is down; a successful inactive sops oneshot
        # must not be mistaken for a failed secret service.
        self.stub("systemctl", '''case "$*" in
          "--user show-environment"|"--user is-active --quiet amp-runner-personal.service") exit 0;;
          *) exit 1;; esac''')
        out = self.run_doctor("--runtime", code=1)
        self.assertIn("OK    Service amp-runner-personal: active", out)
        self.assertIn("WARN  Service amp-runner-work: inactive", out)
        self.assertIn("ERROR Service noctalia: inactive", out)
        self.assertIn("WARN  Runner work credential: missing", out)
        self.env["XDG_CURRENT_DESKTOP"] = "plasma"
        self.assertIn("Wayland readiness unverified", self.run_doctor("--runtime"))
        self.stub("hostname", "echo different")
        self.assertIn("Runtime hostname does not match",
                      self.run_doctor("--runtime", "--host", "nixos", code=1))

    @unittest.skipUnless(os.uname().sysname == "Darwin", "requires macOS stat")
    def test_runtime_mac_reports_jobs_without_leaking_launchctl_environment(self):
        rendered = self.runtime_fixture(hostname="mac-machine", system="aarch64-darwin",
                                        profiles=("graphical",))
        self.stub("uname", 'if [ "$1" = -m ]; then echo arm64; else echo Darwin; fi')
        self.stub("stat", "exit 99")  # An incompatible PATH stat must not be used.
        self.stub("launchctl", f'''case "$*" in
          "print gui/1000/org.nix-community.home.amp-runner-personal")
            echo "state = running"; echo "AMP_API_KEY={SECRET}";;
          *) exit 1;; esac''')
        out = self.run_doctor("--runtime", "--target", "darwin")
        self.assertIn("OK    Service amp-runner-personal: running", out)
        self.assertIn("WARN  Service amp-runner-work: not running", out)
        self.assertIn("1Password SSH socket/environment unavailable", out)
        self.assertIn("Rendered SSH hosts: present with private permissions", out)
        rendered.chmod(0o644)
        self.key.chmod(0o644)
        out = self.run_doctor("--runtime", "--target", "darwin", code=1)
        self.assertIn("Age key permissions must be private", out)
        self.assertIn("Rendered SSH hosts: expected mode", out)

    def test_wrong_output_lists_choices(self):
        out = self.run_doctor("--host", "not-defined", code=1)
        self.assertIn("No home output 'tester@not-defined'", out)
        self.assertIn("Available: tester@fixture", out)

    def test_wrong_user_architecture_and_path_are_blockers(self):
        self.metadata(system="aarch64-linux", user="different", checkout=self.base / "missing")
        out = self.run_doctor(code=1)
        for expected in ("Architecture mismatch", "Wrong account", "Wrong checkout path"):
            self.assertIn(expected, out)

    def test_missing_wrong_and_insecure_key(self):
        self.key.unlink()
        self.assertIn("age key is missing", self.run_doctor(code=1))
        self.key.write_text(self.command("age-keygen").stdout)
        self.key.chmod(0o600)
        self.assertIn("Secret ssh-hosts: cannot decrypt", self.run_doctor(code=1))
        self.key.chmod(0o644)
        self.assertIn("Age key permissions must be private", self.run_doctor(code=1))

    def test_missing_nix_and_make(self):
        # A bounded PATH proves bootstrap diagnostics work without Nix/Make.
        for tool in ("bash", "dirname", "cat"):
            (self.bin / tool).symlink_to(shutil.which(tool))
        self.env["PATH"] = str(self.bin)
        out = self.run_doctor(code=1)
        self.assertIn("Missing bootstrap tool: nix", out)
        self.assertIn("Missing bootstrap tool: make", out)
        self.assertIn("cannot be verified until Nix is available", out)

    def test_disabled_flakes(self):
        self.env["NIX_CONFIG"] = "experimental-features = nix-command"
        # Determinate provides stable flakes even with this setting absent.
        if "Determinate Nix" in self.command("nix", "--version").stdout:
            self.assertIn("Nix flakes available", self.run_doctor())
        else:
            self.assertIn("Enable flakes", self.run_doctor(code=1))

    def test_home_bootstrap_without_home_manager(self):
        # Bound PATH even when the developer already has home-manager installed.
        (self.bin / "home-manager").unlink()
        for tool in ("bash", "dirname", "cat", "stat", "env", "nix", "git", "make", "sops"):
            (self.bin / tool).symlink_to(shutil.which(tool))
        self.env["PATH"] = str(self.bin)
        out = self.run_doctor()
        self.assertIn("WARN  home-manager absent: use the locked first-activation command", out)
        self.assertIn("Systemd user manager reachable", out)
        (self.bin / "systemctl").unlink()
        self.assertIn("Missing systemctl", self.run_doctor(code=1))

    def test_home_requires_reachable_user_manager(self):
        self.stub("systemctl", "exit 1")
        self.assertIn("No reachable systemd user manager", self.run_doctor(code=1))

    def test_missing_sops_is_unverified_not_ready(self):
        for tool in ("bash", "dirname", "cat", "stat", "env", "nix", "git", "make"):
            (self.bin / tool).symlink_to(shutil.which(tool))
        self.env["PATH"] = str(self.bin)
        out = self.run_doctor(code=1)
        self.assertIn("Secret ssh-hosts: decryption unverified; sops is not on PATH", out)
        self.assertNotIn("Secret ssh-hosts: decrypts", out)

    def test_bad_optional_runner_secret_is_only_a_warning(self):
        (self.repo / "secrets/amp-runner-work.env").write_text("not encrypted")
        out = self.run_doctor()
        self.assertIn("WARN  Secret amp-runner-work: cannot decrypt", out)
        self.assertIn("0 error(s)", out)

    @unittest.skipUnless(os.uname().sysname == "Darwin", "requires macOS stat")
    def test_mac_bootstrap_does_not_require_darwin_rebuild(self):
        self.stub("uname", 'if [ "$1" = -m ]; then echo arm64; else echo Darwin; fi')
        self.stub("stat", "exit 99")
        self.metadata(system="aarch64-darwin")
        out = self.run_doctor("--target", "darwin")
        self.assertIn("Output: fixture", out)
        self.assertIn("Homebrew", out)
        self.assertIn("0 error(s)", out)

    def test_make_overrides_select_the_same_output(self):
        result = subprocess.run(
            ["make", "doctor", "HOST=fixture", "USER=tester", "TARGET=home", f"FLAKE={self.repo}"],
            env=self.env, cwd=ROOT, text=True, capture_output=True)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("Output: tester@fixture", result.stdout)

    def test_real_host_metadata_without_resolving_inputs(self):
        for target, output, system in (("darwin", "mac-machine", "aarch64-darwin"),
                                       ("nixos", "nixos", "x86_64-linux"),
                                       ("home", "zekus@nixos", "x86_64-linux")):
            expr = (f'f: f {{ repo = {json.dumps(str(ROOT))}; '
                    f'target = "{target}"; output = "{output}"; }}')
            result = self.command("nix", "eval", "--store", "dummy://", "--offline",
                                  "--read-only", "--impure", "--raw", "--file",
                                  str(ROOT / "nix/doctor.nix"), "--apply", expr)
            self.assertIn(f"system\t{system}\n", result.stdout)
            self.assertIn("user\tzekus\n", result.stdout)

    def test_added_host_is_discovered_without_doctor_changes(self):
        source = (ROOT / "flake.nix").read_text()
        source = source.replace("hosts = {", '''hosts = {
          fresh = { hostname = "fresh"; system = "aarch64-linux"; profiles = []; };''', 1)
        source = source.replace("homeConfigurations = {", '''homeConfigurations = {
          "zekus@fresh" = mkHomeConfiguration {
            inherit (hosts.fresh) hostname system profiles;
          };''', 1)
        (self.repo / "flake.nix").write_text(source)
        shutil.copyfile(ROOT / "nix/lib.nix", self.repo / "nix/lib.nix")
        host = self.repo / "nix/hosts/fresh"
        host.mkdir()
        (host / "default.nix").write_text("{}")
        out = self.run_doctor("--target", "home", "--host", "fresh", "--user", "zekus", code=1)
        self.assertIn("Configured architecture: aarch64-linux", out)
        self.assertIn("Configured user: zekus", out)
        self.assertNotIn("Cannot inspect selected output", out)


if __name__ == "__main__":
    unittest.main()
