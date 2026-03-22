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
    # Intentional: stateVersion pinned behind current channel; release check disabled to suppress warning
    stateVersion = "24.11";
    enableNixpkgsReleaseCheck = false;

    inherit (common) username;
    homeDirectory = lib.mkForce common.homeDir;
  };
}
