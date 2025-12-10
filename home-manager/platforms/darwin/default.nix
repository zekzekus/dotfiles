{ pkgs, common, ... }:

# some tricks for macos installations
# need to install raycast and karabiner-elements from their downloads
# set keyboard repeating settings
# defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
# set group by windows for aerospace
{
  imports = [
    ../../modules/programs/aerospace.nix
    ../../modules/programs/ghostty.nix
    ../../modules/services/jankyborders.nix
  ];

  home = {
    packages = with pkgs; [
      glibtool
    ];

    file = {
      ".config/karabiner".source = "${common.dotfilesDir}/macosx/karabiner";
    };

    sessionPath = [
      "/opt/homebrew/bin"
    ];

    sessionVariables = {
      HOMEBREW_NO_INSTALL_CLEANUP = 1;
    };
  };

  programs.bash.enable = true;
}
