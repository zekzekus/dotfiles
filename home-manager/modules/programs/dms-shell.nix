{ lib, shell, ... }:

{
  programs.dankMaterialShell = lib.mkIf shell.dankMaterialShell.enable {
    enable = true;
    systemd = {
      enable = true;
      restartIfChanged = true;
    };
    enableAudioWavelength = true;
    enableSystemMonitoring = true;
    enableDynamicTheming = false;
    enableVPN = true;
    enableCalendarEvents = false;
  };
}
