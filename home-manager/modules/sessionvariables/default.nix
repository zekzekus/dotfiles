{ common, ... }:

{
  ZEK_DEVEL_HOME = common.develHome;
  ZEK_DEFAULT_PROJECT_DIR = common.defaultProjectDir;
  ZEK_DEVEL_WORK_HOME = common.workHome;
  ZEK_DEVEL_PERSONAL_HOME = common.personalHome;

  EDITOR = "nvim";
  MANPAGER = "nvim +Man!";

  TMUX_FZF_LAUNCH_KEY = "o";
  FZF_DEFAULT_COMMAND = "rg --files --hidden --follow --glob \"!.git/*\"";
  FZF_CTRL_T_COMMAND = "rg --files --hidden --follow --glob \"!.git/*\"";
  FZF_ALT_C_COMMAND = "bfs -type d -nohidden";

  PNPM_HOME = "$HOME/.local/share/pnpm";
}
