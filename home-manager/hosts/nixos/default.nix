{ pkgs, common, ... }:

{
  imports = [
    ./hyprland-integration.nix
    ./stylix.nix
  ];

  wayland.windowManager.hyprland = import ../../modules/programs/hyprland.nix { inherit pkgs common; };
  wayland.systemd.target = "hyprland-session.target";

  home = {
    packages = with pkgs; [
      appimage-run
      ghostty
      localsend
      (import ../../modules/packages/helium.nix { inherit pkgs; })
    ];

    file = {
      ".config/ghostty".source = "${common.dotfilesDir}/ghostty";
    };
  };

  programs = {
    chromium.enable = true;

    waybar = import ../../modules/programs/waybar.nix { inherit pkgs; };
    rofi = import ../../modules/programs/rofi.nix { inherit pkgs; };
    hyprlock = import ../../modules/programs/hyprlock.nix { inherit pkgs; };

    vicinae = {
      enable = true;
      systemd.enable = true;
    };
  };

  services = {
    tailscale-systray.enable = true;
    network-manager-applet.enable = true;
    cliphist = {
      enable = true;
    };

    polkit-gnome.enable = true;
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
