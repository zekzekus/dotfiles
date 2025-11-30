{ pkgs, ... }:

{
  imports = [
    ./stylix.nix
  ];

  home = {
    packages = with pkgs; [
      grim
      slurp
      satty
      kooha
      wl-clipboard
    ];

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland";
      GDK_BACKEND = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      SDL_VIDEODRIVER = "wayland";
      GTK_USE_PORTAL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };
  };

  programs = {
    waybar = import ../../../../modules/programs/waybar.nix { inherit pkgs; };
    rofi = import ../../../../modules/programs/rofi.nix { inherit pkgs; };
  };

  services = {
    cliphist.enable = true;

    mako = {
      enable = true;
      settings = {
        default-timeout = 3000;
        layer = "overlay";
        anchor = "top-right";
      };
    };
  };
}
