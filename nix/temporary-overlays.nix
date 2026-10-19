# Temporary overlays / workarounds.
# Review periodically and remove once upstream fixes land.
_: prev: {
  # Backport https://github.com/NixOS/nixpkgs/pull/574509 until our pin includes it.
  # Host /etc/bashrc resets PATH in unsandboxed Darwin e2e tests. The harness
  # clears the environment, so set NOSYSBASHRC in a wrapper named bash (the
  # executable name selects Atuin's shell integration), not in preCheck.
  atuin = prev.atuin.overrideAttrs (old:
    prev.lib.optionalAttrs prev.stdenv.hostPlatform.isDarwin {
      env =
        (old.env or {})
        // {
          ATUIN_E2E_BASH = prev.lib.getExe (
            prev.writeShellScriptBin "bash" ''
              NOSYSBASHRC=1 exec ${prev.lib.getExe prev.bashInteractive} "$@"
            ''
          );
        };
    });
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
    prev.lib.optionalAttrs prev.stdenv.hostPlatform.isDarwin {
      doCheck = false;
      doInstallCheck = false;
    });
  # Workaround for nixpkgs#510488: nushell tests env_shlvl_in_repl and
  # env_shlvl_in_exec_repl fail on Darwin due to sandbox permissions.
  # The package uses a custom checkPhase, so we must override it directly.
  nushell = prev.nushell.overrideAttrs (old:
    prev.lib.optionalAttrs prev.stdenv.hostPlatform.isDarwin {
      checkPhase =
        builtins.replaceStrings
        ["shell::environment::env::path_is_a_list_in_repl"]
        ["shell::environment::env::path_is_a_list_in_repl --skip=shell::environment::env::env_shlvl_in_repl --skip=shell::environment::env::env_shlvl_in_exec_repl"]
        (old.checkPhase or "");
    });
}
