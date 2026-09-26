# Linux-only graphical apps and user services. Loaded by the `graphical` profile
# only on Linux hosts. Not headless-safe by design.
{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./media.nix
    ./zed-editor.nix
  ];

  programs = {
    chromium.enable = true;

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-pipewire-audio-capture # PipeWire audio capture
        droidcam-obs
      ];
    };
  };

  home.packages = with pkgs;
    [
      appimage-run
      showmethekey
      droidcam
      cameractrls-gtk4
      emacs-pgtk
    ]
    ++ lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [
      (callPackage ../../../modules/packages/amp-acp.nix {})
      (callPackage ../../../modules/packages/buzz.nix {})
      (callPackage ../../../modules/packages/helium.nix {})
    ];

  # 1Password GUI autostart (moved out of the shared ssh module so headless
  # hosts don't pull in the GUI package).
  systemd.user.services.onepassword = {
    Unit = {
      Description = "1Password";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs._1password-gui}/bin/1password --silent";
      Restart = "on-failure";
      RestartSec = 1;
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
