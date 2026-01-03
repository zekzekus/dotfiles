{ config, lib, pkgs, common, ... }:

let
  inherit (lib) mkOption mkIf types;

  modeType = types.submodule {
    options = {
      launcher       = mkOption { type = types.nullOr types.str; default = null; };
      clipboard      = mkOption { type = types.nullOr types.str; default = null; };
      lock           = mkOption { type = types.nullOr types.str; default = null; };
      volumeMute     = mkOption { type = types.nullOr types.str; default = null; };
      volumeDown     = mkOption { type = types.nullOr types.str; default = null; };
      volumeUp       = mkOption { type = types.nullOr types.str; default = null; };
      brightnessUp   = mkOption { type = types.nullOr types.str; default = null; };
      brightnessDown = mkOption { type = types.nullOr types.str; default = null; };

      bindType    = mkOption { type = types.enum [ "exec" "global" ]; default = "exec"; };
      idleLockCmd = mkOption { type = types.nullOr types.str; default = null; };
      extraBinds  = mkOption { type = types.listOf types.str; default = []; };

      packages = mkOption {
        type = types.listOf types.package;
        default = [];
      };

      homeFiles = mkOption {
        type = types.attrsOf types.anything;
        default = {};
      };

      enableWaybar            = mkOption { type = types.bool; default = false; };
      enableDankMaterialShell = mkOption { type = types.bool; default = false; };
      enableCaelestia         = mkOption { type = types.bool; default = false; };
      enableNoctalia          = mkOption { type = types.bool; default = false; };

      enableCliphist  = mkOption { type = types.bool; default = false; };
      enableMako      = mkOption { type = types.bool; default = false; };
      enableHyprpaper = mkOption { type = types.bool; default = false; };
      enableHypridle  = mkOption { type = types.bool; default = true; };

      enableHyprpolkitagent    = mkOption { type = types.bool; default = false; };
      enableHyprlauncherDaemon = mkOption { type = types.bool; default = false; };
    };
  };

  shellModes = import ./shell-modes-defs.nix {
    inherit pkgs;
    mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
    dotfilesDir = common.dotfilesDir;
  };

  modeNames = builtins.attrNames shellModes;
  cfg = config.desktop.shell;
  current = cfg.modes.${cfg.mode};

  graphicalSessionTarget = [ "graphical-session.target" ];
in
{
  options.desktop.shell = {
    mode = mkOption {
      type = types.enum modeNames;
      default = "default";
      description = "Active desktop shell mode. One of: ${builtins.concatStringsSep ", " modeNames}";
    };

    modes = mkOption {
      type = types.attrsOf modeType;
      readOnly = true;
      default = shellModes;
      description = "All available shell mode definitions.";
    };

    current = mkOption {
      type = modeType;
      readOnly = true;
      default = current;
      description = "The currently active shell mode configuration.";
    };

    launcher       = mkOption { type = types.nullOr types.str; readOnly = true; default = current.launcher; };
    clipboard      = mkOption { type = types.nullOr types.str; readOnly = true; default = current.clipboard; };
    lock           = mkOption { type = types.nullOr types.str; readOnly = true; default = current.lock; };
    volumeMute     = mkOption { type = types.nullOr types.str; readOnly = true; default = current.volumeMute; };
    volumeDown     = mkOption { type = types.nullOr types.str; readOnly = true; default = current.volumeDown; };
    volumeUp       = mkOption { type = types.nullOr types.str; readOnly = true; default = current.volumeUp; };
    brightnessUp   = mkOption { type = types.nullOr types.str; readOnly = true; default = current.brightnessUp; };
    brightnessDown = mkOption { type = types.nullOr types.str; readOnly = true; default = current.brightnessDown; };
    bindType       = mkOption { type = types.enum [ "exec" "global" ]; readOnly = true; default = current.bindType; };
    idleLockCmd    = mkOption { type = types.nullOr types.str; readOnly = true; default = current.idleLockCmd; };
    extraBinds     = mkOption { type = types.listOf types.str; readOnly = true; default = current.extraBinds; };
  };

  config = {
    home.packages = current.packages;
    home.file = current.homeFiles;

    programs.waybar.enable             = current.enableWaybar;
    programs.dank-material-shell.enable = current.enableDankMaterialShell;
    programs.caelestia.enable          = current.enableCaelestia;
    programs.noctalia-shell.enable     = current.enableNoctalia;

    services.cliphist.enable = current.enableCliphist;

    services.mako = mkIf current.enableMako {
      enable = true;
      settings = {
        default-timeout = 3000;
        layer = "overlay";
        anchor = "top-right";
      };
    };

    services.hyprpaper = mkIf current.enableHyprpaper {
      enable = true;
      settings = {
        preload = "~/Pictures/wallpapers/wallhaven-lyq3kq.jpg";
        wallpaper = ",~/Pictures/wallpapers/wallhaven-lyq3kq.jpg";
        splash = false;
        ipc = "off";
      };
    };

    services.hypridle = mkIf current.enableHypridle {
      enable = true;
      settings = {
        general = {
          lock_cmd = current.idleLockCmd;
          before_sleep_cmd = current.idleLockCmd;
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = [
          {
            timeout = 300;
            on-timeout = current.idleLockCmd;
          }
          {
            timeout = 600;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };

    systemd.user.services = {
      hyprpolkitagent = mkIf current.enableHyprpolkitagent {
        Unit = {
          Description = "Hyprland Polkit Authentication Agent";
          PartOf = graphicalSessionTarget;
          After = graphicalSessionTarget;
        };
        Service = {
          ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
          Restart = "on-failure";
          RestartSec = 1;
        };
        Install.WantedBy = graphicalSessionTarget;
      };

      hyprlauncher = mkIf current.enableHyprlauncherDaemon {
        Unit = {
          Description = "Hyprlauncher daemon";
          PartOf = graphicalSessionTarget;
          After = graphicalSessionTarget;
        };
        Service = {
          ExecStart = "${pkgs.hyprlauncher}/bin/hyprlauncher -d";
          Restart = "on-failure";
          RestartSec = 1;
        };
        Install.WantedBy = graphicalSessionTarget;
      };
    };
  };
}
