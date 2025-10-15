{ pkgs, ... }:

{
  enable = true;
  enableFishIntegration = true;
  enableBashIntegration = true;
  settings = {
    cmd_duration.disabled = true;
  };
}