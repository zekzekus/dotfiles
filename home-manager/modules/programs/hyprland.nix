{ common, hyprland, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
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
        sensitivity = 0.90;
        natural_scroll = true;
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          scroll_factor = 0.4;
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

      layerrule = {
        name = "noctalia";
        "match:namespace" = "noctalia-background-.*$";
        ignore_alpha = 0.5;
        blur = true;
        blur_popups = true;
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        layout = "master";
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

      cursor = {
        no_hardware_cursors = true;
      };

      bind = [
        "$mod, Space, exec, noctalia-shell ipc call launcher toggle"
        "$mod, V, exec, noctalia-shell ipc call launcher clipboard"
        "$mod SHIFT CTRL, L, exec, noctalia-shell ipc call lockScreen lock"

        ", XF86AudioMute, exec, noctalia-shell ipc call volume muteOutput"
        ", XF86AudioLowerVolume, exec, noctalia-shell ipc call volume decrease"
        ", XF86AudioRaiseVolume, exec, noctalia-shell ipc call volume increase"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

        ", XF86MonBrightnessUp, exec, noctalia-shell ipc call brightness increase"
        ", XF86MonBrightnessDown, exec, noctalia-shell ipc call brightness decrease"

        ", XF86AudioPlay, exec, noctalia-shell ipc call media playPause"
        ", XF86AudioNext, exec, noctalia-shell ipc call media next"
        ", XF86AudioPrev, exec, noctalia-shell ipc call media previous"

        "$mod SHIFT, D, exec, noctalia-shell ipc call darkMode toggle"
        "$mod SHIFT, W, exec, noctalia-shell ipc call wallpaper toggle"
        "$mod SHIFT, C, exec, noctalia-shell ipc call controlCenter toggle"
        "$mod SHIFT, S, exec, noctalia-shell ipc call settings toggle"
        "$mod SHIFT, Escape, exec, noctalia-shell ipc call sessionMenu toggle"

        "$mod, Return, exec, uwsm-app -- $terminal +new-window"
        "$mod SHIFT, TAB, workspace, e-1"
        "$mod, B, exec, uwsm-app -- $browser"
        "$mod, Q, killactive"
        "$mod, E, exec, uwsm-app -- nemo"
        "$mod SHIFT CTRL, M, exit"

        "$mod SHIFT CTRL, 3, exec, ${common.dotfilesDir}/scripts/screenshot-full"
        "$mod SHIFT CTRL, 4, exec, ${common.dotfilesDir}/scripts/screenshot-area"
        "$mod SHIFT CTRL, 5, exec, uwsm-app -- gpu-screen-recorder-gtk"

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

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"

        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };
}
