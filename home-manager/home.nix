{ config, pkgs, ... }:

let
  username = "zekus";
  homeDir = "/Users/${username}";
  dotfilesDir = "${homeDir}/devel/tools/dotfiles";
in
{
  home.username = "${username}";
  home.homeDirectory = "${homeDir}";

  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    ripgrep
    fzf
    bfs
    universal-ctags
    silver-searcher

    git
    tig
    delta

    tmux
    extract_url

    fish
    clojure
  ];

  home.file = {
    ".ctags".source = "${dotfilesDir}/ctags/ctags";
    "${homeDir}/bin/gg".source = "${dotfilesDir}/scripts/tmuxproject.sh";
    "${homeDir}/bin/gk".source = "${dotfilesDir}/scripts/tmuxproject.sh";
    "${homeDir}/bin/gp".source = "${dotfilesDir}/scripts/tmuxproject.sh";
  };

  home.sessionVariables = {
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
