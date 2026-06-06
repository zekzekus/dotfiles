# Temporary overlays / workarounds.
# Review periodically and remove once upstream fixes land.
_: prev: {
  python3Packages = prev.python3Packages.overrideScope (
    _: pyPrev: {
      picosvg = pyPrev.picosvg.overridePythonAttrs {
        doCheck = false;
      };
    }
  );
  # Workaround: direnv's checkPhase hangs in the Nix sandbox on macOS
  # (test/scenarios/* spawns shells / watches dirs that deadlock).
  # Disable tests on Darwin until upstream fixes the test suite.
  direnv = prev.direnv.overrideAttrs (_:
    prev.lib.optionalAttrs prev.stdenv.isDarwin {
      doCheck = false;
      doInstallCheck = false;
    });
  # Workaround for nixpkgs#510488: nushell tests env_shlvl_in_repl and
  # env_shlvl_in_exec_repl fail on Darwin due to sandbox permissions.
  # The package uses a custom checkPhase, so we must override it directly.
  nushell = prev.nushell.overrideAttrs (old:
    prev.lib.optionalAttrs prev.stdenv.isDarwin {
      checkPhase =
        builtins.replaceStrings
        ["shell::environment::env::path_is_a_list_in_repl"]
        ["shell::environment::env::path_is_a_list_in_repl --skip=shell::environment::env::env_shlvl_in_repl --skip=shell::environment::env::env_shlvl_in_exec_repl"]
        (old.checkPhase or "");
    });
}
