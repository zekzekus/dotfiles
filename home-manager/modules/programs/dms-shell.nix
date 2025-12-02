{ common, ... }:

{
  enable = true;
  systemd.enable = true;
  enableClipboard = true;
  enableAudioWavelength = false;
  enableSystemMonitoring = true;
  enableDynamicTheming = true;
  enableBrightnessControl = true;
  enableColorPicker = true;
  enableVPN = true;
  enableCalendarEvents = false;
  enableSystemSound = true;
}
