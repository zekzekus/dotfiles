{ pkgs, common, ... }:

{
  home = {
    packages = with pkgs; [
      hypridle
      hyprlock
      hyprpaper
      vicinae
      cliphist
      brightnessctl
      playerctl
      grim
      slurp
      satty
      kooha
      wl-clipboard
      libnotify
      networkmanagerapplet
      polkit_gnome
      blueman
      nemo
      pavucontrol
      wireplumber

      # theme-switch dependencies
      glib
      gsettings-desktop-schemas
      libsForQt5.qt5ct
      kdePackages.qt6ct
      libsForQt5.qtstyleplugin-kvantum

      # themes
      gnome-themes-extra
      orchis-theme
      graphite-gtk-theme
      tela-circle-icon-theme
      
      # Portal
      xdg-desktop-portal-gtk
    ];

    file = {
      "bin/theme-dark".source = "${common.dotfilesDir}/scripts/theme-dark";
      "bin/theme-light".source = "${common.dotfilesDir}/scripts/theme-light";

      ".config/hypr/hyprpaper.conf".text = ''
        preload = ~/Pictures/wallpaper.jpg
        wallpaper = ,~/Pictures/wallpaper.jpg
        splash = false
        ipc = off
      '';
    };
  };

  programs = {
    waybar = import ../../modules/programs/waybar.nix { inherit pkgs; };
    rofi = import ../../modules/programs/rofi.nix { inherit pkgs; };
    hyprlock = import ../../modules/programs/hyprlock.nix { inherit pkgs; };
  };

  services = {
    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = [
          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 600;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };

  home.file = {
    ".config/autostart/nm-applet.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=NetworkManager Applet
      Comment=Manage network connections
      Exec=${pkgs.networkmanagerapplet}/bin/nm-applet --indicator
      Icon=network-manager
      Categories=System;
      NoDisplay=true
    '';

    ".config/autostart/cliphist-store.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Clipboard history store
      Comment=Store clipboard history
      Exec=${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store
      NoDisplay=true
    '';

    ".config/autostart/polkit-gnome.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Polkit GNOME
      Comment=Polkit GNOME authentication agent
      Exec=${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
      Icon=dialog-password
      Categories=System;
      NoDisplay=true
    '';

    ".config/autostart/mako.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Mako notification daemon
      Comment=Lightweight notification daemon for Wayland
      Exec=${pkgs.mako}/bin/mako
      NoDisplay=true
    '';

    ".config/autostart/hyprpaper.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Hyprland wallpaper daemon
      Comment=Wallpaper setter for Hyprland
      Exec=${pkgs.hyprpaper}/bin/hyprpaper
      NoDisplay=true
    '';

    ".config/autostart/vicinae.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Vicinae launcher daemon
      Comment=Application launcher
      Exec=${pkgs.vicinae}/bin/vicinae server
      NoDisplay=true
    '';

    ".config/autostart/waybar.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Waybar
      Comment=Status bar for Wayland
      Exec=${pkgs.waybar}/bin/waybar
      NoDisplay=true
    '';
  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    SDL_VIDEODRIVER = "wayland";
    GTK_USE_PORTAL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };
}
