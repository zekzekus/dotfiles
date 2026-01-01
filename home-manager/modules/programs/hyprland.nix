{ common, desktop, ... }:

let
  shell = desktop.shell.current;
  isCaelestia = shell.caelestia.enable;
  isNoctalia = shell.noctalia.enable;

  mkBind = key: cmd:
    if cmd == null then null
    else if shell.bindType == "global" then "${key}, global, ${cmd}"
    else "${key}, exec, ${cmd}";

  filterNull = builtins.filter (x: x != null);
in

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "ghostty";
      "$browser" = "helium";
      "$launcher" = "vicinae toggle";

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
        "scroll_touchpad 1.5, match:class (Alacritty|kitty)"
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
        "opacity 0.95 0.90, match:class (kitty|Alacritty)"
        "opacity 0.95 0.90, match:class (Code|code-url-handler)"

        "rounding 10, match:class ^(org\\.gnome\\.)"
        "float true, match:class ^(gnome-calculator)$"
        "float true, match:class ^(blueman-manager)$"
        "float true, match:class ^(org\\.gnome\\.Nautilus)$"

        "float true, match:class ^(org.quickshell)$"
        "float true, match:class ^(one.alynx.showmethekey)$"
        "float true, match:class ^(showmethekey-gtk)$"
        "pin true, match:class ^(showmethekey-gtk)$"
        "no_shadow true, match:class ^(showmethekey-gtk)$"
        "move 100%-w-20 100%-w-20, match:class ^(showmethekey-gtk)$"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 1;
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
        "blur true, match:namespace vicinae"
        "ignore_alpha 0, match:namespace vicinae"
        "no_anim true, match:namespace vicinae"
        "no_anim true, match:namespace ^(dms)$"
      ];

      bind = filterNull [
        (mkBind "$mod, Space" shell.launcher)
        (mkBind "$mod, V" shell.clipboard)
        (mkBind "$mod SHIFT CTRL, L" shell.lock)

        (mkBind ", XF86AudioMute" shell.volumeMute)
        (mkBind ", XF86AudioLowerVolume" shell.volumeDown)
        (mkBind ", XF86AudioRaiseVolume" shell.volumeUp)

        (mkBind ", XF86MonBrightnessUp" shell.brightnessUp)
        (mkBind ", XF86MonBrightnessDown" shell.brightnessDown)
      ] ++ [
        "$mod, Return, exec, uwsm-app -- $terminal +new-window"
        "$mod SHIFT, TAB, workspace, e-1"
        "$mod, B, exec, uwsm-app -- $browser"
        "$mod, Q, killactive"
        "$mod, E, exec, uwsm-app -- nemo"
        "$mod SHIFT CTRL, M, exit"

        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ]
      ++ (if isNoctalia then [] else [
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ])
      ++ [

        "$mod SHIFT CTRL, 3, exec, ${common.dotfilesDir}/scripts/screenshot-full"
        "$mod SHIFT CTRL, 4, exec, ${common.dotfilesDir}/scripts/screenshot-area"
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
      ]
      ++ (if isCaelestia then [
        "$mod, V, exec, pkill fuzzel || caelestia clipboard"

        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioLowerVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-"
        ", XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 3%+"

        "$mod SHIFT, Escape, global, caelestia:session"
        "$mod, Delete, global, caelestia:clearNotifs"
      ] else [])
      ++ (if isNoctalia then [
        "$mod, C, exec, noctalia-shell ipc call controlCenter toggle"
        "$mod SHIFT, S, exec, noctalia-shell ipc call settings toggle"

        "$mod SHIFT, Escape, exec, noctalia-shell ipc call sessionMenu toggle"
        "$mod, Delete, exec, noctalia-shell ipc call notifications dismissAll"
        "$mod SHIFT, Delete, exec, noctalia-shell ipc call notifications clear"

        "$mod, D, exec, noctalia-shell ipc call darkMode toggle"

        "$mod, W, exec, noctalia-shell ipc call wallpaper toggle"

        ", XF86AudioPlay, exec, noctalia-shell ipc call media playPause"
        ", XF86AudioNext, exec, noctalia-shell ipc call media next"
        ", XF86AudioPrev, exec, noctalia-shell ipc call media previous"
      ] else []);

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };
}
