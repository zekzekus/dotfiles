{
  config,
  common,
  ...
}: {
  config = {
    xdg.configFile."niri/config.kdl" = {
      force = true;
      source = config.lib.file.mkOutOfStoreSymlink "${common.dotfilesDir}/niri/config.kdl";
    };
  };
}
