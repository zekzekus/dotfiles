{ lib, shell, ... }:

{
  programs.caelestia = lib.mkIf shell.caelestia.enable {
    enable = true;
    systemd.enable = true;
    settings = {
      use24HourClock = true;
    };
  };
}
