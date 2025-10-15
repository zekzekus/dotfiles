{ pkgs, ... }:

{
  # macOS-specific home-manager configuration

  # Programs that are macOS-only or have macOS-specific configuration
  programs = {
    # bash is enabled on macOS
    bash.enable = true;
    
    # macOS window manager
    aerospace = import ../programs/aerospace.nix { inherit pkgs; };
    
    # macOS status bar
    sketchybar = import ../programs/sketchybar.nix { inherit pkgs; };
  };

  # macOS-specific packages
  home.packages = with pkgs; [
    # Add macOS-specific packages here
    # Note: jankyborders is configured as a service above
  ];

  # macOS-specific services
  services = {
    # macOS window border tool
    jankyborders = import ../services/jankyborders.nix { inherit pkgs; };
    
    # launchd services can be defined here
  };

  # macOS-specific environment
  home.sessionVariables = {
    # macOS-specific environment variables
  };
}