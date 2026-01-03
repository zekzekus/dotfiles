{ lib, config, ... }:

{
  programs.dank-material-shell = lib.mkIf config.programs.dank-material-shell.enable {
    systemd = {
      enable = true;
      restartIfChanged = true;
    };
    enableAudioWavelength = true;
    enableSystemMonitoring = true;
    enableDynamicTheming = true;
    enableVPN = true;
    enableCalendarEvents = false;
  };
}
