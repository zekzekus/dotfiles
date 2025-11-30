{ pkgs, common, ... }:

{
  home = {
    packages = with pkgs; [
      brightnessctl
      playerctl
      libnotify
      blueman
      nemo
      pavucontrol
      wireplumber

      # theme-switch dependencies (gsettings for live gtk switching)
      glib
      gsettings-desktop-schemas

      # Portal
      xdg-desktop-portal-gtk
    ];

    file = {
      "bin/theme-dark".source = "${common.dotfilesDir}/scripts/theme-dark";
      "bin/theme-light".source = "${common.dotfilesDir}/scripts/theme-light";
    };
  };
}
