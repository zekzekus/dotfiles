{ pkgs, lib, ... }:

{
  stylix = {
    enable = true;
    autoEnable = false;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    polarity = "dark";

    cursor = {
      package = pkgs.volantes-cursors;
      name = "volantes_cursors";
      size = 24;
    };

    targets = {
      btop.enable = true;
      fish.enable = true;
      nushell.enable = true;
      fzf.enable = true;
      lazygit.enable = true;
      tmux.enable = true;

      gtk.enable = true;
      qt.enable = true;

      hyprland.enable = true;
      hyprlock.enable = true;
      hyprpaper.enable = true;
      mako.enable = true;
      rofi.enable = true;
      waybar.enable = true;

      vicinae.enable = true;

      firefox = {
        enable = true;
        profileNames = [ "default" ];
      };
    };
  };

  specialisation = {
    light.configuration = {
      stylix.base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/gruvbox-light-hard.yaml";
      stylix.polarity = lib.mkForce "light";
    };
  };

}
