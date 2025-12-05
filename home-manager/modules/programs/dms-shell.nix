{ common, ... }:

{
  enable = true;
  systemd = {
    enable = true;
    restartIfChanged = true;
  };
  enableClipboard = true;
  enableAudioWavelength = true;
  enableSystemMonitoring = true;
  enableDynamicTheming = true;
  enableBrightnessControl = true;
  enableColorPicker = true;
  enableVPN = true;
  enableCalendarEvents = false;
  enableSystemSound = true;
}
