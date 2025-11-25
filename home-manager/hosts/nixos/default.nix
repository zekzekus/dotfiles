{ pkgs, common, ... }:

{
  imports = [
    ./hyprland-integration.nix
  ];

  stylix.targets = {
    fzf.enable = true;
  };

  wayland.windowManager.hyprland = import ../../modules/programs/hyprland.nix { inherit pkgs common; };

  # Host-specific configuration for nixos
  # 
  # This file is for overrides specific to this machine only.
  # Common Linux settings are in platforms/linux.nix
  # System-level NixOS config is in configuration.nix
  #
  # Examples:
  #   home.packages = with pkgs; [ virt-manager ];
  #   programs.git.userEmail = "nixos@example.com";
  #   home.sessionVariables.NIXOS_MACHINE = "true";
  programs.chromium.enable = true;
}
