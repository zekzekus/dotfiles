{
  lib,
  common,
  ...
}: {
  imports = [
    ./modules/packages
    ./modules/file
    ./modules/sessionpath
    ./modules/sessionvariables
    ./modules/programs
  ];

  home = {
    stateVersion = "24.11";
    enableNixpkgsReleaseCheck = false;

    inherit (common) username;
    homeDirectory = lib.mkForce common.homeDir;
  };
}
