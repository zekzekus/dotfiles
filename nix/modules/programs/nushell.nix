{
  pkgs,
  lib,
  common,
  ...
}: let
  darwinPaths = ''
    $env.PATH = ($env.PATH | split row (char esep) | prepend '/run/current-system/sw/bin')
    $env.PATH = ($env.PATH | split row (char esep) | prepend '/nix/var/nix/profiles/default/bin')
    $env.PATH = ($env.PATH | split row (char esep) | prepend '/etc/profiles/per-user/${common.username}/bin')
    $env.PATH = ($env.PATH | split row (char esep) | prepend '/opt/homebrew/bin')
  '';

  mkNushellPathPrepends = paths:
    lib.concatMapStringsSep "\n"
    (p: "$env.PATH = ($env.PATH | split row (char esep) | prepend '${p}')")
    (lib.reverseList paths);
in {
  programs.nushell = {
    enable = true;
    environmentVariables = common.sessionVariables;
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
      ${
        if pkgs.stdenv.isDarwin
        then darwinPaths
        else ""
      }
      ${mkNushellPathPrepends common.sessionPath}
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

      $env.config = ($env.config? | default {})
      $env.config.hooks = ($env.config.hooks? | default {})
      $env.config.hooks.pre_prompt = (
          $env.config.hooks.pre_prompt?
          | default []
          | append {||
              ${pkgs.direnv}/bin/direnv export json
              | from json --strict
              | default {}
              | items {|key, value|
                  let value = do (
                      {
                        "PATH": {
                          from_string: {|s| $s | split row (char esep) | path expand --no-symlink }
                          to_string: {|v| $v | path expand --no-symlink | str join (char esep) }
                        }
                      }
                      | merge ($env.ENV_CONVERSIONS? | default {})
                      | get ([[value, optional, insensitive]; [$key, true, true] [from_string, true, false]] | into cell-path)
                      | if ($in | is-empty) { {|x| $x} } else { $in }
                  ) $value
                  return [ $key $value ]
              }
              | into record
              | load-env
          }
      )

      if 'ATUIN_SESSION' not-in $env or ('ATUIN_SHLVL' not-in $env) or ($env.ATUIN_SHLVL != ($env.SHLVL? | default "")) {
        $env.ATUIN_SESSION = (^atuin uuid | str trim | str replace -a "-" "")
        $env.ATUIN_SHLVL = ($env.SHLVL? | default "")
      }
      hide-env -i ATUIN_HISTORY_ID

      let ATUIN_KEYBINDING_TOKEN = $"# (random uuid)"

      let _atuin_pre_execution = {||
        if ($nu | get history-enabled?) == false { return }
        let cmd = (commandline)
        if ($cmd | is-empty) { return }
        if ($cmd | str starts-with $ATUIN_KEYBINDING_TOKEN) { return }
        let res = (do -i { ^atuin history start -- $cmd } | complete)
        if $res.exit_code == 0 {
          let id = ($res.stdout | str trim)
          if ($id | is-not-empty) {
            $env.ATUIN_HISTORY_ID = $id
          }
        }
      }

      let _atuin_pre_prompt = {||
        let last_exit = $env.LAST_EXIT_CODE
        if 'ATUIN_HISTORY_ID' not-in $env { return }
        do -i { ^atuin history end $'--exit=($last_exit)' -- $env.ATUIN_HISTORY_ID } | complete | ignore
        hide-env ATUIN_HISTORY_ID
      }

      def _atuin_search_cmd [...flags: string] {
        [
          $ATUIN_KEYBINDING_TOKEN,
          ([
            `with-env { ATUIN_LOG: error, ATUIN_QUERY: (commandline), ATUIN_SHELL: nu } {`,
                ([
                    'let output = (run-external atuin search',
                    ($flags | append [--interactive] | each {|e| $'"($e)"'}),
                    'e>| str trim)',
                ] | flatten | str join ' '),
                'if ($output | str starts-with "__atuin_accept__:") {',
                'commandline edit --accept ($output | str replace "__atuin_accept__:" "")',
                '} else {',
                'commandline edit $output',
                '}',
            `}`,
          ] | flatten | str join "\n"),
        ] | str join "\n"
      }

      $env.config.hooks.pre_execution = (
        $env.config.hooks.pre_execution?
        | default []
        | append $_atuin_pre_execution
      )
      $env.config.hooks.pre_prompt = (
        $env.config.hooks.pre_prompt?
        | default []
        | append $_atuin_pre_prompt
      )

      $env.config = ($env.config | default [] keybindings)
      $env.config = (
        $env.config | upsert keybindings (
          $env.config.keybindings
          | append {
            name: atuin
            modifier: control
            keycode: char_r
            mode: [emacs, vi_normal, vi_insert]
            event: { send: executehostcommand cmd: (_atuin_search_cmd) }
          }
        )
      )
      $env.config = (
        $env.config | upsert keybindings (
          $env.config.keybindings
          | append {
            name: atuin
            modifier: none
            keycode: up
            mode: [emacs, vi_normal, vi_insert]
            event: {
              until: [
                {send: menuup}
                {send: executehostcommand cmd: (_atuin_search_cmd '--shell-up-key-binding') }
              ]
            }
          }
        )
      )
    '';
  };
}
