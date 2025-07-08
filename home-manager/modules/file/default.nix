{ ... }:

let
  common = import ../common.nix { };
in
{
  ".ctags".source = "${common.dotfilesDir}/ctags/ctags";
  ".doom.d".source = "${common.dotfilesDir}/emacs/doom";
  ".hammerspoon".source = "${common.dotfilesDir}/macosx/hammerspoon";
  ".tmuxinator".source = "${common.dotfilesDir}/tmuxinator";

  ".config/ghostty".source = "${common.dotfilesDir}/ghostty";
  ".config/nvim".source = "${common.dotfilesDir}/nvim";
  ".config/zed/settings.json".source = "${common.dotfilesDir}/zed/settings.json";
  ".config/zed/themes".source = "${common.dotfilesDir}/zed/themes";

  "bin/gg".source = "${common.dotfilesDir}/scripts/tmuxproject.sh";
  "bin/gk".source = "${common.dotfilesDir}/scripts/tmuxproject.sh";
  "bin/gp".source = "${common.dotfilesDir}/scripts/tmuxproject.sh";
}
