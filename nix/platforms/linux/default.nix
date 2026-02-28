{pkgs, ...}: {
  imports = [
    ../../modules/programs/firefox.nix
    ../../modules/programs/zed-editor.nix
  ];

  programs = {
    chromium.enable = true;
  };

  home.packages = with pkgs; [
    cameractrls-gtk4
  ];
}
