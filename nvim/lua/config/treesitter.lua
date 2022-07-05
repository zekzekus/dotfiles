local tsitter = prequire("nvim-treesitter.configs")

if not tsitter then
  return
end

tsitter.setup {
  ensure_installed = "all",
  ignore_install = { "phpdoc", },
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
