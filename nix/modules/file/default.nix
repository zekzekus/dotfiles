{
  config,
  common,
  ...
}: {
  home.file = {
    ".ctags".source = config.lib.file.mkOutOfStoreSymlink "${common.dotfilesDir}/ctags/ctags";
    ".tmuxinator".source = config.lib.file.mkOutOfStoreSymlink "${common.dotfilesDir}/tmuxinator";
    ".config/doom".source = config.lib.file.mkOutOfStoreSymlink "${common.dotfilesDir}/misc/emacs/doom";

    "bin/gg".source = "${common.dotfilesDir}/scripts/tmuxproject.sh";
    "bin/gk".source = "${common.dotfilesDir}/scripts/tmuxproject.sh";
    "bin/gp".source = "${common.dotfilesDir}/scripts/tmuxproject.sh";
  };
}
