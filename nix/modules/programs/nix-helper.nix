{
  common,
  pkgs,
  ...
}: {
  programs.nh = {
    enable = true;
    # Drop nh's vendored Nushell completer: it wraps ours with the deprecated
    # positional `spans` input, and the carapace completer already covers nh.
    package = pkgs.symlinkJoin {
      inherit (pkgs.nh) name meta;
      paths = [pkgs.nh];
      postBuild = "rm -r $out/share/nushell";
    };
    clean.enable = true;
    clean.extraArgs = "--keep-since 2d --keep 3";
    flake = common.dotfilesDir;
  };
}
