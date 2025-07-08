{ ... }:

let
  username = "zekus";
  homeDir = "/Users/${username}";
  dotfilesDir = "${homeDir}/devel/tools/dotfiles";
  develHome = "${homeDir}/devel/projects";
  defaultProjectDir = "personal";
  workHome = "${develHome}/${defaultProjectDir}";
  personalHome = "${develHome}/personal";
in
{
  inherit username homeDir dotfilesDir develHome defaultProjectDir workHome personalHome;
}