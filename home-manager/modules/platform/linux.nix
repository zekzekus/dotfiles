{ pkgs, common, lib, ... }:

{
  imports = [
    ./gnome.nix
  ];

  wayland.windowManager.hyprland = import ../programs/hyprland.nix { inherit pkgs; };

  programs = {
    bash.enable = false;
    waybar = import ../programs/waybar.nix { inherit pkgs; };
    rofi = import ../programs/rofi.nix { inherit pkgs; };
    hyprlock = import ../programs/hyprlock.nix { inherit pkgs; };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  xdg.configFile = {
  };

  home = {
    packages = with pkgs; [
      ghostty
      nautilus
      pavucontrol
      wireplumber
      grim
      slurp
      wl-clipboard
      libnotify
      hypridle
      hyprlock
      hyprpaper
      cliphist
      brightnessctl
      networkmanagerapplet
      polkit_gnome

    ];

    file = {
      ".config/ghostty".source = "${common.dotfilesDir}/ghostty";
      ".config/mako/config".text = ''
        background-color=#1a1b26
        text-color=#cdd6f4
        border-color=#89b4fa
        border-radius=5
        border-size=2
        default-timeout=5000
        ignore-timeout=1
        layer=overlay
      '';
      ".config/hypr/hyprpaper.conf".text = ''
        preload = ~/Pictures/wallpaper.png
        wallpaper = ,~/Pictures/wallpaper.png
        splash = false
        ipc = off
      '';
    };
  };

  services = {
    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = [
          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 600;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };

  systemd.user.services = {
    nm-applet = {
      Unit = {
        Description = "NetworkManager Applet";
        After = [ "hyprland-session.target" ];
        PartOf = [ "hyprland-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "hyprland-session.target" ];
      };
    };

    cliphist-store = {
      Unit = {
        Description = "Clipboard history store";
        After = [ "hyprland-session.target" ];
        PartOf = [ "hyprland-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
        Restart = "always";
      };
      Install = {
        WantedBy = [ "hyprland-session.target" ];
      };
    };

    polkit-gnome = {
      Unit = {
        Description = "Polkit GNOME authentication agent";
        After = [ "hyprland-session.target" ];
        PartOf = [ "hyprland-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "hyprland-session.target" ];
      };
    };

    mako-custom = {
      Unit = {
        Description = "Mako notification daemon";
        After = [ "hyprland-session.target" ];
        PartOf = [ "hyprland-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.mako}/bin/mako";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "hyprland-session.target" ];
      };
    };

    hyprpaper = {
      Unit = {
        Description = "Hyprland wallpaper daemon";
        After = [ "hyprland-session.target" ];
        PartOf = [ "hyprland-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "hyprland-session.target" ];
      };
    };

  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    SDL_VIDEODRIVER = "wayland";
    GTK_USE_PORTAL = "1";
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "24";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };
}
