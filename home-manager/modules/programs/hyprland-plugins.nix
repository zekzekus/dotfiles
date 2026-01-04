{ pkgs, hyprland-plugins, ... }:

{
  wayland.windowManager.hyprland = {
    plugins = [
      hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
    ];

    settings = {
      plugin = {
        hyprexpo = {
          skip_empty = true;
          columns = 2;
          gap_size = 40;
          bg_col = "rgb(111111)";
          workspace_method = "first 1";
          gesture_distance = 300;
        };
      };

      "hyprexpo-gesture" = [
        "4, pinchout, expo, toggle"
      ];

      bind = [
        "$mod, TAB, hyprexpo:expo, toggle"
      ];
    };
  };
}
