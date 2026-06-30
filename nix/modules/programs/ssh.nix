{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin isLinux;

  # Stable socket path used across platforms
  onePasswordSocketPath = "${config.home.homeDirectory}/.1password/agent.sock";

  # macOS: 1Password stores its socket here
  darwinRealSocket = "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";

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
    settings."*" = {
      IdentityAgent = "\"${onePasswordSocketPath}\"";
      AddKeysToAgent = "yes";
    };
  };

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

  home = {
    activation = {
      # macOS: symlink 1Password's real socket to our stable path
      link1PasswordAgentSock = lib.mkIf isDarwin (
        lib.hm.dag.entryAfter ["writeBoundary"] ''
          run mkdir -p "$HOME/.1password"
          run ln -sf "${darwinRealSocket}" "${onePasswordSocketPath}"
        ''
      );

      # Linux: 1Password uses this path, just ensure the directory exists
      # The socket is created by 1Password at ~/.1password/agent.sock by default
      ensure1PasswordDir = lib.mkIf isLinux (
        lib.hm.dag.entryAfter ["writeBoundary"] ''
          run mkdir -p "$HOME/.1password"
        ''
      );
    };
  };
}
