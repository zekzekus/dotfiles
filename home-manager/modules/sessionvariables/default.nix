{ pkgs, ... }:

let
  common = import ../common.nix { inherit pkgs; };
in
{
  NIXPKGS_ALLOW_UNFREE = 1;

  ZEK_DEVEL_HOME = "${common.develHome}";
  ZEK_DEFAULT_PROJECT_DIR = "personal";
  ZEK_DEVEL_WORK_HOME = "${common.workHome}";
  ZEK_DEVEL_PERSONAL_HOME = "${common.personalHome}";

  EDITOR = "nvim";
  MANPAGER = "nvim +Man!";

  TMUX_FZF_LAUNCH_KEY = "o";
  FZF_DEFAULT_COMMAND = "rg --files --hidden --follow --glob \"!.git/*\"";
  FZF_CTRL_T_COMMAND = "rg --files --hidden --follow --glob \"!.git/*\"";
  FZF_ALT_C_COMMAND = "bfs -type d -nohidden";
  FZF_DEFAULT_OPTS = "--style full";

  HOMEBREW_NO_INSTALL_CLEANUP = 1;
}