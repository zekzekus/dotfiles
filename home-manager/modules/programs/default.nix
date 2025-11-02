{ pkgs, common, ... }:

{
  home-manager.enable = true;
  java.enable = true;
  nushell.enable = true;
  
  git = import ./git.nix { inherit pkgs common; };
  delta = import ./delta.nix { inherit pkgs common; };
  difftastic = import ./difftastic.nix { inherit pkgs common; };
  firefox = import ./firefox.nix { inherit pkgs common; };
  fish = import ./fish.nix { inherit pkgs common; };
  starship = import ./starship.nix { inherit pkgs common; };
  tmux = import ./tmux.nix { inherit pkgs common; };
  zoxide = import ./zoxide.nix { inherit pkgs common; };
  nix-your-shell = import ./nix-your-shell.nix { inherit pkgs common; };
  zed-editor = import ./zed-editor.nix { inherit pkgs common; };

}
