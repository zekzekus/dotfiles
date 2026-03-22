{pkgs, ...}: {
  imports = [
    ./modules/firefox.nix
    ./modules/zed-editor.nix
  ];

  programs = {
    chromium.enable = true;
  };

  home.packages = with pkgs; [
    cameractrls-gtk4
  ];
}
