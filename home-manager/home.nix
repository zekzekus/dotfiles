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
      emacs

      # terminal tools
      bfs
      fd
      fzf
      ripgrep
      silver-searcher
      universal-ctags
      wget

      # version control
      gh
      git
      git-extras
      mercurial
      jujutsu
      tig

      # language runtimes, compilers, interpreters, CLIs
      babashka
      cargo
      clojure
      deno
      go
      nodejs_24
      python313
      python313Packages.pip
      ruby_3_4
      uv

      # development tools
      claude-code
      cmake
      devenv
      glibtool
      nil
      nixd
      tree-sitter

    ];

    file = {
      ".ctags".source = "${dotfilesDir}/ctags/ctags";
      ".doom.d".source = "${dotfilesDir}/emacs/doom";
      ".hammerspoon".source = "${dotfilesDir}/macosx/hammerspoon";
      ".tmuxinator".source = "${dotfilesDir}/tmuxinator";

      ".config/ghostty".source = "${dotfilesDir}/ghostty";
      ".config/nvim".source = "${dotfilesDir}/nvim";
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
      NIXPKGS_ALLOW_UNFREE=1;

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

    aerospace = {
      enable = true;
      userSettings = {
        after-startup-command = [
          "exec-and-forget sketchybar"
        ];
        exec-on-workspace-change = [
          "/bin/bash"
          "-c"
          "sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
        ];
        on-window-detected = [
          {
            check-further-callbacks = false;
            "if" = {
              app-id = "com.mitchellh.ghostty";
            };
            run = [
              "layout floating"
            ];
          }
        ];
        accordion-padding = 50;
        gaps = {
          inner.horizontal = 10;
          inner.vertical = 10;
          outer.left = 10;
          outer.bottom = 10;
          outer.top = 10;
          outer.right = 10;
        };
        mode.main.binding = {
          alt-slash = "layout tiles horizontal vertical";
          alt-comma = "layout accordion horizontal vertical";

          alt-h = "focus left";
          alt-j = "focus down";
          alt-k = "focus up";
          alt-l = "focus right";

          alt-shift-h = "move left";
          alt-shift-j = "move down";
          alt-shift-k = "move up";
          alt-shift-l = "move right";

          alt-minus = "resize smart -50";
          alt-equal = "resize smart +50" ;

          alt-1 = "workspace 1";
          alt-2 = "workspace 2";
          alt-3 = "workspace 3";
          alt-4 = "workspace 4";
          alt-5 = "workspace 5";

          alt-shift-1 = "move-node-to-workspace 1";
          alt-shift-2 = "move-node-to-workspace 2";
          alt-shift-3 = "move-node-to-workspace 3";
          alt-shift-4 = "move-node-to-workspace 4";
          alt-shift-5 = "move-node-to-workspace 5";

          alt-tab = "workspace-back-and-forth";
          alt-shift-tab = "move-workspace-to-monitor --wrap-around next";
          alt-shift-semicolon = "mode service";
        };
        mode.service.binding = {
          esc = ["reload-config" "mode main"];
          r = ["flatten-workspace-tree" "mode main"];
          f = ["layout floating tiling" "mode main"];
          backspace = ["close-all-windows-but-current" "mode main"];

          alt-shift-h = ["join-with left" "mode main"];
          alt-shift-j = ["join-with down" "mode main"];
          alt-shift-k = ["join-with up" "mode main"];
          alt-shift-l = ["join-with right" "mode main"];
        };
      };
    };

    sketchybar = {
      enable = false;
      config = {
        source = "${dotfilesDir}/sketchybar";
        recursive = true;
      };
    };
  };

  services = {
    jankyborders = {
      enable = true;
      settings = {
        style = "round";
        width = 6.0;
        hidpi = "on";
        active_color = "0xfff7768e";
        inactive_color = "0xffe1e3e4";
      };
    };
  };
}
