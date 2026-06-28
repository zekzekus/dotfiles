_: {
  programs.atuin = {
    enable = true;
    daemon.enable = false;
    enableNushellIntegration = false;
    enableFishIntegration = true;
    forceOverwriteSettings = true;
  };
}
