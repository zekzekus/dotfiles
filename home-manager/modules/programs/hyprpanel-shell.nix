{ common, ... }:

{
  enable = true;
  systemd.enable = true;
  settings = {
    bar.launcher.autoDetectIcon = true;
    menus.clock = {
      time = {
        military = true;
      };
      weather.location = "Istanbul";
    };
  };
}
