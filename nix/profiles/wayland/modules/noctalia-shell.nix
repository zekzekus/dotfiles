{
  config,
  common,
  pkgs,
  ...
}: {
  # Noctalia v5 (C++ rewrite) ships its own Home Manager module and systemd
  # user service. Use nixpkgs' cached package instead of building the package
  # from the Noctalia flake on every upstream update.
  programs.noctalia = {
    enable = true;
    package = pkgs.noctalia;
    systemd.enable = true;
  };

  # v5 loads config by merging every *.toml in $XDG_CONFIG_HOME/noctalia, then
  # layering $XDG_STATE_HOME/noctalia/settings.toml (the app-managed file the
  # settings UI writes) on top. We track that state file in the dotfiles repo
  # via an out-of-store symlink so tweaks made through the UI persist to git.
  # noctalia writes atomically and resolves symlinks, so live saves write
  # through to the repo and the symlink survives.
  xdg.stateFile."noctalia/settings.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${common.dotfilesDir}/noctalia/settings.toml";
}
