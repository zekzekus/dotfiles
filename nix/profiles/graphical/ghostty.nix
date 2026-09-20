{
  pkgs,
  lib,
  ...
}: {
  programs.ghostty = {
    enable = true;
    package =
      if pkgs.stdenv.hostPlatform.isDarwin
      then pkgs.ghostty-bin
      else pkgs.ghostty;
    settings = {
      # Built-in default so a graphical-only host does not depend on Noctalia.
      # The wayland profile overrides this to "noctalia" when that session is on.
      theme = lib.mkDefault "Kanagawabones";
      font-family = "TX-02";
      font-size =
        if pkgs.stdenv.hostPlatform.isDarwin
        then 17
        else 14;
      font-thicken = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin true;
      window-padding-balance = true;
      font-feature = "-calt, -liga, -dlig";
      adjust-cursor-thickness = 3;
      shell-integration-features = "no-cursor";
      quit-after-last-window-closed = true;
      maximize = false;

      # macOS-specific
      macos-titlebar-style = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin "tabs";
      macos-option-as-alt = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin "left";
      macos-shortcuts = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin "allow";

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
