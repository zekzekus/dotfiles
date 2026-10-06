# Host-specific Home Manager config for the `nixos` workstation.
#
# The Wayland desktop session (Hyprland/Niri/Noctalia/stylix/…) now lives in the
# reusable `wayland` profile, and GUI apps in the `graphical` profile — both
# selected for this host in flake.nix. Put only genuinely machine-specific
# Home Manager overrides here.
{
  common,
  lib,
  pkgs,
  ...
}: let
  amp = pkgs.callPackage ../../modules/packages/amp.nix {};
  dockerHost = "unix:///run/user/1000/podman/podman.sock";
  runners = {
    personal = {
      discoverDirs = [
        "${common.homeDir}/devel/projects/personal"
        "${common.homeDir}/devel/projects/playground"
        "${common.homeDir}/devel/tools"
      ];
      # Amp has one depth per runner. Exclude tools' grandchildren to keep
      # this root at depth 1 while personal/playground retain depth 2.
      discoverExcludes = ["${common.homeDir}/devel/tools/*/*"];
      dirs = [];
    };
    work = {
      discoverDirs = ["${common.homeDir}/devel/projects/work"];
      discoverExcludes = [];
      dirs = ["${common.homeDir}/Documents/dev.zeko.miracle"];
    };
  };
  runnerSecretNames = map (name: "amp-runner-${name}") (builtins.attrNames runners);
  runnerSecretFile = name: ../../../secrets + "/${name}.env";
  checkRunnerToken = pkgs.writeShellScript "check-amp-runner-token" ''
    if [ -z "''${AMP_API_KEY:-}" ]; then
      echo "The runner's SOPS environment file must set a nonempty AMP_API_KEY." >&2
      exit 1
    fi
  '';
  runnerEnvironment =
    common.sessionVariables
    // {
      # Only the service's EnvironmentFile may supply the account credential.
      AMP_API_KEY = "";
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

  sops = {
    age.keyFile = "${common.homeDir}/.config/sops/age/keys.txt";
    # Override the cross-platform cache paths: plaintext belongs on runtime
    # tmpfs on this host. Existing SSH Include paths remain stable symlinks.
    defaultSymlinkPath = lib.mkForce "%r/secrets";
    defaultSecretsMountPoint = lib.mkForce "%r/secrets.d";
    # Bootstrap without fake credentials. Missing files leave the corresponding
    # service unable to start, rather than using the interactive Amp account.
    secrets =
      lib.genAttrs
      (builtins.filter (name: builtins.pathExists (runnerSecretFile name)) runnerSecretNames)
      (name: {
        sopsFile = runnerSecretFile name;
        format = "dotenv";
        key = "";
        mode = "0600";
      });
  };

  # Discovery lists organize the two accounts; both still run as the same user.
  systemd.user.services = lib.mapAttrs' (name: runner:
    lib.nameValuePair "amp-runner-${name}" {
      Unit = {
        Description = "Amp ${name} remote runner";
        Requires = ["sops-nix.service"];
        After = ["sops-nix.service"];
      };
      Service = {
        Environment = lib.mapAttrsToList (key: value: "${key}=${value}") runnerEnvironment;
        EnvironmentFile = "%t/secrets/amp-runner-${name}";
        ExecStartPre = checkRunnerToken;
        WorkingDirectory = builtins.head runner.discoverDirs;
        # Do not serve the discovery root itself, only the discovered checkouts.
        ExecStart = lib.concatStringsSep " " (
          ["${amp}/bin/amp" "--no-tui" "--runner-id=nixos-${name}" "--remote-control-terminal" "--no-serve-cwd" "--discover-depth=2"]
          ++ map (dir: "--discover-dirs=${dir}") runner.discoverDirs
          ++ map (pattern: "--discover-exclude=${pattern}") runner.discoverExcludes
          ++ map (dir: "--dir=${dir}") runner.dirs
        );
        Restart = "always";
        RestartSec = 5;
      };
      Install.WantedBy = ["default.target"];
    })
  runners;
}
