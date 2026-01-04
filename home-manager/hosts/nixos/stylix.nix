{ pkgs, ... }:

{
  stylix = {
    enable = true;
    autoEnable = false;
    enableReleaseChecks = false;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";
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
      bat.enable = true;
      btop.enable = true;
      fish.enable = true;
      nushell.enable = true;
      fzf.enable = true;
      gdu.enable = true;
      lazygit.enable = true;
      tmux.enable = true;

      gtk.enable = true;
      qt.enable = true;

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
