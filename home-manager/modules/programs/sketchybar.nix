{ pkgs, ... }:

let
  common = import ../common.nix { inherit pkgs; };
in
{
  enable = false;
  config = {
    source = "${common.dotfilesDir}/sketchybar";
    recursive = true;
  };
}