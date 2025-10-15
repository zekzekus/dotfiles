{ pkgs, ... }:

let
  common = import ../common.nix { inherit pkgs; };
in
{
  programs = {
    bash.enable = false;
  };

  home = {
    packages = with pkgs; [
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
