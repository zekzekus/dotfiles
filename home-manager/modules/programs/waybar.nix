{ pkgs, ... }:

{
  enable = true;
  systemd = {
    enable = true;
    target = "hyprland-session.target";
  };
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
    }

    window#waybar {
      background-color: rgba(26, 27, 38, 0.9);
      color: #cdd6f4;
    }

    #workspaces button {
      padding: 0 5px;
      color: #cdd6f4;
      background-color: transparent;
      border-radius: 5px;
    }

    #workspaces button.active {
      background-color: rgba(137, 180, 250, 0.3);
    }

    #workspaces button:hover {
      background-color: rgba(137, 180, 250, 0.2);
    }

    #window, #bluetooth, #pulseaudio, #battery, #clock, #tray {
      padding: 0 10px;
      margin: 0 3px;
      border-radius: 5px;
    }
  '';
}
