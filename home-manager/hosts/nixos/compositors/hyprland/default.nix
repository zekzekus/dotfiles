{ pkgs, common, ... }:

{
  imports = [
    ../common/wayland.nix
    ../common/desktop.nix
    ./stylix.nix
  ];

  wayland.windowManager.hyprland = import ../../../../modules/programs/hyprland.nix { inherit pkgs common; };
  wayland.systemd.target = "hyprland-session.target";

  programs = {
    hyprlock = import ../../../../modules/programs/hyprlock.nix { inherit pkgs; };
  };

  services = {
    hyprpaper = {
      enable = true;
      settings = {
        preload = "~/Pictures/wallpapers/w11black.jpg";
        wallpaper = ",~/Pictures/wallpapers/w11black.jpg";
        splash = false;
        ipc = "off";
      };
    };

    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = [
          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
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
}
