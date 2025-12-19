{ pkgs, common, ... }:

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
