{ ... }:

{
  system.stateVersion = 6;

  system.primaryUser = "zekus";

  nix.enable = false;

  programs.fish.enable = true;

  environment.systemPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "zekus";
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

  system.defaults = {
    NSGlobalDomain = {
      NSAutomaticWindowAnimationsEnabled = false;
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      AppleInterfaceStyleSwitchesAutomatically = true;
    };
    dock = {
      expose-group-apps = true;
      autohide = true;
    };
    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  security.pam.services.sudo_local.touchIdAuth = true;
}
