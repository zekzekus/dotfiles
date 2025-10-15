{ pkgs, ... }:

let
  username = "zekus";
  homeDir = 
    if pkgs.stdenv.isDarwin 
    then "/Users/${username}"
    else "/home/${username}";
  dotfilesDir = "${homeDir}/devel/tools/dotfiles";
  develHome = "${homeDir}/devel/projects";
  defaultProjectDir = "personal";
  workHome = "${develHome}/${defaultProjectDir}";
  personalHome = "${develHome}/personal";
in
{
  inherit username homeDir dotfilesDir develHome defaultProjectDir workHome personalHome;
}