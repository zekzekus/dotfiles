{ config, lib, pkgs, common, ... }:

let
  inherit (lib) mkOption mkIf mkMerge types;
  shellModes = import ./shell-modes-defs.nix { inherit pkgs; };
  modeNames = builtins.attrNames shellModes;
  cfg = config.desktop.shell;
in
{
  options.desktop.shell = {
    mode = mkOption {
      type = types.enum modeNames;
      default = "default";
      description = "Active desktop shell mode. One of: ${builtins.concatStringsSep ", " modeNames}";
    };

    modes = mkOption {
      type = types.attrs;
      readOnly = true;
      default = shellModes;
      description = "All available shell mode definitions.";
    };

    current = mkOption {
      type = types.attrs;
      readOnly = true;
      default = shellModes.${cfg.mode};
      description = "The currently active shell mode configuration.";
    };

    launcher = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Command to launch the application launcher.";
    };

    clipboard = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Command to open clipboard manager.";
    };

    lock = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Command to lock the screen.";
    };

    volumeMute = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Command to mute volume.";
    };

    volumeDown = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Command to decrease volume.";
    };

    volumeUp = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Command to increase volume.";
    };

    brightnessUp = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Command to increase brightness.";
    };

    brightnessDown = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Command to decrease brightness.";
    };

    bindType = mkOption {
      type = types.enum [ "exec" "global" ];
      default = "exec";
      description = "Hyprland bind type for shell commands.";
    };

    idleLockCmd = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Command to run on idle for locking.";
    };

    extraBinds = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Extra Hyprland keybindings for this shell mode.";
    };
  };

  config = mkMerge (map (modeName:
    let m = shellModes.${modeName}; in
    mkIf (cfg.mode == modeName) {
      desktop.shell = {
        inherit (m) launcher clipboard lock volumeMute volumeDown volumeUp;
        inherit (m) brightnessUp brightnessDown bindType idleLockCmd;
        extraBinds = m.hyprland.extraBinds or [];
      };

      home.packages = m.packages or [];

      home.file = m.homeFiles {
        mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
        dotfilesDir = common.dotfilesDir;
      };

      services = m.services;

      systemd.user.services = m.systemdServices;

      programs.waybar.enable = m.waybar.enable;
      programs.dank-material-shell.enable = m.dankMaterialShell.enable;
      programs.caelestia.enable = m.caelestia.enable;
      programs.noctalia-shell.enable = m.noctalia.enable;
    }
  ) modeNames);
}
