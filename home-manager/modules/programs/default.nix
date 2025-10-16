{ pkgs, common, ... }:

{
  home-manager.enable = true;
  java.enable = true;
  
  git = import ./git.nix { inherit pkgs common; };
  fish = import ./fish.nix { inherit pkgs common; };
  starship = import ./starship.nix { inherit pkgs common; };
  tmux = import ./tmux.nix { inherit pkgs common; };
}
