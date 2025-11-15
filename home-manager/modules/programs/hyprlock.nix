{ pkgs, ... }:

{
  enable = true;
  settings = {
    general = {
      disable_loading_bar = true;
      hide_cursor = true;
      grace = 0;
    };

    background = [
      {
        path = "screenshot";
        blur_passes = 3;
        blur_size = 5;
      }
    ];

    input-field = [
      {
        size = "300, 50";
        position = "0, -80";
        monitor = "";
        dots_center = true;
        fade_on_empty = false;
        font_color = "rgb(202, 211, 245)";
        inner_color = "rgb(26, 27, 38)";
        outer_color = "rgb(137, 180, 250)";
        outline_thickness = 2;
        placeholder_text = "<span foreground=\"##cad3f5\">Password...</span>";
        shadow_passes = 2;
      }
    ];

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
}
