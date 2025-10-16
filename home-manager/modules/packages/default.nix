{ pkgs, lib, ... }:

with pkgs; [
  # editors
  neovim
  helix
  # emacs

  # terminal tools
  bfs
  fd
  fzf
  ripgrep
  silver-searcher
  universal-ctags
  wget

  # version control
  gh
  git
  git-extras
  mercurial
  jujutsu
  tig

  # language runtimes, compilers, interpreters, CLIs
  babashka
  cargo
  clojure
  deno
  go
  nodejs_24
  pnpm
  python313
  python313Packages.pip
  python313Packages.pynvim
  ruby_3_4
  uv

  # development tools
  amp-cli
  # claude-code
  cmake
  devenv
  tree-sitter

  # language servers
  lua-language-server
  nil
  nixd
]
++ lib.optionals stdenv.isDarwin [
  glibtool
]
