local telescope = prequire("telescope")

if not telescope then
        return
end

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
      }
    },
  },
  extensions = {
    ctags_outline = {
      ft_opt = {
        javascript = '--javascript-kinds=mf',
      }
    }
  }
})

telescope.load_extension("fzf")
telescope.load_extension("ctags_outline")
