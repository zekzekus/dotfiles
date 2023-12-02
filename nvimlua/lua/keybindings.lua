local nest = prequire("nest")

local files = {
  name = "Files",
  prefix = "<leader>f",
  { "f", [[<cmd>Telescope find_files theme=dropdown previewer=false<cr>]] },
  { "j", [[<cmd>Telescope find_files theme=dropdown cwd=~/.cache/junkfile prompt_title=Junkfiles<cr>]] },
  { "o", [[<cmd>Telescope oldfiles theme=dropdown<cr>]] },
  { "g", [[<cmd>Telescope live_grep theme=dropdown<cr>]] },
  { "h", [[<cmd>Telescope help_tags theme=dropdown<cr>]] },
  { "s", [[<cmd>w<cr>]] },
  { "W", [[<cmd>%s/\s\+$//<cr>:let @/=''<cr>]] },
  { "t", [[<cmd>Neotree left toggle<cr>]] },
  { "T", [[<cmd>TagbarToggle<cr>]] },
}

-- vim.keymap.set('n', '<leader>bo', builtin.oldfiles, {})
-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
--
local floatings = {
  name = "Floating",
  prefix = "<leader>o",
  { "p", [[<cmd>Neotree float toggle<cr>]] },
}

local buffers = {
  name = "Buffers",
  prefix = "<leader>",
  { "bb",     [[<cmd>Telescope buffers theme=dropdown previewer=false<cr>]] },
  { "bd",     [[<cmd>bdelete<cr>]] },
  { "<tab>",  [[<cmd>b#<cr>]] },
  { "`",      [[<cmd>b#<cr>]] },
  { "Q",      [[<cmd>SmartClose<cr>]] },
  { "=",      [[<cmd>lua vim.lsp.buf.format({ async = false, timeout_ms = 4000 })<CR>]] },
}

local search = {
  name = "Search",
  prefix = "<leader>",
  { "/", options = { silent = false }, [[:Zgrep<space>]] },
  { "*",  [[:Zgrep<space><c-r><c-w><cr>]] },
  { "ss", [[<cmd>Telescope ctags_outline outline<cr>]] },
  { "sl", [[<cmd>Telescope current_buffer_fuzzy_find previewer=false<cr>]] },
}

local others = {
  name = "Others",
  prefix = "<leader>",
  { "<space>", [[<cmd>Telescope find_files theme=dropdown previewer=false<cr>]] },
  { "qq",      [[<cmd>SmartClose<cr>]] },
  { "V",       'V`]' },
}

local misc = {
  name = "Misc.",
  { "<C-u>",    [[<C-u>zz]] },
  { "<C-d>",    [[<C-d>zz]] },
  { "<C-f>",    [[<C-f>zz]] },
  { "<C-b>",    [[<C-b>zz]] },
  { "<C-o>",    [[<C-o>zz]] },
  { "<C-i>",    [[<C-i>zz]] },
  { "n",    [[nzzzv]] },
  { "N",    [[Nzzzv]] },
  { "<bs>", [[<cmd>nohlsearch<cr>]] },
  { "cn",   [[*``cgn]] },
  { "cN",   [[*``cgN]] },

  -- greatest remap ever
  { mode = "x", { "<leader>p", [["_dP]] } },

  -- Move to errors and warnings
  { "gne", [[<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })<cr>]] },
  { "gpe", [[<cmd>lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })<cr>]] },
  { "gnw", [[<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })<cr>]] },
  { "gpw", [[<cmd>lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })<cr>]] },
  -- { "cq",   [[:call zek#setup_cr()<CR>*``qz]] },
  -- { "cQ",   [[:call zek#setup_cr()<CR>#``qz]] },
  { mode = "v", options = { expr = true },     { "cn", [[g:mc . "``cgn"]] } },
  { mode = "v", options = { expr = true },     { "cN", [[g:mc . "``cgN"]] } },
  -- { mode = "v", { "J", [[:m '>+1<CR>gv=gv]] } },
  -- { mode = "v", { "K", [[:m '<-2<CR>gv=gv]] } },
  -- { mode = "v", options = { expr = true },     { "cq", [[:\<C-u>call zek#setup_cr()\<CR>" . "gv" . g:mc . "``qz]] } },
  -- { mode = "v", options = { expr = true },     { "cQ", [[:\<C-u>call zek#setup_cr()\<CR>" . "gv" . substitute(g:mc, '/', '?', 'g') . "``qz]] } },
  { mode = "c", options = { silent = false },  { "<c-n>", [[<down>]] } },
  { mode = "c", options = { silent = false },  { "<c-p>", [[<up>]] } },
}

nest.applyKeymaps({
    files,
    floatings,
    buffers,
    search,
    others,
    misc,
})
