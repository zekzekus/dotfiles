{ pkgs, ... }:

{
  home-manager.enable = true;
  java.enable = true;
  
  git = import ./git.nix { inherit pkgs; };
  fish = import ./fish.nix { inherit pkgs; };
  starship = import ./starship.nix { inherit pkgs; };
  tmux = import ./tmux.nix { inherit pkgs; };
}
