{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;

  # Encrypted SSH host definitions (sops, age-backed). The decrypted snippet is
  # rendered to `sshHostsPath` and pulled in via `Include`. The encrypted file is
  # committed; bootstrap + workflow live in docs/sops-setup.md. Gated on the file
  # existing so the repo (and `make check`) stays green before it is first
  # created and committed — flakes only see git-tracked files, so an uncommitted
  # secret reads as absent here, which is the behaviour we want.
  sshHostsSopsFile = ../../../secrets/ssh-config;
  sshHostsPath = "${config.home.homeDirectory}/.ssh/config.d/hosts";
  hasSshHosts = builtins.pathExists sshHostsSopsFile;
in {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    # `Include` is a no-op until sops renders the file at activation; OpenSSH
    # silently ignores a missing include, so this is safe even mid-bootstrap.
    includes = lib.optional hasSshHosts sshHostsPath;
    # The first use in a login session asks for the key passphrase and loads
    # the key into the agent; later uses do not prompt.
    settings."*" =
      {
        AddKeysToAgent = "yes";
      }
      // lib.optionalAttrs isDarwin {
        # Apple's ssh keeps the passphrase in the login Keychain, so it also
        # survives reboots. Nix OpenSSH (e.g. in dev shells) lacks the option.
        IgnoreUnknown = "UseKeychain";
        UseKeychain = "yes";
      };
  };

  # Linux: plain OpenSSH agent as a user service. The module exports
  # SSH_AUTH_SOCK to shells, systemd and D-Bus, and keeps forwarded agents.
  # macOS uses the system launchd agent, which launchd already exports.
  services.ssh-agent.enable = isLinux;

  # Decrypt the host snippet to a stable path. Explicit, XDG_RUNTIME_DIR-free
  # locations keep this working on macOS, where that variable is normally unset.
  sops = lib.mkIf hasSshHosts {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSymlinkPath = "${config.home.homeDirectory}/.cache/sops-nix/secrets";
    defaultSecretsMountPoint = "${config.home.homeDirectory}/.cache/sops-nix/secrets.d";
    secrets."ssh-hosts" = {
      sopsFile = sshHostsSopsFile;
      format = "binary";
      path = sshHostsPath;
    };
  };
}
