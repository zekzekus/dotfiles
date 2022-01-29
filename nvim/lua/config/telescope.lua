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
		}
})

telescope.load_extension("fzf")
