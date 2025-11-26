{ pkgs, common, ... }:

{
  home = {
    stateVersion = "24.11";

    packages = import ./modules/packages { inherit pkgs; };
    file = import ./modules/file { inherit common; };
    sessionPath = import ./modules/sessionpath { inherit common; };
    sessionVariables = import ./modules/sessionvariables { inherit common; };
  };

  programs = import ./modules/programs { inherit pkgs common; };
  services = import ./modules/services { };
}
