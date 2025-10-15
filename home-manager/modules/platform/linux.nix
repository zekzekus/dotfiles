{ pkgs, ... }:

{
  # Linux-specific home-manager configuration

  # Programs that are Linux-only or have Linux-specific configuration
  programs = {
    # bash is disabled on Linux (fish is primary shell)
    bash.enable = false;
  };

  # Linux-specific packages
  home.packages = with pkgs; [
    # Add Linux-specific packages here if needed
  ];

  # Linux-specific services
  services = {
    # systemd user services can be defined here
  };

  # Linux-specific environment
  home.sessionVariables = {
    # Linux-specific environment variables
  };
}