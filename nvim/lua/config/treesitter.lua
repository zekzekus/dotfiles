vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function(args)
    -- Neovim's native Tree-sitter highlighter is used by nvim-treesitter 0.10+.
    -- pcall keeps filetypes without an installed parser on the normal Vim
    -- highlighting path.
    pcall(vim.treesitter.start, args.buf)
  end,
})
