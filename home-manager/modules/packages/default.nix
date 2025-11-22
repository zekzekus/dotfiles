{ pkgs, ... }:

with pkgs; [
  # editors
  neovim

  # terminal tools
  bfs
  silver-searcher
  universal-ctags
  wget
  tree

  # version control
  git-extras
  tig

  # language runtimes, compilers, interpreters, CLIs
  babashka
  cargo
  clojure
  deno
  gcc
  go
  nodejs_24
  pnpm
  python313
  python313Packages.pip
  python313Packages.pynvim
  ruby_3_4
  uv

  # development tools
  # claude-code
  chafa
  cmake
  devenv
  tree-sitter
  viu

  # language servers
  lua-language-server
  nil
  nixd

]
