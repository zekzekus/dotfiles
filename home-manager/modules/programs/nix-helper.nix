{common, ...}: {
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 2d --keep 3";
    flake = "${common.dotfilesDir}/home-manager";
  };
}
