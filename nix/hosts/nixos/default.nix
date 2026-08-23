# Host-specific Home Manager config for the `nixos` workstation.
#
# The Wayland desktop session (Hyprland/Niri/Noctalia/stylix/…) now lives in the
# reusable `wayland` profile, and GUI apps in the `graphical` profile — both
# selected for this host in flake.nix. Put only genuinely machine-specific
# Home Manager overrides here.
_: {
  # This is intentionally user-scoped: the rootless Podman socket belongs to
  # Zekus (uid 1000), not to the other local accounts.
  home.sessionVariables.DOCKER_HOST = "unix:///run/user/1000/podman/podman.sock";
}
