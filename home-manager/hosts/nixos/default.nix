{pkgs, ...}: {
  imports = [
    ./hyprland-integration.nix
    ./stylix.nix
    ../../modules/programs/hyprland.nix
    ../../modules/programs/hyprland-plugins.nix
    ../../modules/programs/rofi.nix
    ../../modules/programs/hyprlock.nix
    ../../modules/programs/noctalia-shell.nix
  ];

  home.packages = with pkgs; [
    appimage-run
    (import ../../modules/packages/helium.nix {inherit pkgs;})
    showmethekey
    hyprpolkitagent
  ];

  services = {
    tailscale-systray.enable = true;
    network-manager-applet.enable = true;
    cliphist.enable = true;

    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "noctalia-shell ipc call lockScreen lock";
          before_sleep_cmd = "noctalia-shell ipc call lockScreen lock";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = [
          {
            timeout = 300;
            on-timeout = "noctalia-shell ipc call lockScreen lock";
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
