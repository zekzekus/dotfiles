{ pkgs, ... }:

{
  imports = [
    ../../home.nix
    ../../modules/platform/darwin.nix
  ];

  # Host-specific overrides can go here
  # For example, you might want different settings for work vs personal Macs
}