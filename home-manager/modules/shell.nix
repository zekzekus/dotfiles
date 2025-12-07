{ config, lib, ... }:

let
  inherit (lib) mkOption types;

  shellModes = import ./shell-modes.nix;
  modeNames = builtins.attrNames shellModes;
in
{
  options.shell = {
    mode = mkOption {
      type = types.enum modeNames;
      default = "default";
      description = ''
        Active desktop shell mode. One of: ${builtins.concatStringsSep ", " modeNames}
      '';
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
      default = shellModes.${config.shell.mode};
      description = "The currently active shell mode configuration.";
    };
  };

  config._module.args = {
    shellMode = config.shell.mode;
    shell = config.shell.current;
    shellModes = shellModes;
  };
}
