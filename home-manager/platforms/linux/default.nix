{
  pkgs,
  common,
  ...
}:

{
  programs = {
    firefox = import ../../modules/programs/firefox.nix { inherit pkgs common; };
  };
}
