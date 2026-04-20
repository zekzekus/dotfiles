# Temporary overlays / workarounds.
# Review periodically and remove once upstream fixes land.
_: prev: {
  neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (old: {
    postInstall =
      (old.postInstall or "")
      + ''
        mkdir -p $out/share/applications
        if [ ! -f $out/share/applications/nvim.desktop ]; then
          cat > $out/share/applications/nvim.desktop <<EOF
        [Desktop Entry]
        Name=Neovim
        GenericName=Text Editor
        TryExec=nvim
        Exec=nvim %F
        Type=Application
        Keywords=Text;editor;
        Icon=nvim
        Categories=Utility;TextEditor;
        StartupNotify=false
        MimeType=text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;
        Terminal=true
        EOF
        fi
      '';
  });
  python3Packages = prev.python3Packages.overrideScope (
    _: pyPrev: {
      picosvg = pyPrev.picosvg.overridePythonAttrs {
        doCheck = false;
      };
    }
  );
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
