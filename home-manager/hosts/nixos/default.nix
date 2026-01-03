{
  pkgs,
  ...
}:

{
  imports = [
    ../../modules/shell-modes.nix
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

  desktop.shell.mode = "noctalia";

  home.packages = with pkgs; [
    appimage-run
    (import ../../modules/packages/helium.nix { inherit pkgs; })
    showmethekey
  ];

  services = {
    tailscale-systray.enable = true;
    network-manager-applet.enable = true;
  };
}
