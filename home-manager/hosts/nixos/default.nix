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
    ../../modules/programs/hyprland-plugins.nix
    ../../modules/programs/waybar.nix
    ../../modules/programs/rofi.nix
    ../../modules/programs/hyprlock.nix
    ../../modules/programs/dms-shell.nix
    ../../modules/programs/caelestia-shell.nix
    ../../modules/programs/noctalia-shell.nix
  ];

  desktop.shell.mode = "noctalia";

  home = {
    packages = with pkgs; [
      appimage-run
      (import ../../modules/packages/helium.nix { inherit pkgs; })
      showmethekey
    ] ++ lib.optionals desktop.shell.current.hyprlauncher.enable [
      hyprlauncher
    ] ++ lib.optionals desktop.shell.current.hyprpolkitagent.enable [
      hyprpolkitagent
    ];

    file = {
      ".config/DankMaterialShell/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${common.dotfilesDir}/dms/settings.json";
    };
  };

  services = {
    tailscale-systray.enable = true;
    network-manager-applet.enable = true;

    cliphist.enable = lib.mkIf desktop.shell.current.cliphist.enable true;

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

  systemd.user.services = {
    hyprpolkitagent = lib.mkIf desktop.shell.current.hyprpolkitagent.enable {
      Unit = {
        Description = "Hyprland Polkit Authentication Agent";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
        Restart = "on-failure";
        RestartSec = 1;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    hyprlauncher = lib.mkIf desktop.shell.current.hyprlauncher.enable {
      Unit = {
        Description = "Hyprlauncher daemon";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.hyprlauncher}/bin/hyprlauncher -d";
        Restart = "on-failure";
        RestartSec = 1;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
