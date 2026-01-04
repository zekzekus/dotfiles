{ pkgs, ... }:

{
  stylix = {
    enable = true;
    autoEnable = false;
    enableReleaseChecks = false;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    polarity = "dark";

    cursor = {
      package = pkgs.volantes-cursors;
      name = "volantes_cursors";
      size = 24;
    };

    icons = {
      enable = true;
      package = pkgs.tela-circle-icon-theme;
      dark = "Tela-circle-dark";
      light = "Tela-circle-light";
    };

    targets = {
      bat.enable = false;
      btop.enable = false;
      fish.enable = false;
      nushell.enable = false;
      fzf.enable = false;
      gdu.enable = false;
      lazygit.enable = false;
      tmux.enable = false;

      gtk.enable = false;
      qt.enable = false;

      hyprland.enable = false;
      hyprlock.enable = false;
      hyprpaper.enable = false;
      rofi.enable = false;

      ghostty.enable = false;
      vicinae.enable = false;

      firefox = {
        enable = false;
        profileNames = [ "default" ];
      };
    };
  };

}
