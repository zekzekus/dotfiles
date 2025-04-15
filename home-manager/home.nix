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
    # packages waiting: neovim
    # files waiting: neovim, tmux, fish, git
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
    starship

    clojure
  ];

  home.file = {
    ".ctags".source = "${dotfilesDir}/ctags/ctags";
    ".hammerspoon".source = "${dotfilesDir}/macosx/hammerspoon";
    ".tmuxinator".source = "${dotfilesDir}/tmuxinator";

    ".config/ghostty".source = "${dotfilesDir}/ghostty";
    ".config/starship.toml".source = "${dotfilesDir}/starship/starship.toml";

    "bin/gg".source = "${dotfilesDir}/scripts/tmuxproject.sh";
    "bin/gk".source = "${dotfilesDir}/scripts/tmuxproject.sh";
    "bin/gp".source = "${dotfilesDir}/scripts/tmuxproject.sh";
  };

  home.sessionVariables = {
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
