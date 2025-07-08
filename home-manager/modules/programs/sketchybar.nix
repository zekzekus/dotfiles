{ ... }:

let
  common = import ../common.nix { };
in
{
  enable = false;
  config = {
    source = "${common.dotfilesDir}/sketchybar";
    recursive = true;
  };
}