{pkgs, ...}: {
  programs.zed-editor = {
    enable = true;
    userSettings = {
      buffer_font_family = "TX-02";
      buffer_font_size = 18;
      buffer_line_height = "standard";
      vim_mode = true;
      theme = {
        mode = "system";
        light = "Vimbones Light";
        dark = "Neobones Dark";
      };
    };
    themes.zenbones = ../../../../zed/themes/zenbones.json;
    extraPackages = with pkgs; [
      # LSPs
      nil
      nixd
    ];
  };
}
