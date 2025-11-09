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
    ];

    file = {
      ".config/ghostty".source = "${common.dotfilesDir}/ghostty";
    };
  };

  services = {
  };

  home.sessionVariables = {
    GDK_SCALE = "1.50";
    NIXOS_OZONE_WL = "1";
  };
}
