{ pkgs, common, lib, ... }:

{
  imports = [
    ./gnome.nix
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
    GDK_SCALE = "1.50";
  };
}
