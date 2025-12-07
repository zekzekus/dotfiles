{
  pkgs,
  common,
  ...
}:

{
  programs = {
    firefox = import ../../modules/firefox.nix { inherit pkgs common; };
  };
}
