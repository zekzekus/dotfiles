{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    
    settings = {
      monitor = ",preferred,auto,1.5";
      
      env = [
        "XCURSOR_SIZE,24"
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "TERMINAL,ghostty"
        "BROWSER,chromium"
      ];

      exec-once = [
        "waybar"
        "mako"
        "hyprpaper"
        "nm-applet --indicator"
      ];

      input = {
        kb_layout = "tr";
        kb_variant = "alt";
        
        follow_mouse = 1;
        natural_scroll = true;
        touchpad = {
          natural_scroll = true;
        };
        
        sensitivity = 0;
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
        allow_tearing = false;
      };

      decoration = {
        rounding = 8;
        
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
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      misc = {
        force_default_wallpaper = 0;
      };

      "$mainMod" = "SUPER";

      bind = [
        "$mainMod, Return, exec, ghostty"
        "$mainMod, Q, killactive"
        "$mainMod, M, exit"
        "$mainMod, E, exec, nautilus"
        "$mainMod, V, togglefloating"
        "$mainMod, Space, exec, rofi -show drun"
        "$mainMod, P, pseudo"
        "$mainMod, J, togglesplit"
        
        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"
        
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
        
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      windowrulev2 = [
        "suppressevent maximize, class:.*"
      ];
    };
  };

  home.packages = with pkgs; [
    waybar
    rofi
    mako
    hyprpaper
    hyprshot
    wl-clipboard
    cliphist
    networkmanagerapplet
    pavucontrol
    brightnessctl
    grim
    slurp
    swaylock
    swayidle
  ];

  programs.waybar = {
    enable = true;
    settings = [{
      layer = "top";
      position = "top";
      height = 30;
      spacing = 4;
      
      modules-left = [ "hyprland/workspaces" "hyprland/window" ];
      modules-center = [ "clock" ];
      modules-right = [ "pulseaudio" "network" "battery" "tray" ];
      
      "hyprland/workspaces" = {
        format = "{icon}";
        format-icons = {
          "1" = "1";
          "2" = "2";
          "3" = "3";
          "4" = "4";
          "5" = "5";
          "6" = "6";
          "7" = "7";
          "8" = "8";
          "9" = "9";
          "10" = "10";
        };
      };
      
      clock = {
        format = "{:%H:%M}";
        format-alt = "{:%Y-%m-%d}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };
      
      battery = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{capacity}% {icon}";
        format-icons = [ "" "" "" "" "" ];
      };
      
      network = {
        format-wifi = "{essid} ";
        format-ethernet = "{ipaddr}/{cidr} ";
        tooltip-format = "{ifname} via {gwaddr} ";
        format-linked = "{ifname} (No IP) ";
        format-disconnected = "Disconnected ⚠";
      };
      
      pulseaudio = {
        format = "{volume}% {icon}";
        format-muted = "";
        format-icons = {
          default = [ "" "" "" ];
        };
        on-click = "pavucontrol";
      };
    }];
    
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        min-height: 0;
      }
      
      window#waybar {
        background: rgba(43, 48, 59, 0.9);
        border-bottom: 3px solid rgba(100, 114, 125, 0.5);
        color: #ffffff;
      }
      
      #workspaces button {
        padding: 0 5px;
        color: #ffffff;
      }
      
      #workspaces button.active {
        background: rgba(0, 0, 0, 0.3);
      }
      
      #workspaces button.urgent {
        background-color: #eb4d4b;
      }
      
      #clock,
      #battery,
      #network,
      #pulseaudio,
      #tray {
        padding: 0 10px;
      }
    '';
  };

  services.mako = {
    enable = true;
    settings = {
      background-color = "#2b303b";
      text-color = "#c0c5ce";
      border-color = "#65737e";
      border-size = 2;
      border-radius = 5;
      default-timeout = 5000;
      layer = "overlay";
    };
  };

  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = ~/.config/wallpaper.png
    wallpaper = ,~/.config/wallpaper.png
  '';
}
