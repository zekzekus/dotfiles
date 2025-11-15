{ pkgs, ... }:

{
  enable = true;
  theme = "Arc-Dark";
  extraConfig = {
    modi = "drun,run,window";
    show-icons = true;
    display-drun = "";
    display-run = "";
    display-window = "";
    drun-display-format = "{name}";
    font = "JetBrainsMono Nerd Font 12";
  };
}
