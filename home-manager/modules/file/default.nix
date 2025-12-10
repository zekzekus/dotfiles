{ common, ... }:

{
  home.file = {
    ".ctags".source = "${common.dotfilesDir}/ctags/ctags";
    ".tmuxinator".source = "${common.dotfilesDir}/tmuxinator";

    ".config/nvim".source = "${common.dotfilesDir}/nvim";

    "bin/gg".source = "${common.dotfilesDir}/scripts/tmuxproject.sh";
    "bin/gk".source = "${common.dotfilesDir}/scripts/tmuxproject.sh";
    "bin/gp".source = "${common.dotfilesDir}/scripts/tmuxproject.sh";
  };
}
