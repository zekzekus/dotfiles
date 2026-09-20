# Graphical profile: opt-in role for any host with a display (GUI apps).
# Selected per-host via `profiles = ["graphical"]`. Cross-platform GUI bits live
# here; Linux-only GUI apps are gated into ./linux. Keep Wayland session/compositor
# config out of here — that belongs in the `wayland` profile.
#
# Note: the Linux gate uses `common.isLinux` (a specialArg) rather than
# `pkgs.stdenv.hostPlatform.isLinux`, because branching `imports` on a regular module arg
# (pkgs/config) triggers infinite recursion.
{
  lib,
  config,
  common,
  pkgs,
  ...
}: let
  onePasswordSocketPath = "${config.home.homeDirectory}/.1password/agent.sock";
in {
  imports =
    [
      ./acme.nix
      ./ghostty.nix
      ./obsidian.nix
    ]
    ++ lib.optional common.isLinux ./linux;

  home = {
    packages = with pkgs; [
      localsend
      spotify
    ];
    sessionVariables.SSH_AUTH_SOCK = onePasswordSocketPath;
  };

  programs.ssh.settings."*".IdentityAgent = "\"${onePasswordSocketPath}\"";
}
