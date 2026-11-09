"""Run the updater CLIs on copied pins, using real curl against local HTTP.

Only the transport URLs are redirected; retry decisions and hashing are real.
No upstream requests, Nix builds, store imports, or real pin writes occur.
"""
import base64
from collections import Counter
import hashlib
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
import threading
import unittest


ROOT = Path(__file__).resolve().parents[2]
NAMES = ("amp", "amp-acp", "grokbot", "helium")
VERSION = "9.8.7"
REVISION = "1234567890abcdef1234567890abcdef12345678"
ARCHIVE = b"local fixture archive\x00with asymmetric content\n"
SRI = "sha256-" + base64.b64encode(hashlib.sha256(ARCHIVE).digest()).decode()
PLATFORMS = ("linux-x64", "linux-arm64", "darwin-x64", "darwin-arm64")
HASHES = {p: hashlib.sha256(p.encode()).hexdigest() for p in PLATFORMS}
REDIRECT = (f"https://downloads.cursor.com/grokbot/stable/{REVISION}"
            f"/linux/x64/Grok_Bot_{VERSION}.AppImage")


class UpdateTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.repo = Path(self.tmp.name) / "checkout with spaces"
        self.pins = self.repo / "nix/modules/packages"
        self.pins.mkdir(parents=True)
        shutil.copytree(ROOT / "scripts", self.repo / "scripts")
        shutil.copy(ROOT / "Makefile", self.repo / "Makefile")
        for name in NAMES:
            shutil.copyfile(ROOT / f"nix/modules/packages/{name}.nix",
                            self.pins / f"{name}.nix")
        self.counts = Counter()
        self.headers = []
        self.failures = {}
        self.body = None
        test = self

        class Handler(BaseHTTPRequestHandler):
            def log_message(self, *args):
                pass

            def do_HEAD(self):
                self.do_GET()

            def do_GET(self):
                path = self.path
                test.counts[path] += 1
                test.headers.append((path, self.headers.get("Authorization")))
                for fragment, (status, attempts) in test.failures.items():
                    if fragment in path and test.counts[path] <= attempts:
                        self.send_response(status)
                        self.end_headers()
                        return
                body = ARCHIVE
                if path.endswith("/releases/latest"):
                    body = (test.body if test.body is not None else
                            json.dumps({"tag_name": "v" + VERSION if
                                        "amp-acp" in path else VERSION}).encode())
                elif path.endswith("cli-version.txt"):
                    body = test.body if test.body is not None else VERSION.encode()
                elif path.endswith(".sha256"):
                    body = (test.body if test.body is not None else
                            HASHES[path.rsplit("/", 1)[1].removesuffix("-amp.sha256")].encode())
                elif "/updates/download/" in path:
                    self.send_response(302)
                    self.send_header("Location", REDIRECT)
                    self.end_headers()
                    return
                self.send_response(200)
                self.end_headers()
                if self.command != "HEAD":
                    self.wfile.write(body)

        self.server = ThreadingHTTPServer(("127.0.0.1", 0), Handler)
        self.thread = threading.Thread(target=self.server.serve_forever, daemon=True)
        self.thread.start()
        self.addCleanup(self.stop_server)
        bin_dir = self.repo / "bin"
        bin_dir.mkdir()
        # Route only the known upstream hosts to this fixture. Use the actual
        # curl executable and shorten retry delays, not its retry/error policy.
        curl = bin_dir / "curl"
        curl.write_text(f"#!{shutil.which('python3')}\n" + f"""
import os, sys
from urllib.parse import urlsplit
args = []
for arg in sys.argv[1:]:
    if arg.startswith('https://'):
        url = urlsplit(arg)
        assert url.hostname in ('static.ampcode.com', 'api.github.com',
            'github.com', 'api2.cursor.sh', 'downloads.cursor.com'), arg
        arg = 'http://127.0.0.1:{self.server.server_port}' + url.path
    args.append(arg)
os.execv({shutil.which('curl')!r}, ['curl', *args, '--retry-delay', '1', '--noproxy', '*'])
""")
        curl.chmod(0o755)
        self.env = dict(os.environ, PATH=f"{bin_dir}:{os.environ['PATH']}",
                        GH_TOKEN="", GITHUB_TOKEN="",
                        NIX_CONFIG="experimental-features = nix-command flakes")

    def stop_server(self):
        self.server.shutdown()
        self.server.server_close()
        self.thread.join()

    def run_update(self, name, ok=True):
        pin = self.pins / f"{name}.nix"
        before = pin.read_bytes()
        result = subprocess.run([shutil.which("bash"),
                                 str(self.repo / f"scripts/update-{name}")],
                                cwd=self.repo, env=self.env, text=True,
                                capture_output=True, timeout=30)
        output = result.stdout + result.stderr
        self.assertEqual(result.returncode == 0, ok, output)
        self.assertFalse(list(self.pins.glob(".update-*")))
        if not ok:
            self.assertEqual(before, pin.read_bytes(), output)
            self.assertIn(f"update-{name}:", output)
        return output

    def test_all_pins_update_exactly_and_remain_valid_nix(self):
        for name in NAMES:
            with self.subTest(name=name):
                pin = self.pins / f"{name}.nix"
                expected = re.sub(r'version = "[^"]*"', f'version = "{VERSION}"', pin.read_text())
                if name == "amp":
                    for platform, value in HASHES.items():
                        expected = re.sub(f'(platform = "{platform}";\\s+sha256 = )"[^"]*"',
                                          rf'\g<1>"{value}"', expected)
                else:
                    expected = re.sub(r'hash = "sha256-[^"]*"', f'hash = "{SRI}"', expected)
                if name == "grokbot":
                    expected = re.sub(r'revision = "[^"]*"', f'revision = "{REVISION}"', expected)
                self.run_update(name)
                self.assertEqual(pin.read_text(), expected)
                self.assertEqual(pin.stat().st_mode & 0o777, 0o644)
                subprocess.run(["nix-instantiate", "--parse", str(pin)], check=True,
                               stdout=subprocess.DEVNULL, stderr=subprocess.PIPE)
        self.assertTrue(all(auth is None for _, auth in self.headers))

    def test_missing_and_duplicate_replacement_fields_preserve_pins(self):
        for name in NAMES:
            pin = self.pins / f"{name}.nix"
            original = pin.read_text()
            fields = ["version", "sha256" if name == "amp" else "hash"]
            if name == "grokbot":
                fields.append("revision")
            for field in fields:
                for duplicate in (False, True):
                    with self.subTest(name=name, field=field, duplicate=duplicate):
                        match = re.search(rf'^.*{field} = ".*\n', original, re.M)
                        replacement = match[0] * 2 if duplicate else ""
                        pin.write_text(original[:match.start()] + replacement + original[match.end():])
                        self.assertIn("expected", self.run_update(name, ok=False))
            pin.write_text(original)
        pin = self.pins / "amp.nix"
        pin.write_text(pin.read_text().replace('platform = "darwin-arm64"', 'platform = "linux-x64"'))
        self.run_update("amp", ok=False)

    def test_transient_api_and_archive_failures_recover(self):
        self.failures = {"/releases/latest": (504, 1), ".AppImage": (503, 1)}
        self.run_update("helium")
        self.assertEqual(sorted(self.counts.values()), [2, 2])
        self.assertIn(f'hash = "{SRI}"', (self.pins / "helium.nix").read_text())

    def test_retry_exhaustion_preserves_pin_and_reports_context(self):
        for fragment in ("/releases/latest", ".AppImage"):
            with self.subTest(fragment=fragment):
                self.counts.clear()
                self.failures = {fragment: (504, 99)}
                out = self.run_update("helium", ok=False)
                self.assertIn("504", out)
                self.assertIn("failed", out)
                self.assertEqual(sum(n for p, n in self.counts.items() if fragment in p), 5)

    def test_permanent_error_is_not_retried(self):
        self.failures = {"/releases/latest": (403, 99)}
        out = self.run_update("amp-acp", ok=False)
        self.assertIn("rate limits", out)
        self.assertEqual(list(self.counts.values()), [1])

    def test_github_updaters_work_without_python_on_path(self):
        bin_dir = self.repo / "bin"
        for tool in ("bash", "dirname", "basename", "mktemp", "rm", "nix",
                     "awk", "chmod", "mv"):
            (bin_dir / tool).symlink_to(shutil.which(tool))
        self.env["PATH"] = str(bin_dir)
        self.assertIsNone(shutil.which("python3", path=self.env["PATH"]))
        for name in ("amp-acp", "helium"):
            with self.subTest(name=name):
                self.run_update(name)
                self.assertIn(f'version = "{VERSION}"', (self.pins / f"{name}.nix").read_text())
                self.assertIn(f'hash = "{SRI}"', (self.pins / f"{name}.nix").read_text())

    def test_malformed_release_data_preserves_pins(self):
        for body in (b"not JSON", b"{}", b'{"tag_name": null}',
                     b'{"tag_name": ""}', b'{"tag_name": "bad/tag"}'):
            with self.subTest(body=body):
                self.body = body
                self.run_update("amp-acp", ok=False)
        self.body = b"not-a-version"
        self.run_update("amp", ok=False)

    def test_bad_amp_checksum_preserves_pin(self):
        # Use a valid version value but an invalid checksum response.
        self.body = VERSION.encode()
        self.assertIn("invalid Amp SHA256", self.run_update("amp", ok=False))

    def test_token_is_optional_scoped_and_not_logged(self):
        for variable in ("GH_TOKEN", "GITHUB_TOKEN"):
            with self.subTest(variable=variable):
                self.headers.clear()
                self.env[variable] = "fixture_token_NEVER_LOG"
                out = self.run_update("amp-acp")
                self.assertNotIn(self.env[variable], out)
                for path, auth in self.headers:
                    self.assertEqual(auth, "Bearer " + self.env[variable]
                                     if path.endswith("/releases/latest") else None)
                self.env[variable] = ""

    def test_make_stops_in_order_without_flake_update_on_failure(self):
        self.failures = {"/releases/latest": (403, 99)}
        before = {name: (self.pins / f"{name}.nix").read_bytes() for name in NAMES}
        result = subprocess.run(["make", "-j8", "HOST=fixture", "USER=fixture", "update"], cwd=self.repo,
                                env=self.env, capture_output=True, text=True, timeout=30)
        self.assertNotEqual(result.returncode, 0)
        self.assertNotIn("Updating flake inputs", result.stdout)
        self.assertTrue(before["amp"] != (self.pins / "amp.nix").read_bytes(),
                        result.stdout + result.stderr)
        for name in NAMES[1:]:
            self.assertEqual(before[name], (self.pins / f"{name}.nix").read_bytes())
        self.assertFalse(any("cursor" in path or "helium" in path for path in self.counts))


if __name__ == "__main__":
    unittest.main()
