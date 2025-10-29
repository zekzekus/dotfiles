{ pkgs, ... }:

{
  imports = [
    ../../home.nix
    ../../modules/platform/linux.nix
  ];

  # Host-specific overrides can go here
}
