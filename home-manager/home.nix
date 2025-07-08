{ pkgs, ... }:

let
  common = import ./modules/common.nix { };
in
{
  home = {
    username = "${common.username}";
    homeDirectory = "${common.homeDir}";
    stateVersion = "24.11";

    packages = import ./modules/packages { inherit pkgs; };
    file = import ./modules/file { };
    sessionPath = import ./modules/sessionpath { };
    sessionVariables = import ./modules/sessionvariables { };
  };

  programs = import ./modules/programs { inherit pkgs; };

  services = import ./modules/services { };
}