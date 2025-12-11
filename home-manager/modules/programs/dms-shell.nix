{ lib, shell, ... }:

{
  programs.dankMaterialShell = lib.mkIf shell.dankMaterialShell.enable {
    enable = true;
    systemd = {
      enable = true;
      restartIfChanged = true;
    };
    enableClipboard = true;
    enableAudioWavelength = true;
    enableSystemMonitoring = true;
    enableDynamicTheming = true;
    enableVPN = true;
    enableCalendarEvents = false;
  };
}
