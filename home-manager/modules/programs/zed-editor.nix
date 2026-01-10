{pkgs, ...}: {
  programs.zed-editor = {
    enable = true;
    userSettings = {
      buffer_font_family = "TX-02";
      buffer_font_size = 16;
      buffer_line_height = "standard";
      vim_mode = true;
      theme = {
        mode = "system";
        light = "Noctalia Light";
        dark = "Noctalia Dark";
      };
    };
    extraPackages = with pkgs; [
      # LSPs
      nil
      nixd
    ];
  };
}
