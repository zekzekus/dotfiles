{
  pkgs,
  config,
  common,
  ...
}: let
  kokaTreeSitter = pkgs.runCommand "tree-sitter-koka-vim-plugin" {} ''
    mkdir -p "$out/parser" "$out/queries/koka"
    cp "${pkgs.tree-sitter-grammars.tree-sitter-koka}/parser" "$out/parser/koka.so"
    cp "${pkgs.tree-sitter-grammars.tree-sitter-koka}/queries/"*.scm "$out/queries/koka/"
  '';
in {
  programs.neovim = {
    enable = true;
    withRuby = false;
    withPython3 = false;
    sideloadInitLua = true;

    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      kokaTreeSitter
    ];

    extraPackages = with pkgs; [
      # Build deps (for plugins like blink.cmp and fff.nvim)
      gcc
      gnumake
      cargo

      # Plugin runtimes
      nodejs_24
      python313
      python313Packages.pynvim

      # LSPs
      koka
      lua-language-server
      nil
      nixd
      nixfmt

      # Go
      gopls

      # Rust
      rust-analyzer

      # Haskell
      haskell-language-server

      # Ruby
      ruby-lsp

      # Python
      ty
      ruff

      # JavaScript/TypeScript
      typescript-language-server
      vscode-langservers-extracted # html, css, json, eslint
    ];
  };

  xdg.configFile."nvim" = {
    force = true;
    source = config.lib.file.mkOutOfStoreSymlink "${common.dotfilesDir}/nvim";
  };
}
