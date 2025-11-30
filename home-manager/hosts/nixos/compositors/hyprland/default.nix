{ pkgs, common, ... }:

{
  imports = [
    ./stylix.nix
  ];

  wayland.windowManager.hyprland = import ../../../../modules/programs/hyprland.nix { inherit pkgs common; };
  wayland.systemd.target = "hyprland-session.target";

  home = {
    packages = with pkgs; [
      brightnessctl
      playerctl
      grim
      slurp
      satty
      kooha
      wl-clipboard
      libnotify
      blueman
      nemo
      pavucontrol
      wireplumber

      # theme-switch dependencies (gsettings for live gtk switching)
      glib
      gsettings-desktop-schemas

      # Portal
      xdg-desktop-portal-gtk
    ];

    file = {
      "bin/theme-dark".source = "${common.dotfilesDir}/scripts/theme-dark";
      "bin/theme-light".source = "${common.dotfilesDir}/scripts/theme-light";
    };

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland";
      GDK_BACKEND = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      SDL_VIDEODRIVER = "wayland";
      GTK_USE_PORTAL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };
  };

  programs = {
    waybar = import ../../../../modules/programs/waybar.nix { inherit pkgs; };
    rofi = import ../../../../modules/programs/rofi.nix { inherit pkgs; };
    hyprlock = import ../../../../modules/programs/hyprlock.nix { inherit pkgs; };
  };

  services = {
    cliphist = {
      enable = true;
    };

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
