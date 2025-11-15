{ pkgs, common, lib, ... }:

{
  imports = [
    ./gnome.nix
  ];

  wayland.windowManager.hyprland = import ../programs/hyprland.nix { inherit pkgs; };

  programs = {
    bash.enable = false;
    
    waybar = import ../programs/waybar.nix { inherit pkgs; };
    wofi = import ../programs/wofi.nix { inherit pkgs; };
  };

  home = {
    packages = with pkgs; [
      ghostty
      nautilus
      pavucontrol
      wireplumber
      grim
      slurp
      wl-clipboard
      libnotify
    ];

    file = {
      ".config/ghostty".source = "${common.dotfilesDir}/ghostty";
    };
  };

  services = {
    mako = {
      enable = true;
      settings = {
        background-color = "#1a1b26";
        text-color = "#cdd6f4";
        border-color = "#89b4fa";
        border-radius = 5;
        border-size = 2;
        default-timeout = 5000;
        ignore-timeout = true;
        layer = "overlay";
      };
    };
  };

  home.sessionVariables = {
    GDK_SCALE = "1.50";
    NIXOS_OZONE_WL = "1";
  };
}