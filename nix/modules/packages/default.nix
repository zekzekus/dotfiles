{
  hey-cli,
  basecamp-cli,
  pkgs,
  ...
}: {
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
    hunk

    # development tools
    devenv
    sqlit-tui

    (callPackage ./amp.nix {})

    nodejs_24
    pnpm

    # terminal image viewers
    chafa
    viu

    # LLM
    claude-code
    github-copilot-cli
    # ollama-cpu
    # Temporarily disabled: opencode 2.2.5 node_modules fails hash verification.
    # Re-enable after a verified upstream packaging fix; do not override the hash.
    # opencode

    # secrets (sops-nix workflow; see docs/sops-setup.md)
    sops
    age

    # misc
    mosh

    # productivity
    basalt
    gws
    hey-cli.packages.${pkgs.stdenv.hostPlatform.system}.default
    basecamp-cli.packages.${pkgs.stdenv.hostPlatform.system}.default

    # common lisp
    sbcl
  ];
}
