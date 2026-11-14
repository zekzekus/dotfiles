{
  pkgs,
  config,
  common,
  ...
}: {
  programs.neovim = {
    enable = true;
    withRuby = false;
    withPython3 = false;
    sideloadInitLua = true;

    # Neovim bundles c, lua, markdown, query, vim and vimdoc parsers; other
    # filetypes fall back to regex syntax highlighting.
    plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (p: [
        p.bash
        p.clojure
        p.diff
        p.fish
        p.git_config
        p.git_rebase
        p.gitcommit
        p.gitignore
        p.jjdescription
        p.json
        p.kdl
        p.make
        p.nix
        p.nu
        p.python
        p.toml
        p.yaml
      ]))
    ];
  };

  xdg.configFile."nvim" = {
    force = true;
    source = config.lib.file.mkOutOfStoreSymlink "${common.dotfilesDir}/nvim";
  };
}
