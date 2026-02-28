_: {
  programs.atuin = {
    enable = true;
    daemon.enable = true;
    enableNushellIntegration = true;
    enableFishIntegration = true;
    forceOverwriteSettings = true;
  };
}
