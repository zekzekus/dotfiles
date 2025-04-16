{ config, pkgs, ... }:

let
  username = "zekus";
  homeDir = "/Users/${username}";
  dotfilesDir = "${homeDir}/devel/tools/dotfiles";
  develHome = "${homeDir}/devel/projects";
  defaultProjectDir = "personal";
  workHome = "${develHome}/${defaultProjectDir}";
  personalHome = "${develHome}/personal";
in
{
  home.username = "${username}";
  home.homeDirectory = "${homeDir}";

  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # files waiting: tmux, fish, neovim
    neovim

    ripgrep
    fzf
    bfs
    universal-ctags
    silver-searcher

    git
    tig
    delta

    tmux
    extract_url

    fish
    starship

    clojure
  ];

  home.file = {
    ".ctags".source = "${dotfilesDir}/ctags/ctags";
    ".hammerspoon".source = "${dotfilesDir}/macosx/hammerspoon";
    ".tmuxinator".source = "${dotfilesDir}/tmuxinator";
    ".gitconfig".source = "${dotfilesDir}/git/gitconfig";
    ".git_template".source = "${dotfilesDir}/git/git_template";
    ".gitignore_global".source = "${dotfilesDir}/git/gitignore_global";

    ".config/nvim".source = "${dotfilesDir}/nvim";
    ".config/ghostty".source = "${dotfilesDir}/ghostty";
    ".config/starship.toml".source = "${dotfilesDir}/starship/starship.toml";

    "bin/gg".source = "${dotfilesDir}/scripts/tmuxproject.sh";
    "bin/gk".source = "${dotfilesDir}/scripts/tmuxproject.sh";
    "bin/gp".source = "${dotfilesDir}/scripts/tmuxproject.sh";
  };

  home.sessionVariables = {
    ZEK_DEVEL_HOME = "${develHome}";
    ZEK_DEFAULT_PROJECT_DIR  = "personal";
    ZEK_DEVEL_WORK_HOME = "${develHome}/${defaultProjectDir}";
    ZEK_DEVEL_PERSONAL_HOME = "${develHome}/personal";

    LANG = "en_US.UTF-8";
    LC_COLLATE = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_MESSAGES = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";

    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";

    TMUX_FZF_LAUNCH_KEY = "o";
    FZF_DEFAULT_COMMAND = "rg --files --hidden --follow --glob \"!.git/*\"";
    FZF_CTRL_T_COMMAND = "rg --files --hidden --follow --glob \"!.git/*\"";
    FZF_ALT_C_COMMAND = "bfs -type d -nohidden";
    FZF_DEFAULT_OPTS = "--style full";

    HOMEBREW_NO_INSTALL_CLEANUP = 1;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
