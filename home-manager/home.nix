{ common, ... }:

{
  imports = [
    ./modules/shell.nix
    ./modules/packages
    ./modules/file
    ./modules/sessionpath
    ./modules/sessionvariables
    ./modules/programs
  ];

  home = {
    stateVersion = "24.11";
    enableNixpkgsReleaseCheck = false;

    username = common.username;
    homeDirectory = common.homeDir;
  };
}
