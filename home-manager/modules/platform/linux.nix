{ pkgs, common, lib, ... }:

{
  imports = [
    ./gnome.nix
    ./hyprland-integration.nix
  ];

  wayland.windowManager.hyprland = import ../programs/hyprland.nix { inherit pkgs common; };

  programs = {
    bash.enable = false;
  };

  home = {
    packages = with pkgs; [
      ghostty
      nautilus
      pavucontrol
      wireplumber
    ];

    file = {
      ".config/ghostty".source = "${common.dotfilesDir}/ghostty";
    };
  };
}
