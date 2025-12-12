{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # terminal tools
    bfs
    gdu
    silver-searcher
    universal-ctags
    wget
    tree

    # version control
    git-extras
    tig

    # development tools
    devenv

    # becuase i want amp to be at the edge
    nodejs_24
    pnpm

    # terminal image viewers
    chafa
    viu
  ];
}
