{config, common, ...}: {
  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
  };

  xdg.configFile."noctalia/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${common.dotfilesDir}/noctalia/settings.json";
}
