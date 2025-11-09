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
      modules-right = [ "network" "pulseaudio" "battery" "clock" ];

      "hyprland/workspaces" = {
        format = "{id}";
      };

      "hyprland/window" = {
        max-length = 50;
      };

      network = {
        format-wifi = " {essid}";
        format-ethernet = " {ifname}";
        format-disconnected = "⚠ Disconnected";
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = " Muted";
        format-icons = {
          default = [ "" "" "" ];
        };
      };

      battery = {
        format = "{icon} {capacity}%";
        format-icons = [ "" "" "" "" "" ];
      };

      clock = {
        format = " {:%H:%M}";
        format-alt = " {:%Y-%m-%d}";
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

    #window, #network, #pulseaudio, #battery, #clock {
      padding: 0 10px;
      margin: 0 3px;
      border-radius: 5px;
    }
  '';
}
