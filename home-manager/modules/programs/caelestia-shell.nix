{ lib, config, ... }:

{
  programs.caelestia = lib.mkIf config.programs.caelestia.enable {
    systemd.enable = true;
    settings = {
      use24HourClock = true;
    };
  };
}
