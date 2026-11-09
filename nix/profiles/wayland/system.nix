# NixOS session prerequisites shared by Wayland desktops. Hardware, accounts,
# extra desktops (e.g. Plasma), and personal services remain host-owned.
{
  pkgs,
  hyprland,
  lib,
  ...
}: let
  hyprPkgs = hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in {
  networking.networkmanager.enable = true;
  hardware.graphics.enable = true;
  services = {
    displayManager.sddm = {
      enable = true;
      wayland = {
        enable = true;
        compositor = "kwin";
      };
    };
    displayManager.defaultSession = lib.mkDefault "niri";
    upower.enable = true;
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    udisks2.enable = true;
    gvfs.enable = true;
  };
  programs = {
    niri.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
      package = hyprPkgs.hyprland;
      portalPackage = hyprPkgs.xdg-desktop-portal-hyprland;
    };
    dconf.enable = true;
  };
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.services.hyprlock = {};
  };
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      hyprPkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    config = {
      common.default = ["gtk"];
      hyprland.default = ["hyprland" "gtk"];
      start-hyprland.default = ["hyprland" "gtk"];
      niri.default = ["gnome" "gtk"];
      start-niri.default = ["gnome" "gtk"];
    };
  };
}
