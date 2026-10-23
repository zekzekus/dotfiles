{
  config,
  pkgs,
  ...
}: {
  programs.nushell = {
    enable = true;
    # Evaluate HM session variables/PATH and the integrated NixOS/nix-darwin
    # environment at startup, including POSIX expressions in their values.
    loadSessionVariables = true;
    settings = {
      show_banner = false;
      completions = {
        # Fuzzy matching searches whole registered subcommand names, making
        # unrelated commands (notably Niri's many externs) pollute the menu.
        algorithm = "prefix";
      };
      table = {
        mode = "default";
      };
    };

    extraEnv = ''
      $env.GPG_TTY = (tty | str trim)
    '';

    extraConfig = ''
      def nixinit [target: string] {
        nix flake init --template $"https://flakehub.com/f/the-nix-way/dev-templates/*#($target)"
      }

      let fish_completer = {|place|
        # Pass the command as data, not interpolated Fish code. HM only adds
        # its man-page completions in interactive Fish, so include them here.
        ${pkgs.fish}/bin/fish --command '
          set --append fish_complete_path $argv[2]
          complete --do-complete="$argv[1]"
        ' -- ($place.command | str join ' ') '${config.xdg.dataHome}/fish/home-manager/generated_completions'
        | lines
        | split column --number 2 (char tab) value description
        | update value {|row|
          let value = $row.value
          let need_quote = ['\' ',' '[' ']' '(' ')' '{' '}' ' ' (char tab) "'" '"' '`' '$' ';' '#' '|' '&' '<' '>'] | any { $in in $value }
          if $need_quote {
            let value = if ($value | str starts-with '~') and ($value | path exists) {
              $value | path expand --no-symlink
            } else { $value }
            $value | to nuon
          } else { $value }
        }
      }

      let carapace_completer = {|place|
        CARAPACE_LENIENT=1 carapace $place.command.0 nushell ...$place.command | from json
      }

      let external_completer = {|place|
        # Nushell already expands aliases, including their fixed arguments.
        let completions = if $place.command.0 in [asdf mvn tailscale] {
          do $fish_completer $place
        } else {
          # Unsupported commands, empty results and failures fall back to Fish.
          let carapace = try { do $carapace_completer $place } catch { null }
          if ($carapace | is-empty) {
            do $fish_completer $place
          } else { $carapace }
        }

        # null lets Nushell supply file completions when neither has an answer.
        if ($completions | is-empty) { null } else { $completions }
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
            name: atuin_search
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
            name: atuin_up
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
