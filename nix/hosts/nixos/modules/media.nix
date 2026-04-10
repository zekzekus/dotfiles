_: {
  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto-safe";
      vo = "gpu-next";
      gpu-context = "wayland";
      profile = "high-quality";
    };
  };

  programs.imv.enable = true;

  xdg.configFile."mimeapps.list".force = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/png" = "imv.desktop";
      "image/jpeg" = "imv.desktop";
      "image/gif" = "imv.desktop";
      "image/webp" = "imv.desktop";
      "image/tiff" = "imv.desktop";
      "image/bmp" = "imv.desktop";
      "image/svg+xml" = "imv.desktop";
    };
  };
}
