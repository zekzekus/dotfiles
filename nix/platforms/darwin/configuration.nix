{common, ...}: {
  # Increase file descriptor limits to prevent "Too many open files" during Nix builds
  # Sets kernel-level limits (required for per-process limits to work)
  launchd.daemons.limit-maxfiles = {
    serviceConfig = {
      Label = "limit.maxfiles";
      ProgramArguments = ["/bin/launchctl" "limit" "maxfiles" "524288" "524288"];
      RunAtLoad = true;
    };
  };
  launchd.daemons.sysctl-maxfiles = {
    serviceConfig = {
      Label = "sysctl.maxfiles";
      ProgramArguments = ["/usr/sbin/sysctl" "-w" "kern.maxfiles=524288" "kern.maxfilesperproc=524288"];
      RunAtLoad = true;
    };
  };

  system = {
    stateVersion = 6;
    primaryUser = common.username;
    defaults = {
      NSGlobalDomain = {
        NSAutomaticWindowAnimationsEnabled = false;
        KeyRepeat = 2;
        InitialKeyRepeat = 15;
        AppleInterfaceStyleSwitchesAutomatically = true;
      };
      ".GlobalPreferences"."com.apple.mouse.scaling" = 1.5;
      dock = {
        expose-group-apps = true;
        autohide = true;
        wvous-tl-corner = 2;
      };
      # Apple Magic Trackpad, kept consistent with niri's hardcoded scheme:
      #   tap = click, 2-finger = right click, 1-finger tap-drag = select/move,
      #   3-finger swipe = navigation (Spaces left/right, Mission Control up,
      #   App Exposé down). macOS groups these swipes under one finger count, so
      #   niri's "3-finger nav + 4-finger overview" split collapses to 3-finger.
      # Takes effect after a logout or `killall Dock`.
      trackpad = {
        Clicking = true; # tap-to-click: 1-finger tap = left click
        Dragging = true; # 1-finger tap-and-drag to select / move (matches niri `drag`)
        TrackpadRightClick = true; # 2-finger tap/click = right click
        TrackpadThreeFingerDrag = false; # off, so 3 fingers are free for swipe navigation
        TrackpadThreeFingerVertSwipeGesture = 2; # 3-finger up = Mission Control (overview), down = App Exposé
        TrackpadThreeFingerHorizSwipeGesture = 2; # 3-finger left/right = switch Spaces (workspaces)
        TrackpadFourFingerVertSwipeGesture = 0; # disable 4-finger to avoid double-triggering
        TrackpadFourFingerHorizSwipeGesture = 0;
      };
    };

    defaults.CustomUserPreferences = {
      # No typed dock option exists for this; the swipe-up = Mission Control
      # gesture needs it enabled in the dock domain.
      "com.apple.dock".showMissionControlGestureEnabled = true;
      # Trackpad tracking speed. macOS uses a different acceleration model than
      # libinput, so this can't match niri/Hyprland exactly; this is a moderate
      # value approximating niri's default feel (tune in System Settings slider).
      NSGlobalDomain."com.apple.trackpad.scaling" = 0.875;
    };
  };

  # Intentional: Determinate Nix manages the Nix installation; nix-darwin must not interfere
  nix.enable = false;

  programs.fish.enable = true;

  environment.systemPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = common.username;
    autoMigrate = true;
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      cleanup = "zap";
    };
    taps = [
      "d12frosted/emacs-plus"
    ];
    brews = [
      "emacs-plus@30"
    ];
    casks = [
      "1password"
      "1password-cli"
      "helium-browser"
      "zed"
      "raycast"
      "karabiner-elements"
      "hammerspoon"
      "obsidian"
      # Docker Desktop — official all-in-one: bundles its own Linux VM, the
      # Docker daemon, the `docker`/`docker compose` CLIs, and a GUI.
      # Self-updates outside Nix.
      "docker-desktop"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  security.pam.services.sudo_local.touchIdAuth = true;
}
