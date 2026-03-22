{
  pkgs,
  common,
  ...
}: {
  home = {
    packages = with pkgs; [
      uwsm
      brightnessctl
      playerctl
      grim
      slurp
      satty
      gpu-screen-recorder-gtk
      wl-clipboard
      libnotify
      blueman
      nemo
      pavucontrol
      wireplumber
      xwayland-satellite

      glib
      gsettings-desktop-schemas
    ];

    file = {
      "bin/theme-dark".source = "${common.dotfilesDir}/scripts/theme-dark";
      "bin/theme-light".source = "${common.dotfilesDir}/scripts/theme-light";
    };

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
      XCURSOR_SIZE = "24";
      HYPRCURSOR_SIZE = "24";
    };
  };
}
