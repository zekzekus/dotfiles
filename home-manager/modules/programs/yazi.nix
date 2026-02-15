_: {
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    shellWrapperName = "y";
    theme = {
      flavor = {
        dark = "noctalia";
        light = "noctalia";
      };
    };
  };
}
