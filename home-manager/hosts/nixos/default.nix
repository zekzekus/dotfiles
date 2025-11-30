{ pkgs, common, compositor, ... }:

{
  imports = [
    ./stylix.nix
    ./compositors/${compositor}
  ];

  home = {
    packages = with pkgs; [
      appimage-run
      ghostty
      localsend
      (import ../../modules/packages/helium.nix { inherit pkgs; })
    ];

    file = {
      ".config/ghostty".source = "${common.dotfilesDir}/ghostty";
    };
  };

  programs = {
    chromium.enable = true;

    vicinae = {
      enable = true;
      systemd.enable = true;
    };
  };

  services = {
    network-manager-applet.enable = true;
    polkit-gnome.enable = true;
  };
}