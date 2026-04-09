{...}: {
  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto-safe";
      vo = "gpu-next";
      gpu-context = "wayland";
      profile = "high-quality";
    };
  };
}
