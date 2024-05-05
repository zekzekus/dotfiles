-- local builtin = require('telescope.builtin')

-- vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
-- vim.keymap.set('n', '<leader>bo', builtin.oldfiles, {})
-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

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
  pickers = {
    buffers = {
      ignore_current_buffer = false,
      -- sort_lastused = true,
      sort_mru = true,
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

-- telescope.load_extension("fzf")
telescope.load_extension("ctags_outline")
