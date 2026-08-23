{pkgs, ...}: {
  # Plasma is the shared GUI appearance authority for this host. Keep Stylix
  # on CLI targets only so Home Manager does not own Qt/GTK/KDE state.
  stylix = {
    enable = true;
    autoEnable = false;
    enableReleaseChecks = false;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";
    polarity = "dark";

    targets = {
      bat.enable = true;
      btop.enable = true;
      fish.enable = true;
      nushell.enable = true;
      gdu.enable = true;
      lazygit.enable = true;
      tmux.enable = true;

      hyprland.enable = false;
      hyprlock.enable = false;
      hyprpaper.enable = false;
      rofi.enable = false;

      ghostty.enable = false;
      vicinae.enable = false;

      firefox = {
        enable = false;
        profileNames = ["default"];
      };
    };
  };
}
