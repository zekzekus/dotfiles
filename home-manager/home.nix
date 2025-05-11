{ pkgs, ... }:

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
  home = {
    username = "${username}";
    homeDirectory = "${homeDir}";

    stateVersion = "24.11";

    packages = with pkgs; [
      # editors
      neovim

      # terminal tools
      bfs
      fzf
      ripgrep
      silver-searcher
      universal-ctags

      # version control
      gh
      git
      git-extras
      tig

      # language runtimes, compilers, interpreters, CLIs
      babashka
      clojure
      deno
      go
      nodejs_23
      python313
      ruby_3_4
      cargo

      # development tools
      devenv
      nil
      nixd

    ];

    file = {
      ".ctags".source = "${dotfilesDir}/ctags/ctags";
      ".hammerspoon".source = "${dotfilesDir}/macosx/hammerspoon";
      ".tmuxinator".source = "${dotfilesDir}/tmuxinator";

      ".config/nvim".source = "${dotfilesDir}/nvim";
      ".config/ghostty".source = "${dotfilesDir}/ghostty";
      ".config/zed/settings.json".source = "${dotfilesDir}/zed/settings.json";
      ".config/zed/themes".source = "${dotfilesDir}/zed/themes";

      "bin/gg".source = "${dotfilesDir}/scripts/tmuxproject.sh";
      "bin/gk".source = "${dotfilesDir}/scripts/tmuxproject.sh";
      "bin/gp".source = "${dotfilesDir}/scripts/tmuxproject.sh";
    };

    sessionPath = [
      "$HOME/bin"
      "/opt/homebrew/bin"
    ];

    sessionVariables = {
      ZEK_DEVEL_HOME = "${develHome}";
      ZEK_DEFAULT_PROJECT_DIR  = "personal";
      ZEK_DEVEL_WORK_HOME = "${workHome}";
      ZEK_DEVEL_PERSONAL_HOME = "${personalHome}";

      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";

      TMUX_FZF_LAUNCH_KEY = "o";
      FZF_DEFAULT_COMMAND = "rg --files --hidden --follow --glob \"!.git/*\"";
      FZF_CTRL_T_COMMAND = "rg --files --hidden --follow --glob \"!.git/*\"";
      FZF_ALT_C_COMMAND = "bfs -type d -nohidden";
      FZF_DEFAULT_OPTS = "--style full";

      HOMEBREW_NO_INSTALL_CLEANUP = 1;
    };

  };
  programs = {
    home-manager.enable = true;
    bash.enable = true;

    git = {
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
          excludesFile = "${dotfilesDir}/git/gitignore_global";
        };
        init = {
          templateDir = "${dotfilesDir}/git/git_template";
        };
        push = {
          default = "current";
        };
      };
    };

    fish = {
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

    starship = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
      settings = {
        cmd_duration.disabled = true;
      };
    };

    tmux = {
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
  };
}
