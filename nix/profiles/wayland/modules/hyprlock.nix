_: {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
        grace = 0;
      };

      label = [
        {
          text = "cmd[update:1000] echo \"<span foreground='##cad3f5'>$(date +'%H:%M')</span>\"";
          font_size = 55;
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
