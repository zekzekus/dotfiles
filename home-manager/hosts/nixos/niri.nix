{pkgs, ...}: {
  imports = [
    ../../modules/programs/niri.nix
  ];

  home.packages = with pkgs; [
    xdg-desktop-portal-gnome
  ];
}
