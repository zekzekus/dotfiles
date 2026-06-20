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
in {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."*" = {
      IdentityAgent = "\"${onePasswordSocketPath}\"";
      AddKeysToAgent = "yes";
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
