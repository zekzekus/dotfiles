{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    plugins = [
      pkgs.hyprlandPlugins.hyprexpo
    ];

    settings = {
      plugin = {
        hyprexpo = {
          skip_empty = true;
          columns = 2;
          gap_size = 40;
          bg_col = "rgb(111111)";
          workspace_method = "first 1";
          enable_gesture = true;
          gesture_positive = true;
        };
      };

      bind = [
        "$mod, TAB, hyprexpo:expo, toggle"
      ];
    };
  };
}
