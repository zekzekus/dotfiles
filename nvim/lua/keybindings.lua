local vim = vim

local function map_group(group)
  local prefix = group.prefix or ''

  for _, mapping in ipairs(group) do
    vim.keymap.set(
      mapping.mode or 'n',
      prefix .. mapping[1],
      mapping[2],
      vim.tbl_extend('force', { silent = true }, mapping.options or {})
    )
  end
end

local files = {
  name = 'Files',
  prefix = '<leader>f',
  { 'f', [[<cmd>Telescope find_files theme=dropdown previewer=false<cr>]] },
  { 'j', [[<cmd>Telescope find_files theme=dropdown cwd=~/.cache/junkfile prompt_title=Junkfiles<cr>]] },
  { 's', [[<cmd>w<cr>]] },
  { 'W', [[<cmd>%s/\s\+$//<cr>:let @/=''<cr>]] },
  { 't', [[<cmd>Neotree left toggle<cr>]] },
  { 'T', [[<cmd>TagbarToggle<cr>]] },
}

local git = {
  name = 'Git',
  prefix = '<leader>g',
  { 'g', [[<cmd>Neogit<cr>]]}
}

local jj = {
  name = 'Jujutsu',
  prefix = '<leader>j',
  { 'j', [[<cmd>Neojj<cr>]] },
}

local floatings = {
  name = 'Floating',
  prefix = '<leader>o',
  { 'p', [[<cmd>Neotree float toggle<cr>]] },
}

local buffers = {
  name = 'Buffers',
  prefix = '<leader>',
  { 'bb',     [[<cmd>Telescope buffers theme=dropdown previewer=false<cr>]] },
  { 'bd',     [[<cmd>bdelete<cr>]] },
  { '<tab>', [[<cmd>b#<cr>]] },
  { '`',     [[<cmd>b#<cr>]] },
}

local search = {
  name = 'Search',
  prefix = '<leader>',
  { '/', options = { silent = false }, [[:Zgrep<space>]] },
  { '*',  [[:Zgrep<space><c-r><c-w><cr>]] },
  { 'ss', [[<cmd>Telescope ctags_outline outline<cr>]] },
  { 'sl', [[<cmd>Telescope current_buffer_fuzzy_find previewer=false<cr>]] },
}

local others = {
  name = 'Others',
  prefix = '<leader>',
  { '<space>', [[<cmd>Telescope find_files theme=dropdown previewer=false<cr>]] },
  { 'qq',      [[<cmd>SmartClose<cr>]] },
  { 'V',       'V`]' },
}

local misc = {
  name = 'Misc.',
  { 'ff', [[<cmd>Telescope find_files theme=dropdown previewer=false<cr>]] },
  { 'n',    [[nzzzv]] },
  { 'N',    [[Nzzzv]] },
  { '<bs>', [[<cmd>nohlsearch<cr>]] },
  { 'cn',   [[*``cgn]] },
  { 'cN',   [[*``cgN]] },
  { 'cq',   [[:call zek#setup_cr()<CR>*``qz]] },
  { 'cQ',   [[:call zek#setup_cr()<CR>#``qz]] },
  { 'cn',   [[g:mc . '``cgn']], mode = 'v', options = { expr = true } },
  { 'cN',   [[g:mc . '``cgN']], mode = 'v', options = { expr = true } },
  { 'cq',   [[:\<C-u>call zek#setup_cr()\<CR>' . 'gv' . g:mc . '``qz]], mode = 'v', options = { expr = true } },
  { 'cQ',   [[:\<C-u>call zek#setup_cr()\<CR>' . 'gv' . substitute(g:mc, '/', '?', 'g') . '``qz]], mode = 'v', options = { expr = true } },
  { '<c-n>', [[<down>]], mode = 'c', options = { silent = false } },
  { '<c-p>', [[<up>]], mode = 'c', options = { silent = false } },
}

for _, group in ipairs({
  files,
  git,
  jj,
  floatings,
  buffers,
  search,
  others,
  misc,
}) do
  map_group(group)
end
