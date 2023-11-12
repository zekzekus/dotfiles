require'nvim-treesitter.configs'.setup {
	-- A list of parser names, or "all"
	ensure_installed = { "c", "lua", "python", "vim", "vimdoc", "query" },

	-- Install parsers synchronously (only applied to `ensure_installed`)

  	highlight = {
    	enable = true,
        additional_vim_regex_highlighting = false,
  	},
}
