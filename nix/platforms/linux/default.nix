{pkgs, ...}: {
  imports = [
    ./modules/firefox.nix
    ./modules/zed-editor.nix
  ];

  programs = {
    chromium.enable = true;

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-pipewire-audio-capture # PipeWire audio capture
        droidcam-obs
      ];
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

  home.packages = with pkgs; [
    showmethekey
    droidcam
    cameractrls-gtk4
  ];
}
