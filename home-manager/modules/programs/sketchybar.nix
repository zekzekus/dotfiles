{ common, ... }:

{
  enable = false;
  config = {
    source = "${common.dotfilesDir}/sketchybar";
    recursive = true;
  };
}