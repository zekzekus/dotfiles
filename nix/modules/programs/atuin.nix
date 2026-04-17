_: {
  programs.atuin = {
    enable = true;
    daemon.enable = true;
    enableNushellIntegration = false;
    enableFishIntegration = true;
    forceOverwriteSettings = true;
  };
}
