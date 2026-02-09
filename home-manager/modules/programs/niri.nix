{
  pkgs,
  common,
  ...
}: let
  spawnApp = command: "spawn-sh \"${pkgs.uwsm}/bin/uwsm-app -- ${command}\"";
  spawnCmd = command: "spawn-sh \"${command}\"";
  bind = key: action: "${key} { ${action}; }";
  bindRepeat = key: action: "${key} repeat=false { ${action}; }";
  bindLocked = key: action: "${key} allow-when-locked=true { ${action}; }";
  bindInhibitSafe = key: action: "${key} allow-inhibiting=false { ${action}; }";
in {
  config = {
    xdg.configFile."niri/config.kdl".force = true;
    xdg.configFile."niri/config.kdl".text = ''
      input {
        mod-key "Super"
        keyboard {
          xkb {
            layout "tr"
            variant "alt"
            options "compose:caps"
          }
          repeat-delay 300
          repeat-rate 60
          numlock
        }
        touchpad {
          natural-scroll
          scroll-factor 0.4
        }
      }

      layout {
        gaps 8
        focus-ring { off; }
      }

      window-rule {
        match title=r#"Picture.?in.?[Pp]icture"#
        open-floating true
        default-column-width { fixed 600; }
        default-window-height { fixed 338; }
        focus-ring { off; }
      }

      window-rule {
        match app-id=r#"^org\.quickshell$"#
        open-floating true
      }

      window-rule {
        match app-id=r#"blueman-manager"#
        open-floating true
      }

      window-rule {
        match app-id=r#"^nemo$"#
        open-floating true
        default-column-width { fixed 1200; }
        default-window-height { fixed 700; }
      }

      window-rule {
        match app-id=r#"^org\.pulseaudio\.pavucontrol$"#
        open-floating true
        default-column-width { fixed 1000; }
        default-window-height { fixed 450; }
      }

      window-rule {
        match app-id=r#"^(one\.alynx\.showmethekey|showmethekey-gtk)$"#
        open-floating true
        focus-ring { off; }
      }

      binds {
        ${bind "Mod+Space" (spawnCmd "noctalia-shell ipc call launcher toggle")}
        ${bind "Mod+V" (spawnCmd "noctalia-shell ipc call launcher clipboard")}
        ${bind "Mod+Shift+Ctrl+L" (spawnCmd "noctalia-shell ipc call lockScreen lock")}

        ${bindLocked "XF86AudioMute" (spawnCmd "noctalia-shell ipc call volume muteOutput")}
        ${bindLocked "XF86AudioLowerVolume" (spawnCmd "noctalia-shell ipc call volume decrease")}
        ${bindLocked "XF86AudioRaiseVolume" (spawnCmd "noctalia-shell ipc call volume increase")}
        ${bindLocked "XF86AudioMicMute" (spawnCmd "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")}

        ${bindLocked "XF86MonBrightnessUp" (spawnCmd "noctalia-shell ipc call brightness increase")}
        ${bindLocked "XF86MonBrightnessDown" (spawnCmd "noctalia-shell ipc call brightness decrease")}

        ${bind "XF86AudioPlay" (spawnCmd "noctalia-shell ipc call media playPause")}
        ${bind "XF86AudioNext" (spawnCmd "noctalia-shell ipc call media next")}
        ${bind "XF86AudioPrev" (spawnCmd "noctalia-shell ipc call media previous")}

        ${bind "Mod+Shift+D" (spawnCmd "noctalia-shell ipc call darkMode toggle")}
        ${bind "Mod+Shift+W" (spawnCmd "noctalia-shell ipc call wallpaper toggle")}
        ${bind "Mod+Shift+C" (spawnCmd "noctalia-shell ipc call controlCenter toggle")}
        ${bind "Mod+Shift+S" (spawnCmd "noctalia-shell ipc call settings toggle")}
        ${bind "Mod+Shift+Escape" (spawnCmd "noctalia-shell ipc call sessionMenu toggle")}

        ${bind "Mod+Return" (spawnApp "ghostty +new-window")}
        ${bind "Mod+B" (spawnApp "helium")}
        ${bind "Mod+E" (spawnApp "nemo")}

        ${bindRepeat "Mod+Q" "close-window"}

        ${bind "Mod+H" "focus-column-left"}
        ${bind "Mod+J" "focus-window-down"}
        ${bind "Mod+K" "focus-window-up"}
        ${bind "Mod+L" "focus-column-right"}

        ${bind "Mod+Shift+H" "move-column-left"}
        ${bind "Mod+Shift+J" "move-window-down"}
        ${bind "Mod+Shift+K" "move-window-up"}
        ${bind "Mod+Shift+L" "move-column-right"}

        ${bind "Alt+J" "toggle-column-tabbed-display"}
        ${bind "Alt+P" "consume-or-expel-window-right"}
        ${bind "Alt+V" "toggle-window-floating"}

        ${bind "Mod+1" "focus-workspace 1"}
        ${bind "Mod+2" "focus-workspace 2"}
        ${bind "Mod+3" "focus-workspace 3"}
        ${bind "Mod+4" "focus-workspace 4"}
        ${bind "Mod+5" "focus-workspace 5"}

        ${bind "Mod+Shift+1" "move-column-to-workspace 1"}
        ${bind "Mod+Shift+2" "move-column-to-workspace 2"}
        ${bind "Mod+Shift+3" "move-column-to-workspace 3"}
        ${bind "Mod+Shift+4" "move-column-to-workspace 4"}
        ${bind "Mod+Shift+5" "move-column-to-workspace 5"}

        ${bind "Mod+WheelScrollDown" "focus-workspace-down"}
        ${bind "Mod+WheelScrollUp" "focus-workspace-up"}

        ${bind "Mod+Shift+Ctrl+3" (spawnCmd "${common.dotfilesDir}/scripts/screenshot-full")}
        ${bind "Mod+Shift+Ctrl+4" (spawnCmd "${common.dotfilesDir}/scripts/screenshot-area")}
        ${bind "Mod+Shift+Ctrl+5" (spawnApp "gpu-screen-recorder-gtk")}

        ${bindInhibitSafe "Mod+Escape" "toggle-keyboard-shortcuts-inhibit"}
      }
    '';
  };
}
