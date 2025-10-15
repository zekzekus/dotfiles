{ pkgs, ... }:

{
  enable = true;
  launchd.enable = true;
  userSettings = {
    after-startup-command = [
      "exec-and-forget borders"
    ];
    on-window-detected = [
      {
        check-further-callbacks = false;
        "if" = {
          app-id = "com.mitchellh.ghostty";
        };
        run = [
          "layout floating"
        ];
      }
    ];
    accordion-padding = 50;
    gaps = {
      inner.horizontal = 10;
      inner.vertical = 10;
      outer.left = 10;
      outer.bottom = 10;
      outer.top = 10;
      outer.right = 10;
    };
    mode.main.binding = {
      alt-slash = "layout tiles horizontal vertical";
      alt-comma = "layout accordion horizontal vertical";

      alt-h = "focus left";
      alt-j = "focus down";
      alt-k = "focus up";
      alt-l = "focus right";

      alt-shift-h = "move left";
      alt-shift-j = "move down";
      alt-shift-k = "move up";
      alt-shift-l = "move right";

      alt-minus = "resize smart -50";
      alt-equal = "resize smart +50" ;

      alt-1 = "workspace 1";
      alt-2 = "workspace 2";
      alt-3 = "workspace 3";
      alt-4 = "workspace 4";
      alt-5 = "workspace 5";

      alt-shift-1 = "move-node-to-workspace 1";
      alt-shift-2 = "move-node-to-workspace 2";
      alt-shift-3 = "move-node-to-workspace 3";
      alt-shift-4 = "move-node-to-workspace 4";
      alt-shift-5 = "move-node-to-workspace 5";

      alt-tab = "workspace-back-and-forth";
      alt-shift-tab = "move-workspace-to-monitor --wrap-around next";
      alt-shift-semicolon = "mode service";
    };
    mode.service.binding = {
      esc = ["reload-config" "mode main"];
      r = ["flatten-workspace-tree" "mode main"];
      f = ["layout floating tiling" "mode main"];
      backspace = ["close-all-windows-but-current" "mode main"];

      alt-shift-h = ["join-with left" "mode main"];
      alt-shift-j = ["join-with down" "mode main"];
      alt-shift-k = ["join-with up" "mode main"];
      alt-shift-l = ["join-with right" "mode main"];
    };
  };
}