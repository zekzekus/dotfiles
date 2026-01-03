{ config, common, ... }:

{
  programs.dank-material-shell = {
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

  home.file.".config/DankMaterialShell/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${common.dotfilesDir}/dms/settings.json";
}
