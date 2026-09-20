{
  pkgs,
  lib,
  common,
  ...
}: {
  programs.tmux.extraConfig = lib.mkAfter ''
    bind-key -T copy-mode-vi 'y' send -X copy-pipe-and-cancel "${pkgs.wl-clipboard}/bin/wl-copy"
  '';

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
      pulseaudio
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
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };
  };
}
