{ pkgs, common, ... }:

# some tricks for macos installations
# need to install raycast and karabiner-elements from their downloads
# set keyboard repeating settings
# defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
# set group by windows for aerospace
{
  programs = {
    bash.enable = true;
    
    aerospace = import ../programs/aerospace.nix { inherit pkgs common; };
    sketchybar = import ../programs/sketchybar.nix { inherit pkgs common; };
    ghostty = import ../programs/ghostty.nix { inherit pkgs; };

  };

  home = {
    packages = with pkgs; [
      glibtool
    ];

    file = {
      ".config/karabiner".source = "${common.dotfilesDir}/misc/macosx/karabiner";
    };
  };

  services = {
    jankyborders = import ../services/jankyborders.nix { inherit pkgs common; };
  };

  home.sessionPath = [
    "/opt/homebrew/bin"
  ];

  home.sessionVariables = {
  };
}
