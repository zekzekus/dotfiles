{common, ...}: {
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
      };
      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };
  };

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
    casks = [
      "zed"
      "raycast"
      "karabiner-elements"
      "hammerspoon"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  security.pam.services.sudo_local.touchIdAuth = true;
}
