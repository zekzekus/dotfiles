{
  hyprland,
  pkgs,
  common,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    configType = "hyprlang";
    package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "ghostty";
      "$browser" = "helium";

      monitor = ",preferred,auto,1.5";

      input = {
        kb_layout = "tr";
        kb_variant = "alt";
        kb_options = "compose:caps";
        repeat_rate = 60;
        repeat_delay = 300;
        numlock_by_default = true;
        sensitivity = 0.7; # tuned to approximate niri's cursor feel (range -1..1; was 0.9, too fast)
        natural_scroll = true;
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          scroll_factor = 0.4;
          # Apple Magic Trackpad: tap/click behaviour
          "tap-to-click" = true; # 1-finger tap = left click
          tap_button_map = "lrm"; # 1/2/3-finger tap = left/right/middle
          clickfinger_behavior = true; # physical press: 1/2/3 fingers = left/right/middle
          "tap-and-drag" = true; # tap-and-drag to select / move
          drag_lock = false;
        };
      };

      windowrule = [
        "scroll_touchpad 0.2, match:class com.mitchellh.ghostty"

        "tag +pip, match:title (Picture.?in.?[Pp]icture)"
        "float true, match:tag pip"
        "pin true, match:tag pip"
        "size 600 338, match:tag pip"
        "keep_aspect_ratio true, match:tag pip"
        "border_size 0, match:tag pip"
        "opacity 1 1, match:tag pip"
        "move (monitor_w-window_w-40) (monitor_h*0.04), match:tag pip"

        "opacity 0.9 0.9, match:float false, match:focus false"
        "opacity 0.95 0.90, match:class com.mitchellh.ghostty"

        "float true, match:class ^(org.quickshell)$"
        "float true, match:class .blueman-manager-wrapped"
        "float true, match:class nemo"
        "size 1200 700, match:class nemo"
        "float true, match:class org.pulseaudio.pavucontrol"
        "size 1000 450, match:class org.pulseaudio.pavucontrol"

        "float true, match:class ^(one.alynx.showmethekey)$"
        "float true, match:class ^(showmethekey-gtk)$"
        "pin true, match:class ^(showmethekey-gtk)$"
        "no_shadow true, match:class ^(showmethekey-gtk)$"
        "move ((monitor_w*1)-window_w-20) ((monitor_h*1)-window_h-20), match:class ^(showmethekey-gtk)$"
      ];

      layerrule = [
        "blur true, match:namespace ^noctalia-backdrop$"
        "blur_popups true, match:namespace ^noctalia-backdrop$"
        "ignore_alpha 0.5, match:namespace ^noctalia-backdrop$"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 8;
        layout = "master";
        no_focus_fallback = true;
      };

      binds = {
        window_direction_monitor_fallback = false;
      };

      decoration = {
        rounding = 10;
        rounding_power = 2;
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
        };
        blur = {
          enabled = true;
          size = 3;
          passes = 2;
          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "myBezier, 0.05, 0.9, 0.1, 1.05"
          "snappy, 0.2, 1.0, 0.3, 1.0"
        ];
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 3, snappy, slide"
        ];
      };

      dwindle = {
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
        disable_hyprland_logo = true;
        disable_xdg_env_checks = true;
      };

      cursor = {
        no_hardware_cursors = true;
      };

      bind = [
        "$mod, Space, exec, noctalia msg panel-toggle launcher"
        "$mod, V, exec, noctalia msg panel-toggle clipboard"
        "$mod SHIFT CTRL, L, exec, noctalia msg session lock"

        ", XF86AudioMute, exec, noctalia msg volume-mute"
        ", XF86AudioLowerVolume, exec, noctalia msg volume-down"
        ", XF86AudioRaiseVolume, exec, noctalia msg volume-up"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

        ", XF86MonBrightnessUp, exec, noctalia msg brightness-up"
        ", XF86MonBrightnessDown, exec, noctalia msg brightness-down"

        ", XF86AudioPlay, exec, noctalia msg media toggle"
        ", XF86AudioNext, exec, noctalia msg media next"
        ", XF86AudioPrev, exec, noctalia msg media previous"

        "$mod SHIFT, D, exec, noctalia msg theme-mode-toggle"
        "$mod SHIFT, W, exec, noctalia msg panel-toggle wallpaper"
        "$mod SHIFT, C, exec, noctalia msg panel-toggle control-center"
        "$mod SHIFT, S, exec, noctalia msg settings-toggle"
        "$mod SHIFT, Escape, exec, noctalia msg panel-toggle session"

        "$mod, Return, exec, uwsm-app -- $terminal +new-window"
        "$mod, TAB, workspace, e+1"
        "$mod SHIFT, TAB, workspace, e-1"
        "$mod, B, exec, uwsm-app -- $browser"
        "$mod, Q, killactive"
        "$mod CTRL, R, exec, ${common.dotfilesDir}/scripts/cycle-layout"
        "$mod, E, exec, uwsm-app -- nemo"
        "$mod SHIFT CTRL, M, exit"

        # Scrolling-layout column controls (niri-parity)
        "$mod, R, layoutmsg, colresize +conf"
        "$mod SHIFT, R, layoutmsg, colresize -conf"
        "$mod, F, fullscreen, 1"
        "$mod, minus, layoutmsg, colresize -0.1"
        "$mod, equal, layoutmsg, colresize +0.1"
        "$mod SHIFT, minus, resizeactive, 0 -50"
        "$mod SHIFT, equal, resizeactive, 0 50"
        "ALT, P, layoutmsg, consume_or_expel next"

        "$mod SHIFT CTRL, 3, exec, ${common.dotfilesDir}/scripts/screenshot-full"
        "$mod SHIFT CTRL, 4, exec, ${common.dotfilesDir}/scripts/screenshot-area"
        "$mod SHIFT CTRL, 5, exec, uwsm-app -- gpu-screen-recorder-gtk"

        "$mod, h, exec, ${common.dotfilesDir}/scripts/focus-or-workspace l r-1"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, exec, ${common.dotfilesDir}/scripts/focus-or-workspace r r+1"

        "$mod SHIFT, H, swapwindow, l"
        "$mod SHIFT, L, swapwindow, r"
        "$mod SHIFT, K, swapwindow, u"
        "$mod SHIFT, J, swapwindow, d"

        "ALT, J, layoutmsg, togglesplit"
        "ALT, V, togglefloating"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"

        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        # Horizontal scroll = focus column left/right (scrolling layout)
        "$mod, mouse_left, layoutmsg, focus l"
        "$mod, mouse_right, layoutmsg, focus r"
        "$mod SHIFT, mouse_down, layoutmsg, focus r"
        "$mod SHIFT, mouse_up, layoutmsg, focus l"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Magic Trackpad gestures (format: fingers, direction, action[, args]).
      # Hyprland-internal scheme (workspaces are a horizontal list here):
      #   3-finger horizontal -> switch workspaces
      #   3-finger vertical   -> no-op (unmapped)
      #   4-finger            -> overview (unmapped; hyprexpo was removed upstream)
      gesture = [
        "3, horizontal, workspace"
      ];
    };
    extraConfig = ''
      source = ~/.config/hypr/noctalia/noctalia-colors.conf
    '';
  };
}
