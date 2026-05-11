{pkgs, ...}: {
  home.packages = with pkgs; [
    haruna
    loupe
    papers
  ];

  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/png" = "org.gnome.Loupe.desktop";
      "image/jpeg" = "org.gnome.Loupe.desktop";
      "image/gif" = "org.gnome.Loupe.desktop";
      "image/webp" = "org.gnome.Loupe.desktop";
      "image/tiff" = "org.gnome.Loupe.desktop";
      "image/bmp" = "org.gnome.Loupe.desktop";
      "image/svg+xml" = "org.gnome.Loupe.desktop";
      "application/pdf" = "org.gnome.Papers.desktop";
      "video/mp4" = "org.kde.haruna.desktop";
      "video/x-matroska" = "org.kde.haruna.desktop";
      "video/webm" = "org.kde.haruna.desktop";
      "video/quicktime" = "org.kde.haruna.desktop";
      "video/x-msvideo" = "org.kde.haruna.desktop";
    };
  };
}
