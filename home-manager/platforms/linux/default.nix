{ pkgs, common, lib, ... }:

{
  programs = {
    bash.enable = false;
  };

  home = {
    packages = with pkgs; [
      ghostty
      localsend
    ];

    file = {
      ".config/ghostty".source = "${common.dotfilesDir}/ghostty";
    };
  };
}
