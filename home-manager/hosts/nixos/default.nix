{
  pkgs,
  lib,
  common,
  shell,
  ...
}:

{
  imports = [
    ./hyprland-integration.nix
    ./stylix.nix
  ];

  shell.mode = "noctalia";

  wayland.windowManager.hyprland = import ../../modules/programs/hyprland.nix {
    inherit pkgs common shell;
  };
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
      ".config/DankMaterialShell/settings.json".source = "${common.dotfilesDir}/dms/settings.json";
    };
  };

  programs = {
    chromium.enable = true;

    waybar = import ../../modules/programs/waybar.nix { inherit pkgs; } // {
      enable = shell.waybar.enable;
      systemd.enable = shell.waybar.enable;
    };
    rofi = import ../../modules/programs/rofi.nix { inherit pkgs; };
    hyprlock = import ../../modules/programs/hyprlock.nix { inherit pkgs; };

    vicinae = {
      enable = true;
      systemd.enable = shell.vicinae.systemd;
    };
  }
  // lib.optionalAttrs shell.dankMaterialShell.enable {
    dankMaterialShell = import ../../modules/programs/dms-shell.nix { inherit common; };
  }
  // lib.optionalAttrs shell.caelestia.enable {
    caelestia = {
      enable = true;
      systemd.enable = true;
      settings = {
        use24HourClock = true;
      };
    };
  }
  // lib.optionalAttrs shell.noctalia.enable {
    noctalia-shell = import ../../modules/programs/noctalia-shell.nix { };
  };

  services = {
    tailscale-systray.enable = true;
    network-manager-applet.enable = true;
    cliphist = {
      enable = true;
    };

    polkit-gnome.enable = true;
    mako = {
      enable = shell.mako.enable;
      settings = {
        default-timeout = 3000;
        layer = "overlay";
        anchor = "top-right";
      };
    };
    hyprpaper = {
      enable = shell.hyprpaper.enable;
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
          lock_cmd = shell.idleLockCmd;
          before_sleep_cmd = shell.idleLockCmd;
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = [
          {
            timeout = 300;
            on-timeout = shell.idleLockCmd;
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