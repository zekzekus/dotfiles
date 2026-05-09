{pkgs, ...}: {
  programs.radicle = {
    enable = true;
    cli.package = pkgs.radicle-node-unstable;

    settings.node.alias = "zekus";
  };

  services.radicle.node = {
    enable = true;
    package = pkgs.radicle-node-unstable;
    lazy.enable = true;
  };
}
