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
    # my editor
    neovim

    # terminal tools
    ripgrep
    fzf
    bfs
    universal-ctags
    silver-searcher

    # version control
    git
    tig

    # programming languages
    clojure
    deno
    nodejs_23
    python313
    ruby_3_4
    rustup
    zig

    # programming language tools
    python313Packages.pip
    poetry
  ];

  home.file = {
    ".ctags".source = "${dotfilesDir}/ctags/ctags";
    ".hammerspoon".source = "${dotfilesDir}/macosx/hammerspoon";
    ".tmuxinator".source = "${dotfilesDir}/tmuxinator";
    ".git_template".source = "${dotfilesDir}/git/git_template";
    ".gitignore_global".source = "${dotfilesDir}/git/gitignore_global";

    ".config/nvim".source = "${dotfilesDir}/nvim";
    ".config/ghostty".source = "${dotfilesDir}/ghostty";

    "bin/gg".source = "${dotfilesDir}/scripts/tmuxproject.sh";
    "bin/gk".source = "${dotfilesDir}/scripts/tmuxproject.sh";
    "bin/gp".source = "${dotfilesDir}/scripts/tmuxproject.sh";
  };

  home.sessionPath = [
    "$HOME/bin"
  ];

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

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Zekeriya Koc";
    userEmail = "zekzekus@gmail.com";
    signing.key = "6716516470AD2D7A";
    signing.signByDefault = false;
    delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
      };
    };

    extraConfig = {
      core = {
        excludesFile = "${homeDir}/.gitignore_global";
      };
      init = {
        templateDir = "${homeDir}/.git_template";
      };
      push = {
        default = "current";
      };
    };
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      mux = "tmuxinator";
    };
    plugins =
    [
      {
        name = "nix-env";
        src = pkgs.fetchFromGitHub {
          owner = "lilyball";
          repo = "nix-env.fish";
          rev = "7b65bd228429e852c8fdfa07601159130a818cfa";
          sha256 = "sha256-RG/0rfhgq6aEKNZ0XwIqOaZ6K5S4+/Y5EEMnIdtfPhk=";
        };
      }
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "067e867debee59aee231e789fc4631f80fa5788e";
          sha256 = "sha256-emmjTsqt8bdI5qpx1bAzhVACkg0MNB/uffaRjjeuFxU=";
        };
      }
    ];
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      cmd_duration.disabled = true;
    };
  };

  programs.tmux = {
    enable = true;
    tmuxinator.enable = true;
    shell = "${pkgs.fish}/bin/fish";
    escapeTime = 0;
    prefix = "C-a";
    baseIndex = 0;
    mouse = true;
    terminal = "xterm-ghostty";
    keyMode = "vi";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      urlview
      extrakto
      tmux-fzf
    ];
    extraConfig = ''
set -g default-command "${pkgs.fish}/bin/fish"
set -g visual-activity on
setw -g pane-base-index 1
setw -g monitor-activity on
unbind C-b
bind C-s send-prefix
bind C-l send-keys 'C-l'
bind C-h send-keys 'C-h'
bind C-a last-window
bind-key Escape copy-mode
bind-key p paste-buffer
bind-key -T copy-mode-vi 'v' send -X begin-selection
bind-key -T copy-mode-vi 'V' send -X select-line
bind-key -T copy-mode-vi 'r' send -X rectangle-toggle
bind-key -T copy-mode-vi 'y' send -X copy-pipe-and-cancel "pbcopy"
if-shell "test -f ${dotfilesDir}/tmux/tmuxline.gruvbox.conf" "source ${dotfilesDir}/tmux/tmuxline.gruvbox.conf"
    '';
  };
}
