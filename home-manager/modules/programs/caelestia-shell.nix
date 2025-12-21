{ lib, desktop, ... }:

{
  programs.caelestia = lib.mkIf desktop.shell.current.caelestia.enable {
    enable = true;
    systemd.enable = true;
    settings = {
      use24HourClock = true;
    };
  };
}
