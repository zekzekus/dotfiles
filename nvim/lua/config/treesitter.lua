local tsitter = prequire('nvim-treesitter.configs')

if not tsitter then
  return
end

tsitter.setup {
  ensure_installed = 'all',
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
  },
}
