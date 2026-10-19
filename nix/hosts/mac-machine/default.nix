{
  config,
  common,
  lib,
  pkgs,
  ...
}: let
  amp = pkgs.callPackage ../../modules/packages/amp.nix {};
  runners = {
    personal = {
      discoverDirs = [
        "${common.homeDir}/devel/projects/personal"
        "${common.homeDir}/devel/projects/playground"
        "${common.homeDir}/devel/tools"
      ];
      discoverExcludes = ["${common.homeDir}/devel/tools/*/*"];
      dirs = [];
    };
    work = {
      discoverDirs = ["${common.homeDir}/devel/projects/work"];
      discoverExcludes = [];
      dirs = ["${common.homeDir}/Documents/dev.zeko.miracle"];
    };
  };
  startRunner = pkgs.writeShellScript "start-amp-runner" ''
    set -euo pipefail
    unset AMP_API_KEY
    secret_file=$1
    shift

    # launchd has no EnvironmentFile or service ordering. Fail closed until
    # SOPS publishes the file; KeepAlive retries. Never source dotenv as code.
    if [[ ! -r "$secret_file" ]]; then
      echo "Waiting for the runner's SOPS credential file." >&2
      exit 1
    fi
    credentials=$(< "$secret_file")
    if [[ ! "$credentials" =~ ^AMP_API_KEY=([^[:space:]]+)$ ]]; then
      echo "The runner credential file must contain one nonempty, unquoted AMP_API_KEY assignment." >&2
      exit 1
    fi
    export AMP_API_KEY="''${BASH_REMATCH[1]}"
    unset credentials
    exec "$@"
  '';
  runnerEnvironment =
    common.sessionVariables
    // {
      HOME = common.homeDir;
      AMP_API_KEY = "";
      inherit (config.home.sessionVariables) SSH_AUTH_SOCK;
      PATH = lib.concatStringsSep ":" (config.home.sessionPath
        ++ [
          "/etc/profiles/per-user/${common.username}/bin"
          "/nix/var/nix/profiles/default/bin"
          "/run/current-system/sw/bin"
          "/usr/bin"
          "/bin"
          "/usr/sbin"
          "/sbin"
        ]);
    };
in {
  sops = {
    age.keyFile = "${common.homeDir}/.config/sops/age/keys.txt";
    secrets = lib.genAttrs (map (name: "amp-runner-${name}") (builtins.attrNames runners)) (name: {
      sopsFile = ../../../secrets + "/${name}.env";
      format = "dotenv";
      key = "";
      mode = "0600";
    });
  };

  # Separate account credentials and discovery lists, not OS-user isolation.
  # LaunchAgents run during the user's login session, unlike NixOS lingering.
  launchd.agents = lib.mapAttrs' (name: runner:
    lib.nameValuePair "amp-runner-${name}" {
      enable = true;
      config = {
        ProgramArguments =
          [
            "${startRunner}"
            config.sops.secrets."amp-runner-${name}".path
            "${amp}/bin/amp"
            "--no-tui"
            "--runner-id=mac-machine-${name}"
            "--remote-control-terminal"
            "--no-serve-cwd"
            "--discover-depth=2"
          ]
          ++ map (dir: "--discover-dirs=${dir}") runner.discoverDirs
          ++ map (pattern: "--discover-exclude=${pattern}") runner.discoverExcludes
          ++ map (dir: "--dir=${dir}") runner.dirs;
        EnvironmentVariables = runnerEnvironment;
        WorkingDirectory = builtins.head runner.discoverDirs;
        RunAtLoad = true;
        KeepAlive = true;
        ThrottleInterval = 5;
        Umask = 63; # 0077: runner-created files and logs are private by default.
        StandardOutPath = "${common.homeDir}/Library/Logs/amp-runner-${name}.log";
        StandardErrorPath = "${common.homeDir}/Library/Logs/amp-runner-${name}.err.log";
      };
    })
  runners;
}
