local nest = prequire("nest")

local files = {
  name = "Files",
  prefix = "<leader>f",
  { "f", [[<cmd>Telescope find_files theme=dropdown previewer=false<cr>]] },
  { "j", [[<cmd>Telescope find_files theme=dropdown cwd=~/.cache/junkfile prompt_title=Junkfiles<cr>]] },
  { "s", [[<cmd>w<cr>]] },
  { "W", [[<cmd>%s/\s\+$//<cr>:let @/=''<cr>]] },
  { "t", [[<cmd>Neotree toggle<cr>]] },
  { "T", [[<cmd>TagbarToggle<cr>]] },
}

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
  { "<tab>", [[<cmd>b#<cr>]] },
  { "`",     [[<cmd>b#<cr>]] },
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
  { "n",    [[nzzzv]] },
  { "N",    [[Nzzzv]] },
  { "<bs>", [[<cmd>nohlsearch<cr>]] },
  { "cn",   [[*``cgn]] },
  { "cN",   [[*``cgN]] },
  { "cq",   [[:call zek#setup_cr()<CR>*``qz]] },
  { "cQ",   [[:call zek#setup_cr()<CR>#``qz]] },
  { mode = "v", options = { expr = true },     { "cn", [[g:mc . "``cgn"]] } },
  { mode = "v", options = { expr = true },     { "cN", [[g:mc . "``cgN"]] } },
  { mode = "v", options = { expr = true },     { "cq", [[:\<C-u>call zek#setup_cr()\<CR>" . "gv" . g:mc . "``qz]] } },
  { mode = "v", options = { expr = true },     { "cQ", [[:\<C-u>call zek#setup_cr()\<CR>" . "gv" . substitute(g:mc, '/', '?', 'g') . "``qz]] } },
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
