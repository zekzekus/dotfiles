{ pkgs }:

{
  enable = true;
  package = pkgs.ghostty-bin;
  settings = {
    theme = "light:Neobones Light,dark:Neobones Dark";
    font-family = "TX-02";
    font-size = 17;
    font-thicken = true;
    macos-titlebar-style = "tabs";
    window-padding-balance = true;
    font-feature = "-calt, -liga, -dlig";
    adjust-cursor-thickness = 3;
    shell-integration-features = "no-cursor";
    quit-after-last-window-closed = true;
    macos-option-as-alt = "left";
    macos-shortcuts = "allow";
  };
}
