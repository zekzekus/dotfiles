{ pkgs, ... }:

{
  enable = true;
  settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 30;
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "hyprland/window" ];
      modules-right = [ "tray" "bluetooth" "pulseaudio" "battery" "clock" ];

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
      };

      tray = {
        spacing = 10;
      };
    };
  };
  style = ''
    * {
      font-family: "JetBrainsMono Nerd Font";
      font-size: 13px;
      min-height: 0;
    }

    window#waybar {
      background: rgba(17, 17, 27, 0.5);
    }

    #workspaces {
      background: rgba(30, 30, 46, 0.8);
      margin: 5px;
      padding: 0px 5px;
      border-radius: 10px;
    }

    #workspaces button {
      padding: 0px 8px;
      color: #cdd6f4;
      background-color: transparent;
      border-radius: 10px;
      transition: all 0.3s ease;
    }

    #workspaces button.active {
      background: rgba(137, 180, 250, 0.4);
      color: #1e1e2e;
      font-weight: bold;
    }

    #workspaces button:hover {
      background: rgba(137, 180, 250, 0.2);
      box-shadow: 0 0 5px rgba(137, 180, 250, 0.5);
    }

    #window {
      background: rgba(30, 30, 46, 0.8);
      margin: 5px 5px;
      padding: 0px 15px;
      border-radius: 10px;
      color: #cdd6f4;
    }

    #bluetooth,
    #pulseaudio,
    #battery,
    #clock {
      background: rgba(30, 30, 46, 0.8);
      margin: 5px 2px;
      padding: 0px 12px;
      border-radius: 10px;
      color: #cdd6f4;
    }

    #tray {
      background: rgba(30, 30, 46, 0.8);
      margin: 5px 5px 5px 2px;
      padding: 0px 8px;
      border-radius: 10px;
    }

    #bluetooth {
      color: #89b4fa;
    }

    #pulseaudio {
      color: #89dceb;
    }

    #battery {
      color: #a6e3a1;
    }

    #battery.charging {
      color: #f9e2af;
    }

    #battery.warning:not(.charging) {
      color: #fab387;
    }

    #battery.critical:not(.charging) {
      color: #f38ba8;
      animation: blink 0.5s linear infinite;
    }

    @keyframes blink {
      to {
        opacity: 0.5;
      }
    }

    #clock {
      color: #f5c2e7;
      font-weight: bold;
    }
  '';
}
