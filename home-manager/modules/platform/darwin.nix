{ pkgs, common, ... }:

{
  programs = {
    bash.enable = true;
    
    aerospace = import ../programs/aerospace.nix { inherit pkgs common; };
    sketchybar = import ../programs/sketchybar.nix { inherit pkgs common; };

    ghostty = {
      enable = true;
      package = pkgs.ghostty-bin;
      settings = {
        theme = "vimbones";
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
      };
    };
  };

  home = {
    packages = with pkgs; [
      glibtool
    ];
  };

  services = {
    jankyborders = import ../services/jankyborders.nix { inherit pkgs common; };
  };

  home.sessionVariables = {
  };
}
