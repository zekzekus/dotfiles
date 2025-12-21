{ config, lib, ... }:

let
  inherit (lib) mkOption types;
  shellModes = import ./shell-modes.nix;
  modeNames = builtins.attrNames shellModes;
in
{
  options.desktop = {
    shell = {
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
        default = shellModes.${config.desktop.shell.mode};
        description = "The currently active shell mode configuration.";
      };
    };

    # Future: desktop.manager options go here
    # manager = { ... };
  };

  config._module.args = {
    desktop = config.desktop;
  };
}
