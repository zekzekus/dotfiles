{ config, lib, ... }:

{
  options.shellMode = lib.mkOption {
    type = lib.types.str;
    default = "noctalia";
    description = "Which shell to use (default, noctalia, dms)";
  };

  config = {
    services.noctalia-shell = lib.mkIf (config.shellMode == "noctalia") {
      enable = true;
      target = "hyprland-session.target";
    };
  };
}
