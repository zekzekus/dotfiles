{
  pkgs,
  config,
  common,
  ...
}: {
  imports = [
    ./modules/aerospace.nix
    ./modules/jankyborders.nix
  ];

  home = {
    packages = with pkgs; [
      glibtool

      # Docker, the macOS-native way. There is no native container runtime on
      # macOS, so everything runs inside a lightweight Linux VM. Colima (Lima +
      # Docker daemon) provides that VM, rootless; the `docker` CLI and
      # `docker-compose` auto-discover its socket. This mirrors the nixos host's
      # rootless Podman setup without Docker Desktop's licensing.
      #
      # One-time bootstrap after switching:
      #   colima start    # creates + boots the VM (persists across reboots)
      colima
      docker-client # `docker` CLI only (the daemon lives in the Colima VM)
      docker-compose
    ];

    file = {
      ".config/karabiner".source = config.lib.file.mkOutOfStoreSymlink "${common.dotfilesDir}/macosx/karabiner";
      ".hammerspoon/init.lua".source = config.lib.file.mkOutOfStoreSymlink "${common.dotfilesDir}/macosx/hammerspoon/init.lua";
    };

    sessionPath = [
      "/opt/homebrew/bin"
    ];

    sessionVariables = {
      HOMEBREW_NO_INSTALL_CLEANUP = 1;
    };
  };

  programs.bash.enable = true;
}
