-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = true
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/zekus/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/zekus/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/zekus/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/zekus/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/zekus/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["auto-pairs"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/auto-pairs"
  },
  ["cmp-nvim-lsp"] = {
    after = { "nvim-lspconfig" },
    after_files = { "/Users/zekus/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lsp/after/plugin/cmp_nvim_lsp.lua" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lsp"
  },
  conjure = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/opt/conjure"
  },
  falcon = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/falcon"
  },
  fzf = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/fzf"
  },
  ["fzf.vim"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/fzf.vim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20config.gitsigns\frequire\0" },
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/gitsigns.nvim"
  },
  ["junkfile.vim"] = {
    commands = { "JunkfileOpen" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/opt/junkfile.vim"
  },
  ["linediff.vim"] = {
    commands = { "Linediff" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/opt/linediff.vim"
  },
  menguless = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/menguless"
  },
  neogit = {
    config = { "\27LJ\2\n-\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\18config.neogit\frequire\0" },
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/neogit"
  },
  ["nest.nvim"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/nest.nvim"
  },
  ["nord-vim"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/nord-vim"
  },
  ["nvim-cmp"] = {
    after = { "cmp-nvim-lsp" },
    loaded = true,
    only_config = true
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21config.lspconfig\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/opt/nvim-lspconfig"
  },
  ["nvim-lspinstall"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/nvim-lspinstall"
  },
  ["nvim-tree.lua"] = {
    config = { "\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20config.nvimtree\frequire\0" },
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  ["parinfer-rust"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/opt/parinfer-rust"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  tagbar = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/tagbar"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/vim-commentary"
  },
  ["vim-dadbod"] = {
    commands = { "DB" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/opt/vim-dadbod"
  },
  ["vim-dispatch"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/vim-dispatch"
  },
  ["vim-dispatch-neovim"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/vim-dispatch-neovim"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/vim-fugitive"
  },
  ["vim-jack-in"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/opt/vim-jack-in"
  },
  ["vim-jdaddy"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/opt/vim-jdaddy"
  },
  ["vim-lastplace"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/vim-lastplace"
  },
  ["vim-polyglot"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/vim-polyglot"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/vim-repeat"
  },
  ["vim-sleuth"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/vim-sleuth"
  },
  ["vim-smartclose"] = {
    commands = { "SmartClose" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/opt/vim-smartclose"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/vim-surround"
  },
  ["vim-tmux-navigator"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/vim-tmux-navigator"
  },
  ["vim-unimpaired"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/vim-unimpaired"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
try_loadstring("\27LJ\2\n*\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\15config.cmp\frequire\0", "config", "nvim-cmp")
time([[Config for nvim-cmp]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20config.gitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: nvim-tree.lua
time([[Config for nvim-tree.lua]], true)
try_loadstring("\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20config.nvimtree\frequire\0", "config", "nvim-tree.lua")
time([[Config for nvim-tree.lua]], false)
-- Config for: neogit
time([[Config for neogit]], true)
try_loadstring("\27LJ\2\n-\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\18config.neogit\frequire\0", "config", "neogit")
time([[Config for neogit]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd cmp-nvim-lsp ]]
vim.cmd [[ packadd nvim-lspconfig ]]

-- Config for: nvim-lspconfig
try_loadstring("\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21config.lspconfig\frequire\0", "config", "nvim-lspconfig")

time([[Sequenced loading]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file JunkfileOpen lua require("packer.load")({'junkfile.vim'}, { cmd = "JunkfileOpen", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file DB lua require("packer.load")({'vim-dadbod'}, { cmd = "DB", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Linediff lua require("packer.load")({'linediff.vim'}, { cmd = "Linediff", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file SmartClose lua require("packer.load")({'vim-smartclose'}, { cmd = "SmartClose", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType json ++once lua require("packer.load")({'vim-jdaddy'}, { ft = "json" }, _G.packer_plugins)]]
vim.cmd [[au FileType clojure ++once lua require("packer.load")({'vim-jack-in', 'conjure', 'parinfer-rust'}, { ft = "clojure" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
