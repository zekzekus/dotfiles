{
  pkgs,
  common,
  ...
}: {
  imports = [./hardware-configuration.nix];

  # UEFI example. Retain the installer's boot loader for BIOS, encryption,
  # special storage layouts, or hardware requiring additional drivers.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "example-nixos";
  time.timeZone = "Europe/Istanbul";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.${common.username} = {
    isNormalUser = true;
    description = common.userFullName;
    extraGroups = ["wheel" "networkmanager"];
    shell = pkgs.nushell;
    # Keep the installer-created password. Never put plaintext passwords here.
  };
  environment.systemPackages = with pkgs; [git gnumake];
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Set this to the installed system's original release; do not bump on upgrades.
  system.stateVersion = "26.05";
}
