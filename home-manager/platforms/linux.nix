{ pkgs, common, lib, ... }:

{
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
}
