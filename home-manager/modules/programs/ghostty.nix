{ pkgs }:

{
  enable = true;
  package = pkgs.ghostty-bin;
  settings = {
    auto-update-channel = "tip";
    theme = "light:Vimbones,dark:Neobones Dark";
    font-family = "TX-02";
    font-size = 16;
    font-thicken = true;
    macos-titlebar-style = "tabs";
    window-padding-balance = true;
    font-feature = "-calt, -liga, -dlig";
    adjust-cursor-thickness = 3;
    shell-integration-features = "no-cursor";
    quit-after-last-window-closed = true;
    macos-option-as-alt = "left";
    macos-shortcuts = "allow";
    maximize = true;
  };
}
