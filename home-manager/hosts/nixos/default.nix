{
  pkgs,
  lib,
  common,
  shell,
  ...
}:

{
  imports = [
    ../../modules/shell.nix
    ./hyprland-integration.nix
    ./stylix.nix
    ../../modules/programs/hyprland.nix
    ../../modules/programs/waybar.nix
    ../../modules/programs/rofi.nix
    ../../modules/programs/hyprlock.nix
    ../../modules/programs/dms-shell.nix
    ../../modules/programs/caelestia-shell.nix
    ../../modules/programs/noctalia-shell.nix
    ../../modules/programs/nix-helper.nix
    ../../modules/programs/yazi.nix
  ];

  shell.mode = "noctalia";

  wayland.systemd.target = "hyprland-session.target";

  home = {
    packages = with pkgs; [
      appimage-run
      ghostty
      localsend
      (import ../../modules/packages/helium.nix { inherit pkgs; })
      showmethekey
    ];

    file = {
      ".config/ghostty".source = "${common.dotfilesDir}/ghostty";
      ".config/DankMaterialShell/settings.json".source = "${common.dotfilesDir}/dms/settings.json";
    };
  };

  programs = {
    chromium.enable = true;
    fastfetch.enable = true;

    vicinae = {
      enable = true;
      systemd.enable = shell.vicinae.systemd;
    };
  };

  services = {
    tailscale-systray.enable = true;
    network-manager-applet.enable = true;
    cliphist.enable = true;

    polkit-gnome.enable = true;

    mako = lib.mkIf shell.mako.enable {
      enable = true;
      settings = {
        default-timeout = 3000;
        layer = "overlay";
        anchor = "top-right";
      };
    };

    hyprpaper = lib.mkIf shell.hyprpaper.enable {
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
