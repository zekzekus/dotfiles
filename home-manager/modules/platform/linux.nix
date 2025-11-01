{ pkgs, common, ... }:

{
  imports = [
    ../programs/hyprland.nix
  ];

  programs = {
    bash.enable = false;
  };

  home = {
    packages = with pkgs; [
      ghostty
    ];

    file = {
      ".config/ghostty".source = "${common.dotfilesDir}/ghostty";
    };
  };

  services = {
  };

  home.sessionVariables = {
  };
}
