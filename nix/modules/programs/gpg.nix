{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;

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

  # GnuPG's supervised mode expects systemd socket passing, not launchd's.
  # On macOS, let GnuPG autostart its agent on the socket its clients use.
  launchd.agents.gpg-agent.enable = lib.mkIf isDarwin (lib.mkForce false);

  # Retire the old process after config/pinentry changes; the next GPG command
  # starts an agent with the current configuration and Nix store paths.
  home.file."${config.programs.gpg.homedir}/gpg-agent.conf".onChange = lib.mkIf isDarwin ''
    ${config.programs.gpg.package}/bin/gpgconf --homedir ${lib.escapeShellArg config.programs.gpg.homedir} --kill gpg-agent
  '';
}
