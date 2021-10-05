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
			extensions = {
				fzf = {
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart",
				}
			}
		}
})

telescope.load_extension("fzf")
