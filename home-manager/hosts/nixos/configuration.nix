{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos";
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };
  services.tailscale.enable = true;

  users.users.zekus = {
    isNormalUser = true;
    description = "Zekeriya Koc";
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
    ];
    packages = with pkgs; [
      fish
      nushell
    ];
    shell = pkgs.nushell;
  };

  environment.sessionVariables = {
    STEAM_FORCE_DESKTOPUI_SCALING = "1.5";
  };

  system.stateVersion = "25.05";
}
