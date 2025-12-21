{ lib, desktop, ... }:

{
  programs.dank-material-shell = lib.mkIf desktop.shell.current.dankMaterialShell.enable {
    enable = true;
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
