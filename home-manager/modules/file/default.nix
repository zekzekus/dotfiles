{ common, ... }:

{
  ".ctags".source = "${common.dotfilesDir}/ctags/ctags";
  ".doom.d".source = "${common.dotfilesDir}/emacs/doom";
  ".tmuxinator".source = "${common.dotfilesDir}/tmuxinator";

  ".config/nvim".source = "${common.dotfilesDir}/nvim";
  # ".config/zed/settings.json".source = "${common.dotfilesDir}/zed/settings.json";
  # ".config/zed/themes".source = "${common.dotfilesDir}/zed/themes";

  "bin/gg".source = "${common.dotfilesDir}/scripts/tmuxproject.sh";
  "bin/gk".source = "${common.dotfilesDir}/scripts/tmuxproject.sh";
  "bin/gp".source = "${common.dotfilesDir}/scripts/tmuxproject.sh";

  ".config/helix/config.toml".source = "${common.dotfilesDir}/misc/helix/config.toml";
}
