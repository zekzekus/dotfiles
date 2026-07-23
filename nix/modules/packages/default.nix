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
    sqlit-tui

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

    # secrets (sops-nix workflow; see docs/sops-setup.md)
    sops
    age

    # misc
    mosh

    # productivity
    basalt

    # common lisp
    sbcl
  ];
}
