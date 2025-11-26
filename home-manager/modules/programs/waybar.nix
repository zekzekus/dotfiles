{ pkgs, ... }:

{
  enable = true;
  systemd.enable = true;
  settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 30;
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "hyprland/window" ];
      modules-right = [ "custom/theme-light" "custom/theme-dark" "tray" "bluetooth" "pulseaudio" "battery" "clock" ];

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
      };

      tray = {
        spacing = 10;
      };
    };
  };
}
