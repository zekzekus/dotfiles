{ pkgs, ... }:

let
  common = import ./modules/common.nix { inherit pkgs; };
in
{
  home = {
    stateVersion = "24.11";

    username = "${common.username}";
    homeDirectory = "${common.homeDir}";

    packages = import ./modules/packages { inherit pkgs; };
    file = import ./modules/file { inherit pkgs; };
    sessionPath = import ./modules/sessionpath { };
    sessionVariables = import ./modules/sessionvariables { inherit pkgs; };
  };

  programs = import ./modules/programs { inherit pkgs; };

  services = import ./modules/services { };
}
