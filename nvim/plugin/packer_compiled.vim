" Automatically generated packer.nvim plugin loader code

if !has('nvim-0.5')
  echohl WarningMsg
  echom "Invalid Neovim version for packer.nvim!"
  echohl None
  finish
endif

packadd packer.nvim

try

lua << END
local package_path_str = "/Users/zekus/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/zekus/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/zekus/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/zekus/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/zekus/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    print('Error running ' .. component .. ' for ' .. name)
    error(result)
  end
  return result
end

_G.packer_plugins = {
  ["auto-pairs"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/auto-pairs"
  },
  ["completion-buffers"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/completion-buffers"
  },
  ["completion-nvim"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/completion-nvim"
  },
  ["completion-tags"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/completion-tags"
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
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/gitsigns.nvim"
  },
  ["goyo.vim"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/goyo.vim"
  },
  ["junkfile.vim"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/junkfile.vim"
  },
  ["linediff.vim"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/linediff.vim"
  },
  neogit = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/neogit"
  },
  ["nord-vim"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/nord-vim"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-tree.lua"] = {
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
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/popup.nvim"
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
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/vim-dadbod"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/vim-fugitive"
  },
  ["vim-jdaddy"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/vim-jdaddy"
  },
  ["vim-lastplace"] = {
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/vim-lastplace"
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
    loaded = true,
    path = "/Users/zekus/.local/share/nvim/site/pack/packer/start/vim-smartclose"
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

END

catch
  echohl ErrorMsg
  echom "Error in packer_compiled: " .. v:exception
  echom "Please check your config for correctness"
  echohl None
endtry
