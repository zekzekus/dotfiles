{ pkgs, lib, ... }:

{
  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
    settings = {
      theme = if pkgs.stdenv.isDarwin then "light:Vimbones,dark:Kanagawabones" else "noctalia";
      font-family = "TX-02";
      font-size = if pkgs.stdenv.isDarwin then 16 else 13;
      font-thicken = lib.mkIf pkgs.stdenv.isDarwin true;
      window-padding-balance = true;
      font-feature = "-calt, -liga, -dlig";
      adjust-cursor-thickness = 3;
      shell-integration-features = "no-cursor";
      quit-after-last-window-closed = true;
      maximize = true;

      # macOS-specific
      auto-update-channel = lib.mkIf pkgs.stdenv.isDarwin "tip";
      macos-titlebar-style = lib.mkIf pkgs.stdenv.isDarwin "tabs";
      macos-option-as-alt = lib.mkIf pkgs.stdenv.isDarwin "left";
      macos-shortcuts = lib.mkIf pkgs.stdenv.isDarwin "allow";

      # Keybindings (cross-platform)
      keybind = [
        "super+ctrl+j=goto_split:bottom"
        "super+ctrl+h=goto_split:left"
        "super+ctrl+k=goto_split:top"
        "super+ctrl+l=goto_split:right"
        "ctrl+alt+j=resize_split:down,20"
        "ctrl+alt+h=resize_split:left,20"
        "ctrl+alt+k=resize_split:up,20"
        "ctrl+alt+l=resize_split:right,20"
      ];
    };
  };
}
