{ pkgs, common, ... }:

let
  darwinPaths = ''
    $env.PATH = ($env.PATH | split row (char esep) | prepend '/run/current-system/sw/bin')
    $env.PATH = ($env.PATH | split row (char esep) | prepend '/nix/var/nix/profiles/default/bin')
    $env.PATH = ($env.PATH | split row (char esep) | prepend '/etc/profiles/per-user/${common.username}/bin')
  '';
in
{
  programs.nushell = {
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
      table = {
        mode = "default";
      };
    };

    extraEnv = ''
      ${if pkgs.stdenv.isDarwin then darwinPaths else ""}
      $env.PATH = ($env.PATH | split row (char esep) | prepend '${common.homeDir}/.local/share/pnpm')
      $env.PATH = ($env.PATH | split row (char esep) | prepend '${common.homeDir}/.local/share/coursier/bin')
      $env.PATH = ($env.PATH | split row (char esep) | prepend '${common.homeDir}/bin')
      $env.GPG_TTY = (tty | str trim)
    '';

    extraConfig = ''
      def nixinit [target: string] {
        nix flake init --template $"https://flakehub.com/f/the-nix-way/dev-templates/*#($target)"
      }

      let fish_completer = {|spans|
        # This effectively passes the cursor position and command to fish
        ${pkgs.fish}/bin/fish --command $'complete "--do-complete=($spans | str join " ")"'
        | from tsv --flexible --noheaders --no-infer
        | rename value description
      }

      let carapace_completer = {|spans|
        carapace $spans.0 nushell ...$spans | from json
      }

      let external_completer = {|spans|
        let expanded_alias = scope aliases | where name == $spans.0 | get -o 0.expansion

        let spans = if $expanded_alias != null {
          $spans | skip 1 | prepend ($expanded_alias | split row ' ' | take 1)
        } else {
          $spans
        }

        match $spans.0 {
          # Use Fish for tools where it shines
          asdf => $fish_completer
          mvn => $fish_completer
          tailscale => $fish_completer

          # Default to Carapace for everything else
          _ => $carapace_completer
        } | do $in $spans
      }

      $env.config.completions.external = {
        enable: true
        max_results: 100
        completer: $external_completer
      }
    '';
  };
}
