{ pkgs, common, lib, ... }:

{
  imports = [
    ./hyprland-integration.nix
  ];

  wayland.windowManager.hyprland = import ../programs/hyprland.nix { inherit pkgs common; };

  programs = {
    bash.enable = false;
  };

  home = {
    packages = with pkgs; [
      ghostty
    ];

    file = {
      ".config/ghostty".source = "${common.dotfilesDir}/ghostty";
    };
  };
}
