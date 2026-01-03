{ pkgs }:

let
  graphicalSessionTarget = [ "graphical-session.target" ];
in
{
  default = let
    idleLockCmd = "pidof hyprlock || hyprlock";
  in {
    launcher = "hyprlauncher";
    clipboard = "cliphist list | rofi -dmenu | cliphist decode | wl-copy";
    lock = "hyprlock";
    volumeMute = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
    volumeDown = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-";
    volumeUp = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%+";
    brightnessUp = "brightnessctl set +5%";
    brightnessDown = "brightnessctl set 5%-";

    bindType = "exec";

    inherit idleLockCmd;

    waybar.enable = true;
    dankMaterialShell.enable = false;
    caelestia.enable = false;
    noctalia.enable = false;

    packages = with pkgs; [ hyprlauncher hyprpolkitagent ];

    homeFiles = _: {};

    services = {
      cliphist.enable = true;

      mako = {
        enable = true;
        settings = {
          default-timeout = 3000;
          layer = "overlay";
          anchor = "top-right";
        };
      };

      hyprpaper = {
        enable = true;
        settings = {
          preload = "~/Pictures/wallpapers/wallhaven-lyq3kq.jpg";
          wallpaper = ",~/Pictures/wallpapers/wallhaven-lyq3kq.jpg";
          splash = false;
          ipc = "off";
        };
      };

      hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = idleLockCmd;
            before_sleep_cmd = idleLockCmd;
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };
          listener = [
            {
              timeout = 300;
              on-timeout = idleLockCmd;
            }
            {
              timeout = 600;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };
    };

    systemdServices = {
      hyprpolkitagent = {
        Unit = {
          Description = "Hyprland Polkit Authentication Agent";
          PartOf = graphicalSessionTarget;
          After = graphicalSessionTarget;
        };
        Service = {
          ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
          Restart = "on-failure";
          RestartSec = 1;
        };
        Install.WantedBy = graphicalSessionTarget;
      };

      hyprlauncher = {
        Unit = {
          Description = "Hyprlauncher daemon";
          PartOf = graphicalSessionTarget;
          After = graphicalSessionTarget;
        };
        Service = {
          ExecStart = "${pkgs.hyprlauncher}/bin/hyprlauncher -d";
          Restart = "on-failure";
          RestartSec = 1;
        };
        Install.WantedBy = graphicalSessionTarget;
      };
    };

    hyprland.extraBinds = [
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"
    ];
  };

  dms = let
    idleLockCmd = "dms ipc call lock isLocked | grep -q true || dms ipc call lock lock";
  in {
    launcher = "dms ipc spotlight toggle";
    clipboard = "dms ipc call clipboard toggle";
    lock = "dms ipc call lock lock";
    volumeMute = "dms ipc call audio mute";
    volumeDown = "dms ipc call audio decrement 3";
    volumeUp = "dms ipc call audio increment 3";
    brightnessUp = "dms ipc call brightnessctl increment 5";
    brightnessDown = "dms ipc call brightnessctl decrement 5";

    bindType = "exec";

    inherit idleLockCmd;

    waybar.enable = false;
    dankMaterialShell.enable = true;
    caelestia.enable = false;
    noctalia.enable = false;

    packages = [];

    homeFiles = { mkOutOfStoreSymlink, dotfilesDir }: {
      ".config/DankMaterialShell/settings.json".source = mkOutOfStoreSymlink "${dotfilesDir}/dms/settings.json";
    };

    services = {
      cliphist.enable = false;
      mako.enable = false;
      hyprpaper.enable = false;

      hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = idleLockCmd;
            before_sleep_cmd = idleLockCmd;
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };
          listener = [
            {
              timeout = 300;
              on-timeout = idleLockCmd;
            }
            {
              timeout = 600;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };
    };

    systemdServices = {};

    hyprland.extraBinds = [
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"
    ];
  };

  caelestia = let
    idleLockCmd = "caelestia shell -s lock";
  in {
    launcher = "caelestia:launcher";
    clipboard = null;
    lock = "caelestia:lock";
    volumeMute = null;
    volumeDown = null;
    volumeUp = null;
    brightnessUp = "caelestia:brightnessUp";
    brightnessDown = "caelestia:brightnessDown";

    bindType = "global";

    inherit idleLockCmd;

    waybar.enable = false;
    dankMaterialShell.enable = false;
    caelestia.enable = true;
    noctalia.enable = false;

    packages = with pkgs; [ hyprpolkitagent ];

    homeFiles = _: {};

    services = {
      cliphist.enable = true;
      mako.enable = false;
      hyprpaper.enable = false;

      hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = idleLockCmd;
            before_sleep_cmd = idleLockCmd;
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };
          listener = [
            {
              timeout = 300;
              on-timeout = idleLockCmd;
            }
            {
              timeout = 600;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };
    };

    systemdServices = {
      hyprpolkitagent = {
        Unit = {
          Description = "Hyprland Polkit Authentication Agent";
          PartOf = graphicalSessionTarget;
          After = graphicalSessionTarget;
        };
        Service = {
          ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
          Restart = "on-failure";
          RestartSec = 1;
        };
        Install.WantedBy = graphicalSessionTarget;
      };
    };

    hyprland.extraBinds = [
      "$mod, V, exec, pkill fuzzel || caelestia clipboard"

      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioLowerVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-"
      ", XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 3%+"

      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"

      "$mod SHIFT, Escape, global, caelestia:session"
      "$mod, Delete, global, caelestia:clearNotifs"
    ];
  };

  noctalia = let
    idleLockCmd = "noctalia-shell ipc call lockScreen lock";
  in {
    launcher = "noctalia-shell ipc call launcher toggle";
    clipboard = "noctalia-shell ipc call launcher clipboard";
    lock = "noctalia-shell ipc call lockScreen lock";
    volumeMute = "noctalia-shell ipc call volume muteOutput";
    volumeDown = "noctalia-shell ipc call volume decrease";
    volumeUp = "noctalia-shell ipc call volume increase";
    brightnessUp = "noctalia-shell ipc call brightness increase";
    brightnessDown = "noctalia-shell ipc call brightness decrease";

    bindType = "exec";

    inherit idleLockCmd;

    waybar.enable = false;
    dankMaterialShell.enable = false;
    caelestia.enable = false;
    noctalia.enable = true;

    packages = with pkgs; [ hyprpolkitagent ];

    homeFiles = _: {};

    services = {
      cliphist.enable = true;
      mako.enable = false;
      hyprpaper.enable = false;

      hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = idleLockCmd;
            before_sleep_cmd = idleLockCmd;
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };
          listener = [
            {
              timeout = 300;
              on-timeout = idleLockCmd;
            }
            {
              timeout = 600;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };
    };

    systemdServices = {
      hyprpolkitagent = {
        Unit = {
          Description = "Hyprland Polkit Authentication Agent";
          PartOf = graphicalSessionTarget;
          After = graphicalSessionTarget;
        };
        Service = {
          ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
          Restart = "on-failure";
          RestartSec = 1;
        };
        Install.WantedBy = graphicalSessionTarget;
      };
    };

    hyprland.extraBinds = [
      ", XF86AudioPlay, exec, noctalia-shell ipc call media playPause"
      ", XF86AudioNext, exec, noctalia-shell ipc call media next"
      ", XF86AudioPrev, exec, noctalia-shell ipc call media previous"

      "$mod, C, exec, noctalia-shell ipc call controlCenter toggle"
      "$mod SHIFT, S, exec, noctalia-shell ipc call settings toggle"

      "$mod SHIFT, Escape, exec, noctalia-shell ipc call sessionMenu toggle"
      "$mod, Delete, exec, noctalia-shell ipc call notifications dismissAll"
      "$mod SHIFT, Delete, exec, noctalia-shell ipc call notifications clear"

      "$mod, D, exec, noctalia-shell ipc call darkMode toggle"
      "$mod, W, exec, noctalia-shell ipc call wallpaper toggle"
    ];
  };
}
