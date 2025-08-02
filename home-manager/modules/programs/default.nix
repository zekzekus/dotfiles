{ pkgs, ... }:

{
  home-manager.enable = true;
  bash.enable = true;
  java.enable = true;
  
  git = import ./git.nix { };
  fish = import ./fish.nix { inherit pkgs; };
  starship = import ./starship.nix { };
  # tmux = import ./tmux.nix { inherit pkgs; };
  aerospace = import ./aerospace.nix { };
  sketchybar = import ./sketchybar.nix { };
}
