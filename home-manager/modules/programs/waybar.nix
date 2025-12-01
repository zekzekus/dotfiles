{ pkgs, ... }:

{
  enable = false;
  systemd.enable = false;
  settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 30;
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "hyprland/window" ];
      modules-right = [ "custom/theme-light" "custom/theme-dark" "tray" "pulseaudio" "battery" "clock" ];

      "custom/theme-light" = {
        format = " Light ";
        on-click = "theme-light";
        tooltip = false;
      };

      "custom/theme-dark" = {
        format = " Dark ";
        on-click = "theme-dark";
        tooltip = false;
      };

      "hyprland/workspaces" = {
        format = "{id}";
      };

      "hyprland/window" = {
        max-length = 50;
      };

      bluetooth = {
        format = " {status}";
        format-disabled = "";
        format-connected = " {num_connections}";
        tooltip-format = "{controller_alias}\t{controller_address}";
        tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
        on-click = "blueman-manager";
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = " Muted";
        format-icons = {
          default = [ "" "" "" ];
        };
        on-click = "pavucontrol";
      };

      battery = {
        format = "{icon} {capacity}%";
        format-icons = [ "" "" "" "" "" ];
      };

      clock = {
        format = " {:%H:%M}";
        format-alt = " {:%Y-%m-%d}";
        tooltip = false;
      };

      tray = {
        spacing = 10;
      };
    };
  };
  style = ''
    * {
      border: none;
      border-radius: 0;
      min-height: 0;
      font-family: JetBrainsMono Nerd Font;
      font-size: 13px;
    }

    window#waybar {
      background-color: #1d2021;
      transition-property: background-color;
      transition-duration: 0.5s;
    }

    window#waybar.hidden {
      opacity: 0.5;
    }

    #workspaces {
      background-color: transparent;
    }

    #workspaces button {
      all: initial;
      /* Remove GTK theme values (waybar #1351) */
      min-width: 0;
      /* Fix weird spacing in materia (waybar #450) */
      box-shadow: inset 0 -3px transparent;
      /* Use box-shadow instead of border so the text isn't offset */
      padding: 6px 18px;
      margin: 6px 3px;
      border-radius: 4px;
      background-color: #1e1e2e;
      color: #cdd6f4;
    }

    #workspaces button.active {
      color: #1e1e2e;
      background-color: #cdd6f4;
    }

    #workspaces button:hover {
      box-shadow: inherit;
      text-shadow: inherit;
      color: #1e1e2e;
      background-color: #cdd6f4;
    }

    #workspaces button.urgent {
      background-color: #f38ba8;
    }

    #memory,
    #custom-power,
    #battery,
    #backlight,
    #wireplumber,
    #network,
    #clock,
    #tray {
      border-radius: 4px;
      margin: 6px 3px;
      padding: 6px 12px;
      background-color: #1e1e2e;
      color: #181825;
    }

    #custom-power {
      margin-right: 6px;
    }

    #custom-logo {
      padding-right: 7px;
      padding-left: 7px;
      margin-left: 5px;
      font-size: 15px;
      border-radius: 8px 0px 0px 8px;
      color: #1793d1;
    }

    #memory {
      background-color: #fab387;
    }

    #battery {
      background-color: #f38ba8;
    }

    #battery.warning,
    #battery.critical,
    #battery.urgent {
      background-color: #ff0000;
      color: #FFFF00;
    }

    #battery.charging {
      background-color: #a6e3a1;
      color: #181825;
    }

    #backlight {
      background-color: #fab387;
    }

    #wireplumber {
      background-color: #f9e2af;
    }

    #network {
      background-color: #94e2d5;
      padding-right: 17px;
    }

    #clock {
      font-family: JetBrainsMono Nerd Font;
      background-color: #cba6f7;
    }

    #custom-power {
      background-color: #f2cdcd;
    }


    tooltip {
      border-radius: 8px;
      padding: 15px;
      background-color: #131822;
    }

    tooltip label {
      padding: 5px;
      background-color: #131822;
    }
  '';
}
