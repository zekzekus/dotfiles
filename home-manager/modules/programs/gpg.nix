{
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin;
  inherit (pkgs.stdenv) isLinux;

  pinentryPackage =
    if isDarwin
    then pkgs.pinentry_mac
    else pkgs.pinentry-curses;
in {
  programs.gpg = {
    enable = true;
    settings = {
      use-agent = true;
      keyserver = "hkps://keys.openpgp.org";
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = false;
    pinentry.package = pinentryPackage;
    defaultCacheTtl = 86400;
    maxCacheTtl = 86400;
    extraConfig = lib.optionalString isLinux ''
      allow-loopback-pinentry
    '';
  };
}
