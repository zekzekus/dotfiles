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
    # Noctalia is the StatusNotifierWatcher/host. Make it the *sole* owner of
    # the Tailscale tray client: while noctalia is up, keep the tray up
    # (Upholds); see tailscale-systray below for the matching BindsTo/After.
    # This is what guarantees a single tray icon — graphical-session.target no
    # longer pulls in the tray independently.
    noctalia.Unit = {
      ConditionEnvironment = "!XDG_CURRENT_DESKTOP=COSMIC";
      Upholds = ["tailscale-systray.service"];
    };
    hypridle.Unit.ConditionEnvironment = pkgs.lib.mkForce ["WAYLAND_DISPLAY" "!XDG_CURRENT_DESKTOP=COSMIC"];

    # The duplicated tray icon came from noctalia restarting *itself* (its
    # service has Restart=on-failure, common during v5 session startup): PartOf
    # only follows explicit `systemctl restart`, not systemd's own crash
    # auto-restart, so the old tray client survived the watcher restart and
    # re-registered alongside a fresh one.
    #
    # Couple the tray strictly to the watcher instead:
    #   - BindsTo + After noctalia.service: the tray stops whenever noctalia
    #     goes inactive/failed (incl. the auto-restart window), so no stale
    #     registration lingers.
    #   - noctalia Upholds it (above): it is brought back once noctalia is
    #     active again — exactly one fresh instance per watcher (re)start.
    #   - ExecStartPre gates on the StatusNotifierWatcher D-Bus name actually
    #     being acquired (noctalia.service "active" != bar ready), failing if it
    #     never shows so we don't register into the void.
    # Upholds is the single supervisor, so the upstream WantedBy/Requires/PartOf
    # and the redundant Restart=on-failure are all dropped.
    tailscale-systray = {
      Unit = {
        After = pkgs.lib.mkForce ["noctalia.service"];
        BindsTo = ["noctalia.service"];
        Requires = pkgs.lib.mkForce [];
        PartOf = pkgs.lib.mkForce [];
        ConditionEnvironment = "!XDG_CURRENT_DESKTOP=COSMIC";
      };
      Install.WantedBy = pkgs.lib.mkForce [];
      Service = {
        ExecStartPre = ''${pkgs.bash}/bin/bash -c 'for _ in $(${pkgs.coreutils}/bin/seq 1 50); do ${pkgs.systemd}/bin/busctl --user --list --acquired | ${pkgs.gnugrep}/bin/grep -q org.kde.StatusNotifierWatcher && exit 0; ${pkgs.coreutils}/bin/sleep 0.2; done; exit 1' '';
        Restart = pkgs.lib.mkForce "no";
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
