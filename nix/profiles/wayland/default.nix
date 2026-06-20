# Wayland desktop profile: the home-manager side of the Hyprland/Niri/Noctalia
# session. Opt-in via `profiles = ["wayland"]` (normally together with
# "graphical"). Reusable across any Wayland host; not NixOS-specific.
#
# Requires these HM modules + specialArgs (provided by the registry entry in
# flake.nix): stylix, hyprland HM module, noctalia HM module, and the
# `hyprland`/`hyprland-plugins` flake inputs.
{
  pkgs,
  common,
  ...
}: {
  systemd.user.services = {
    noctalia.Unit.ConditionEnvironment = "!XDG_CURRENT_DESKTOP=COSMIC";
    hypridle.Unit.ConditionEnvironment = pkgs.lib.mkForce ["WAYLAND_DISPLAY" "!XDG_CURRENT_DESKTOP=COSMIC"];
    tailscale-systray = {
      Unit = {
        After = ["noctalia.service"];
        Requires = ["noctalia.service"];
        PartOf = ["noctalia.service"];
        ConditionEnvironment = "!XDG_CURRENT_DESKTOP=COSMIC";
      };
      Service = {
        ExecStartPre = ''${pkgs.bash}/bin/bash -c 'for _ in $(${pkgs.coreutils}/bin/seq 1 50); do ${pkgs.systemd}/bin/busctl --user --list --acquired | ${pkgs.gnugrep}/bin/grep -q org.kde.StatusNotifierWatcher && exit 0; ${pkgs.coreutils}/bin/sleep 0.2; done' '';
        Restart = "on-failure";
        RestartSec = 2;
      };
    };
  };

  imports = [
    ./modules/wayland.nix
    ./stylix.nix
    ./modules/niri.nix
    ./modules/hyprland.nix
    # ./modules/hyprland-plugins.nix  # disabled: hyprexpo was removed from hyprwm/hyprland-plugins (unmaintained)
    ./modules/rofi.nix
    ./modules/hyprlock.nix
    ./modules/noctalia-shell.nix
    ./modules/qmd.nix
  ];

  home.packages = [pkgs.hyprpolkitagent];

  services = {
    tailscale-systray.enable = true;
    network-manager-applet.enable = true;
    cliphist.enable = true;

    udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "auto";
    };

    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "noctalia msg session lock";
          before_sleep_cmd = "noctalia msg session lock";
          after_sleep_cmd = "${common.dotfilesDir}/scripts/dpms-on";
        };
        listener = [
          {
            timeout = 300;
            on-timeout = "noctalia msg session lock";
          }
          {
            timeout = 600;
            on-timeout = "${common.dotfilesDir}/scripts/dpms-off";
            on-resume = "${common.dotfilesDir}/scripts/dpms-on";
          }
        ];
      };
    };
  };

  systemd.user.services.hyprpolkitagent = {
    Unit = {
      Description = "Hyprland Polkit Authentication Agent";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
      Restart = "on-failure";
      RestartSec = 1;
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
