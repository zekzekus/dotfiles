{
  pkgs,
  common,
  ...
}: {
  imports = [
    ./modules/wayland.nix
    ./stylix.nix
    ./modules/niri.nix
    ./modules/hyprland.nix
    # ./modules/hyprland-plugins.nix
    ./modules/media.nix
    ./modules/rofi.nix
    ./modules/hyprlock.nix
    ./modules/noctalia-shell.nix
  ];

  home.packages = with pkgs; [
    appimage-run
    (import ../../modules/packages/helium.nix {inherit pkgs;})
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
          after_sleep_cmd = "${common.dotfilesDir}/scripts/dpms-on";
        };
        listener = [
          {
            timeout = 300;
            on-timeout = "noctalia-shell ipc call lockScreen lock";
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
