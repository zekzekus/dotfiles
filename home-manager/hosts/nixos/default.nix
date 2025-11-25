{ pkgs, lib, common, ... }:

{
  imports = [
    ./hyprland-integration.nix
  ];

  stylix = {
    enable = true;
    autoEnable = false;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    polarity = "dark";

    cursor = {
      package = pkgs.volantes-cursors;
      name = "volantes_cursors";
      size = 24;
    };

    targets = {
      vicinae.enable = true;
      qt.enable = true;
      lazygit.enable = true;
      btop.enable = true;
      waybar.enable = true;
      mako.enable = true;
      rofi.enable = true;
      gtk.enable = true;
      fzf.enable = true;
      firefox = {
        enable = true;
        profileNames = [ "default" ];
      };
    };
  };

  specialisation = {
    light.configuration = {
      stylix.base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/gruvbox-light-hard.yaml";
      stylix.polarity = lib.mkForce "light";
    };
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
