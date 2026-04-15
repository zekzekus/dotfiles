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

  home.packages = with pkgs; [
    showmethekey
    droidcam
    cameractrls-gtk4
    emacs-pgtk
  ];
}
