{
  services.flatpak = {
    enable = true;

    remotes = [
      {
        name = "flathub";
        location = "https://flathub.org/repo/flathub.flatpakrepo";
      }
      {
        name = "GeForceNOW";
        location = "https://international.download.nvidia.com/GFNLinux/flatpak/geforcenow.flatpakrepo";
      }
    ];

    packages = [
      {
        appId = "com.nvidia.geforcenow";
        origin = "GeForceNOW";
      }
    ];

    overrides = {
      "com.nvidia.geforcenow" = {
        Context = {
          sockets = "x11;wayland;pulseaudio";
          devices = "dri;all";
          filesystems = "xdg-run/pipewire-0";
        };
        "Session Bus Policy" = {
          "org.freedesktop.Flatpak" = "talk";
          "org.freedesktop.portal.*" = "talk";
        };
      };
    };

    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
  };
}
