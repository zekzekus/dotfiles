{ pkgs, common, ... }:
{
  enable = true;
  environmentVariables = {
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

    PNPM_HOME = "${common.homeDir}/.local/share/pnpm";
  };
  settings = {
    show_banner = false;
    completions = {
      algorithm = "fuzzy";
    };
    error_style = "plain";
    table = {
      mode = "reinforced";
    };
  };

  extraEnv = ''
    $env.PATH = ($env.PATH | split row (char esep) | prepend '${common.homeDir}/.local/share/pnpm')
    $env.PATH = ($env.PATH | split row (char esep) | prepend '${common.homeDir}/bin')
  '';
}
