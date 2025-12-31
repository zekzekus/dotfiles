{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # terminal tools
    bfs
    gdu
    universal-ctags
    wget
    tree

    # version control
    git-extras
    tig
    lazyjj

    # development tools
    devenv

    # becuase i want amp to be at the edge
    nodejs_24
    pnpm

    # terminal image viewers
    chafa
    viu

    # apps
    localsend

    # LLM
    ollama-cpu
  ];
}
