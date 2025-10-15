{ pkgs, ... }:

{
  programs = {
    bash.enable = true;
    
    aerospace = import ../programs/aerospace.nix { inherit pkgs; };
    sketchybar = import ../programs/sketchybar.nix { inherit pkgs; };
  };

  home = {
    packages = with pkgs; [
    ];
  };

  services = {
    jankyborders = import ../services/jankyborders.nix { inherit pkgs; };
  };

  home.sessionVariables = {
  };
}
