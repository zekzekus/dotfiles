{pkgs, ...}: {
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

    (callPackage ./amp.nix {})

    nodejs_24
    pnpm

    # terminal image viewers
    chafa
    viu

    # apps
    localsend

    # LLM
    claude-code
    github-copilot-cli
    # ollama-cpu
    opencode

    # misc
    mosh

    # productivity
    basalt

    # common lisp
    sbcl
  ];
}
