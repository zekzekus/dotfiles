{ pkgs, common, ... }:

# some tricks for macos installations
# need to install raycast and karabiner-elements from their downloads
# set keyboard repeating settings
# defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
# set group by windows for aerospace
{
  home = {
    packages = with pkgs; [
      glibtool
    ];

    file = {
      ".config/karabiner".source = "${common.dotfilesDir}/misc/macosx/karabiner";
    };

    sessionPath = [
      "/opt/homebrew/bin"
    ];

    sessionVariables = {
      HOMEBREW_NO_INSTALL_CLEANUP = 1;
    };
  };

  programs = {
    bash.enable = true;
    
    aerospace = import ../modules/programs/aerospace.nix { inherit pkgs common; };
    ghostty = import ../modules/programs/ghostty.nix { inherit pkgs; };

  };

  services = {
    jankyborders = import ../modules/services/jankyborders.nix { inherit pkgs common; };
  };
}
