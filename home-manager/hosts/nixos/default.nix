{
  pkgs,
  lib,
  config,
  common,
  desktop,
  ...
}:

{
  imports = [
    ../../modules/options.nix
    ./hyprland-integration.nix
    ./stylix.nix
    ../../modules/programs/hyprland.nix
    ../../modules/programs/waybar.nix
    ../../modules/programs/rofi.nix
    ../../modules/programs/hyprlock.nix
    ../../modules/programs/dms-shell.nix
    ../../modules/programs/caelestia-shell.nix
    ../../modules/programs/noctalia-shell.nix
  ];

  desktop.shell.mode = "dms";

  wayland.systemd.target = "hyprland-session.target";

  home = {
    packages = with pkgs; [
      appimage-run
      (import ../../modules/packages/helium.nix { inherit pkgs; })
      showmethekey
    ];

    file = {
      ".config/DankMaterialShell/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${common.dotfilesDir}/dms/settings.json";
    };
  };

  programs = {
    vicinae = {
      enable = true;
      systemd.enable = desktop.shell.current.vicinae.systemd;
    };
  };

  services = {
    tailscale-systray.enable = true;
    network-manager-applet.enable = true;

    cliphist.enable = lib.mkIf desktop.shell.current.cliphist.enable true;
    polkit-gnome.enable = lib.mkIf desktop.shell.current.polkit.enable true;

    mako = lib.mkIf desktop.shell.current.mako.enable {
      enable = true;
      settings = {
        default-timeout = 3000;
        layer = "overlay";
        anchor = "top-right";
      };
    };

    hyprpaper = lib.mkIf desktop.shell.current.hyprpaper.enable {
      enable = true;
      settings = {
        preload = "~/Pictures/wallpapers/wallhaven-lyq3kq.jpg";
        wallpaper = ",~/Pictures/wallpapers/wallhaven-lyq3kq.jpg";
        splash = false;
        ipc = "off";
      };
    };

    hypridle = lib.mkIf desktop.shell.current.hypridle.enable {
      enable = true;
      settings = {
        general = {
          lock_cmd = desktop.shell.current.idleLockCmd;
          before_sleep_cmd = desktop.shell.current.idleLockCmd;
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = [
          {
            timeout = 300;
            on-timeout = desktop.shell.current.idleLockCmd;
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
