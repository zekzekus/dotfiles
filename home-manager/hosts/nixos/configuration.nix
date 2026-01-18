{
  pkgs,
  hyprland,
  common,
  ...
}: let
  hyprPkgs = hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };
  };

  time.timeZone = "Europe/Istanbul";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "tr_TR.UTF-8";
      LC_IDENTIFICATION = "tr_TR.UTF-8";
      LC_MEASUREMENT = "tr_TR.UTF-8";
      LC_MONETARY = "tr_TR.UTF-8";
      LC_NAME = "tr_TR.UTF-8";
      LC_NUMERIC = "tr_TR.UTF-8";
      LC_PAPER = "tr_TR.UTF-8";
      LC_TELEPHONE = "tr_TR.UTF-8";
      LC_TIME = "tr_TR.UTF-8";
    };
  };

  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        style = "slight";
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };
    };
    packages = with pkgs; [
      jetbrains-mono
      nerd-fonts.jetbrains-mono
      inter
    ];
  };

  console.useXkbConfig = true;

  services = {
    kanata = {
      enable = true;
      keyboards = {
        logitech = {
          devices = [
            "/dev/input/by-id/usb-Logitech_USB_Receiver-event-kbd"
          ];
          extraDefCfg = "process-unmapped-keys yes";
          config = ''
            (defsrc caps)
            (deflayer default @caps-ctrl-esc)
            (defalias caps-ctrl-esc (tap-hold 200 200 esc lctl))
          '';
        };
      };
    };
    udev.extraRules = ''
      # Rules for Oryx web flashing and live training
      KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="plugdev"
      KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"

      # Legacy rules for live training over webusb (Not needed for firmware v21+)
      SUBSYSTEM=="usb", ATTR{idVendor}=="3297", GROUP="plugdev"
      SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1969", GROUP="plugdev"
      SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="1307", GROUP="plugdev"
      SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="6060", GROUP="plugdev"

      # Wally Flashing rules for the Ergodox EZ
      ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
      ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
      KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"

      # Keymapp / Wally Flashing rules for the Moonlander and Planck EZ
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE:="0666", SYMLINK+="stm32_dfu"
      # Keymapp Flashing rules for the Voyager
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="3297", MODE:="0666", SYMLINK+="ignition_dfu"
    '';
    tailscale.enable = true;
    xserver = {
      enable = true;
      xkb = {
        layout = "tr";
        variant = "alt";
      };
    };
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    power-profiles-daemon.enable = true;
    upower.enable = true;
    printing.enable = true;
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    blueman.enable = true;
    pcscd.enable = true;
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
        };
        Policy = {
          AutoEnable = true;
        };
      };
    };
    enableAllFirmware = true;
    firmware = [pkgs.linux-firmware];
    i2c.enable = true;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      hyprPkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common.default = ["gtk"];
      hyprland.default = ["hyprland" "gtk"];
      start-hyprland.default = ["hyprland" "gtk"];
    };
  };

  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      package = hyprPkgs.hyprland;
      portalPackage = hyprPkgs.xdg-desktop-portal-hyprland;
    };
    gpu-screen-recorder.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
    };
    gamescope.enable = true;
    gamemode.enable = true;
    dconf.enable = true;
    ssh.askPassword = pkgs.lib.mkForce "${pkgs.seahorse.out}/libexec/seahorse/ssh-askpass";
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  users.groups.plugdev = {};

  users.users.${common.username} = {
    isNormalUser = true;
    description = "Zekeriya Koc";
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "i2c"
      "plugdev"
    ];
    packages = with pkgs; [
      fish
      nushell
    ];
    shell = pkgs.nushell;
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" common.username];
      extra-substituters = ["https://install.determinate.systems"];
      extra-trusted-public-keys = ["cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="];
      cores = 0;
      eval-cores = 0;
      keep-outputs = true;
      keep-derivations = true;
      auto-optimise-store = true;
      download-attempts = 3;
      fallback = true;
      http-connections = 50;
      max-substitution-jobs = 32;
      fsync-metadata = false;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  environment = {
    sessionVariables.STEAM_FORCE_DESKTOPUI_SCALING = "1.5";
    systemPackages = with pkgs; [
      vim
      git
      unzip
      gnumake
      home-manager
      ddcutil
    ];
  };

  system.stateVersion = "25.05";
}
