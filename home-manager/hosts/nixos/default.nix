{
  pkgs,
  config,
  common,
  desktop,
  ...
}:

{
  imports = [
    ../../modules/options.nix
    ./hyprland-integration.nix
    ./stylix.nix
    ../../modules/programs/hyprland.nix
    ../../modules/programs/hyprland-plugins.nix
    ../../modules/programs/waybar.nix
    ../../modules/programs/rofi.nix
    ../../modules/programs/hyprlock.nix
    ../../modules/programs/dms-shell.nix
    ../../modules/programs/caelestia-shell.nix
    ../../modules/programs/noctalia-shell.nix
  ];

  desktop.shell.mode = "dms";

  home = {
    packages = with pkgs; [
      appimage-run
      (import ../../modules/packages/helium.nix { inherit pkgs; })
      showmethekey
    ] ++ desktop.shell.current.packages;

    file = desktop.shell.current.homeFiles {
      mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
      dotfilesDir = common.dotfilesDir;
    };
  };

  services = {
    tailscale-systray.enable = true;
    network-manager-applet.enable = true;
  } // desktop.shell.current.services;

  systemd.user.services = desktop.shell.current.systemdServices;
}
