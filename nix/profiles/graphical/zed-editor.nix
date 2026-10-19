{
  lib,
  common,
  pkgs,
  ...
}: {
  programs.zed-editor = {
    enable = true;
    # macOS installs Zed through Homebrew; manage only its configuration here.
    package = lib.mkIf common.isDarwin null;
    userSettings = {
      buffer_font_family = "TX-02";
      buffer_font_size = 18;
      buffer_line_height = "standard";
      terminal.font_family = "TX-02";
      vim_mode = true;
      theme = {
        mode = "system";
        light = "Vimbones Light";
        dark = "Neobones Dark";
      };
    };
    themes.zenbones = ../../../zed/themes/zenbones.json;
    extraPackages = lib.optionals common.isLinux (with pkgs; [
      # LSPs available to the Nix-packaged Zed.
      nil
      nixd
    ]);
  };
}
