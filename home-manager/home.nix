{ pkgs, common, ... }:

{
  home = {
    stateVersion = "24.11";

    packages = import ./modules/packages { inherit pkgs; };
  };

  home.file = import ./modules/file { inherit common; };
  home.sessionPath = import ./modules/sessionpath { inherit common; };
  home.sessionVariables = import ./modules/sessionvariables { inherit common; };

  programs = import ./modules/programs { inherit pkgs common; };

  services = import ./modules/services { };
}
