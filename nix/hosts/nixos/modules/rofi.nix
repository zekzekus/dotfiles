_: {
  programs.rofi = {
    enable = true;
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      display-drun = "";
      display-run = "";
      display-window = "";
      drun-display-format = "{name}";
      font = "JetBrainsMono Nerd Font 12";
    };
  };
}
