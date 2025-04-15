{ config, pkgs, ... }:

{
  home.username = "zekus";
  home.homeDirectory = "/Users/${config.home.username}";

  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    ripgrep
    tig
    delta
    extract_url
    universal-ctags
    silver-searcher
    bfs
    fzf
    tmux
    fish
    clojure
    git
  ];

  home.file = {
  };

  home.sessionVariables = {
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
