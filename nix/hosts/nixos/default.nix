# Host-specific Home Manager config for the `nixos` workstation.
#
# The Wayland desktop session (Hyprland/Niri/Noctalia/stylix/…) now lives in the
# reusable `wayland` profile, and GUI apps in the `graphical` profile — both
# selected for this host in flake.nix. Put only genuinely machine-specific
# Home Manager overrides here.
{
  common,
  pkgs,
  ...
}: let
  amp = pkgs.callPackage ../../modules/packages/amp.nix {};
  dockerHost = "unix:///run/user/1000/podman/podman.sock";
  runnerEnvironment =
    common.sessionVariables
    // {
      DOCKER_HOST = dockerHost;
      PATH = builtins.concatStringsSep ":" (common.sessionPath
        ++ [
          "/run/wrappers/bin"
          "/etc/profiles/per-user/${common.username}/bin"
          "/run/current-system/sw/bin"
        ]);
    };
in {
  imports = [./qmd.nix];

  # This is intentionally user-scoped: the rootless Podman socket belongs to
  # Zekus (uid 1000), not to the other local accounts.
  home.sessionVariables.DOCKER_HOST = dockerHost;

  # One persistent runner discovers every checkout under ~/devel and serves
  # ~/Documents/dev.zeko.miracle directly. Depth 3 covers
  # projects/{personal,playground,work} as well as tools, while Amp stops
  # scanning when it reaches a checkout.
  systemd.user.services.amp-runner = {
    Unit.Description = "Amp remote runner";
    Service = {
      Environment = pkgs.lib.mapAttrsToList (name: value: "${name}=${value}") runnerEnvironment;
      WorkingDirectory = "${common.homeDir}/devel";
      ExecStart = "${amp}/bin/amp --no-tui --runner-id nixos --remote-control-terminal --dir=${common.homeDir}/Documents/dev.zeko.miracle --discover-dirs=${common.homeDir}/devel --discover-depth 3";
      Restart = "always";
      RestartSec = 5;
    };
    Install.WantedBy = ["default.target"];
  };
}
