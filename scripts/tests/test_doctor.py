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

    def metadata(self, system="x86_64-linux", user="tester", checkout=None):
        q = json.dumps
        (self.repo / "flake.nix").write_text(f"""{{ outputs = {{...}}: {{ lib.setup = {{
          hosts.fixture = {{ hostname = "fixture"; system = {q(system)}; profiles = [];
            common = {{ username = {q(user)}; homeDir = {q(str(self.home))};
              dotfilesDir = {q(str(checkout or self.repo))};
              sessionVariables.SOPS_AGE_KEY_FILE = {q(str(self.key))}; }}; }};
          outputs = {{ home = ["tester@fixture"]; darwin = ["fixture"]; nixos = ["fixture"]; }};
          profiles = [];
        }}; }}; }}""")

    def run_doctor(self, *args, code=0):
        result = subprocess.run([shutil.which("bash"), str(ROOT / "scripts/doctor"),
                                 "--flake", str(self.repo), "--target", "home", *args],
                                env=self.env, cwd=self.base, text=True, capture_output=True)
        self.assertEqual(result.returncode, code, result.stdout + result.stderr)
        self.assertNotIn(SECRET, result.stdout + result.stderr)
        self.assertNotIn("AGE-SECRET-KEY-", result.stdout + result.stderr)
        return result.stdout

    def test_ready_with_optional_gaps_and_no_writes(self):
        def snapshot():
            return {str(p): (p.read_bytes() if p.is_file() else None,
                            p.stat().st_mtime_ns, p.stat().st_mode)
                    for p in self.base.rglob("*")}
        before = snapshot()
        out = self.run_doctor()
        self.assertIn("Output: tester@fixture", out)
        self.assertIn("Secret ssh-hosts: decrypts", out)
        self.assertIn("WARN  Secret amp-runner-work", out)
        self.assertIn("0 error(s)", out)
        self.assertEqual(before, snapshot())

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

    def test_mac_bootstrap_does_not_require_darwin_rebuild(self):
        self.stub("uname", 'if [ "$1" = -m ]; then echo arm64; else echo Darwin; fi')
        self.stub("stat", "echo 600")
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
