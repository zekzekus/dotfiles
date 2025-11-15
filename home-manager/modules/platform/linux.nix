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
      swaylock
      swayidle
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
    };
  };

  services = {

    swayidle = {
      enable = true;
      timeouts = [
        { timeout = 300; command = "${pkgs.swaylock}/bin/swaylock -f"; }
        { timeout = 600; command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off"; resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on"; }
      ];
    };
  };

  systemd.user.services = {
    nm-applet = {
      Unit = {
        Description = "NetworkManager Applet";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    cliphist-store = {
      Unit = {
        Description = "Clipboard history store";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
        Restart = "always";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    polkit-gnome = {
      Unit = {
        Description = "Polkit GNOME authentication agent";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    mako-custom = {
      Unit = {
        Description = "Mako notification daemon";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.mako}/bin/mako";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };

  home.sessionVariables = {
    GDK_SCALE = "1.50";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland";
  };
}
