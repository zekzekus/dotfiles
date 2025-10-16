{ pkgs, common, ... }:

{
  programs = {
    bash.enable = true;
    
    aerospace = import ../programs/aerospace.nix { inherit pkgs common; };
    sketchybar = import ../programs/sketchybar.nix { inherit pkgs common; };
  };

  home = {
    packages = with pkgs; [
    ];
  };

  services = {
    jankyborders = import ../services/jankyborders.nix { inherit pkgs common; };
  };

  home.sessionVariables = {
  };
}
