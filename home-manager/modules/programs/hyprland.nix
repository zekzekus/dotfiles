{ common, shellMode ? "default", ... }:

let
  launcherCmd = {
    "default" = "$launcher";
    "dms" = "dms ipc spotlight toggle";
  }.${shellMode} or "$launcher";
in

{
  enable = true;
  settings = {
    "$mod" = "SUPER";
    "$terminal" = "ghostty";
    "$browser" = "helium";
    "$launcher" = "rofi -show drun";

    monitor = ",preferred,auto,1.5";

    exec-once = [
    ];

    input = {
      kb_layout = "tr";
      kb_variant = "alt";
      kb_options = "compose:caps";
      repeat_rate = 60;
      repeat_delay = 300;
      numlock_by_default = true;
      sensitivity = 0.90;
      natural_scroll = true;
      follow_mouse = 1;
      touchpad = {
        natural_scroll = true;
        scroll_factor = 0.4;
      };
    };

    windowrule = [
      "scrolltouchpad 1.5, class:(Alacritty|kitty)"
      "scrolltouchpad 0.2, class:com.mitchellh.ghostty"

      "tag +pip, title:(Picture.?in.?[Pp]icture)"
      "float, tag:pip"
      "pin, tag:pip"
      "size 600 338, tag:pip"
      "keepaspectratio, tag:pip"
      "noborder, tag:pip"
      "opacity 1 1, tag:pip"
      "move 100%-w-40 4%, tag:pip"
    ];

    windowrulev2 = [
      # Opacity for inactive windows
      "opacity 0.9 0.9, floating:0, focus:0"
      "opacity 0.95 0.90, class:com.mitchellh.ghostty"
      "opacity 0.95 0.90, class:(kitty|Alacritty)"
      "opacity 0.95 0.90, class:(Code|code-url-handler)"

      # GNOME apps
      "rounding 10, class:^(org\\.gnome\\.)"

      # Floating windows
      "float, class:^(gnome-calculator)$"
      "float, class:^(blueman-manager)$"
      "float, class:^(org\\.gnome\\.Nautilus)$"

      # Open DMS windows as floating by default
      "float, class:^(org.quickshell)$"
    ];

    general = {
      gaps_in = 5;
      gaps_out = 10;
      border_size = 2;
      layout = "master";
    };

    decoration = {
      rounding = 10;
      shadow = {
          enabled = true;
          range = 30;
          render_power = 5;
          offset = "0 5";
      };
      blur = {
        enabled = true;
        size = 3;
        passes = 1;
      };
    };

    animations = {
      enabled = true;
      bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
      animation = [
        "windows, 1, 7, myBezier"
        "windowsOut, 1, 7, default, popin 80%"
        "border, 1, 10, default"
        "fade, 1, 7, default"
        "workspaces, 1, 6, default"
      ];
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    master = {
      new_status = "slave";
      mfact = 0.60;
    };

    xwayland = {
      force_zero_scaling = true;
    };

    misc = {
      vfr = true;
      disable_hyprland_logo = true;
    };

    layerrule = [
      "blur, vicinae"
      "ignorealpha 0, vicinae"
      "noanim, vicinae"
      "noanim, ^(dms)$"
    ];

    bind = [
      "$mod, Space, exec, ${launcherCmd}"
      "$mod, Return, exec, uwsm-app -- $terminal +new-window"
      "$mod, TAB, workspace, e+1"
      "$mod SHIFT, TAB, workspace, e-1"
      "$mod, B, exec, uwsm-app -- $browser"
      "$mod, Q, killactive"
      "$mod, E, exec, uwsm-app -- nemo"
      "$mod, V, exec, dms ipc call clipboard toggle"
      "$mod SHIFT CTRL, M, exit"
      "$mod SHIFT CTRL, L, exec, dms ipc call lock lock"

      # Audio control (one-shot utilities)
      ", XF86AudioMute, exec, dms ipc call audio mute"
      ", XF86AudioLowerVolume, exec, dms ipc call audio decrement 3"
      ", XF86AudioRaiseVolume, exec, dms ipc call audio increment 3"
      ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"

      # Brightness control (one-shot utilities)
      ", XF86MonBrightnessUp, exec, dms ipc call brightnessctl increment 5"
      ", XF86MonBrightnessDown, exec, dms ipc call brightnessctl decrement 5"

      # Screenshots (one-shot utilities)
      "$mod SHIFT CTRL, 3, exec, ${common.dotfilesDir}/scripts/screenshot-full"
      "$mod SHIFT CTRL, 4, exec, ${common.dotfilesDir}/scripts/screenshot-area"

      # Screen recording with GUI
      "$mod SHIFT CTRL, 5, exec, uwsm-app -- kooha"

      "$mod, h, movefocus, l"
      "$mod, j, movefocus, d"
      "$mod, k, movefocus, u"
      "$mod, l, movefocus, r"

      "$mod SHIFT, H, swapwindow, l"
      "$mod SHIFT, L, swapwindow, r"
      "$mod SHIFT, K, swapwindow, u"
      "$mod SHIFT, J, swapwindow, d"

      "ALT, J, togglesplit"
      "ALT, P, pseudo"
      "ALT, V, togglefloating"

      "$mod, 1, workspace, 1"
      "$mod, 2, workspace, 2"
      "$mod, 3, workspace, 3"
      "$mod, 4, workspace, 4"
      "$mod, 5, workspace, 5"
      "$mod, 6, workspace, 6"
      "$mod, 7, workspace, 7"
      "$mod, 8, workspace, 8"
      "$mod, 9, workspace, 9"
      "$mod, 0, workspace, 10"

      "$mod SHIFT, 1, movetoworkspace, 1"
      "$mod SHIFT, 2, movetoworkspace, 2"
      "$mod SHIFT, 3, movetoworkspace, 3"
      "$mod SHIFT, 4, movetoworkspace, 4"
      "$mod SHIFT, 5, movetoworkspace, 5"
      "$mod SHIFT, 6, movetoworkspace, 6"
      "$mod SHIFT, 7, movetoworkspace, 7"
      "$mod SHIFT, 8, movetoworkspace, 8"
      "$mod SHIFT, 9, movetoworkspace, 9"
      "$mod SHIFT, 0, movetoworkspace, 10"

      "$mod, mouse_down, workspace, e+1"
      "$mod, mouse_up, workspace, e-1"
    ];

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
  };
}
