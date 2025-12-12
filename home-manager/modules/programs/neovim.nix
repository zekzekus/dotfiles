{ pkgs, common, ... }:

{
  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
    ];

    extraPackages = with pkgs; [
      # Build deps (for plugins like blink.cmp, fff.nvim, telescope-fzf-native)
      gcc
      gnumake
      cargo

      # Plugin runtimes
      nodejs_24
      python313
      python313Packages.pynvim

      # LSPs
      lua-language-server
      nil
      nixd
      nixfmt

      # Clojure
      clojure-lsp

      # Go
      gopls

      # Rust
      rust-analyzer

      # Haskell
      haskell-language-server

      # Ruby
      ruby-lsp

      # Python
      pyright

      # JavaScript/TypeScript
      typescript-language-server
      vscode-langservers-extracted  # html, css, json, eslint
    ];
  };

  home.file.".config/nvim".source = "${common.dotfilesDir}/nvim";
}
