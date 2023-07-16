local neotree = prequire('neo-tree')

if not neotree then
  return
end

neotree.setup({
  close_if_last_window = false,
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = true,
  default_component_configs = {
    indent = {
      indent_size = 2,
      padding = 1,
      with_markers = true,
      indent_marker = "│",
      last_indent_marker = "└",
      highlight = "NeoTreeIndentMarker",
      with_expanders = nil,
      expander_collapsed = "",
      expander_expanded = "",
      expander_highlight = "NeoTreeExpander",
    },
    icon = {
      folder_closed = "",
      folder_open = "",
      folder_empty = "ﰊ",
      default = "*",
    },
    name = {
      trailing_slash = false,
      use_git_status_colors = true,
    },
    git_status = {
      symbols = {
        -- Change type
        added     = "✚",
        deleted   = "✖",
        modified  = "",
        renamed   = "",
        -- Status type
        untracked = "",
        ignored   = "",
        unstaged  = "",
        staged    = "",
        conflict  = "",
      }
    },
  },
  window = {
    position = "left",
    width = 40,
    mappings = {
      ["<2-LeftMouse>"] = "",
      ["<cr>"] = "",
      ["S"] = "",
      ["s"] = "",
      ["C"] = "",
      ["<bs>"] = "",
      ["."] = "",
      ["H"] = "",
      ["R"] = "",
      ["/"] = "",
      ["f"] = "",
      ["<c-x>"] = "",
      ["a"] = "",
      ["d"] = "",
      ["r"] = "",
      ["y"] = "",
      ["x"] = "",
      ["p"] = "",
      ["c"] = "",
      ["m"] = "",
      ["q"] = "close_window",
    },
  },
  nesting_rules = {},
  filesystem = {
    window = {
      mappings = {
        ["<2-LeftMouse>"] = "open",
        ["<cr>"] = "open",
        ["s"] = "open_split",
        ["v"] = "open_vsplit",
        ["C"] = "close_node",
        ["<bs>"] = "navigate_up",
        ["."] = "set_root",
        ["H"] = "toggle_hidden",
        ["R"] = "refresh",
        ["/"] = "fuzzy_finder",
        ["f"] = "filter_on_submit",
        ["<c-x>"] = "clear_filter",
        ["a"] = "add",
        ["d"] = "delete",
        ["r"] = "rename",
        ["y"] = "copy_to_clipboard",
        ["x"] = "cut_to_clipboard",
        ["p"] = "paste_from_clipboard",
        ["c"] = "copy",
        ["m"] = "move",
        ["q"] = "close_window",
      }
    },
    filtered_items = {
      visible = true,
      hide_dotfiles = true,
      hide_gitignored = true,
      hide_by_name = {
        ".DS_Store",
        "thumbs.db"
        --"node_modules"
      },
      never_show = { -- remains hidden even if visible is toggled to true
        --".DS_Store",
        --"thumbs.db"
      },
    },
    follow_current_file = {
      enabled = true,
    },
    hijack_netrw_behavior = "disabled",
    use_libuv_file_watcher = false,
  },
  buffers = {
    show_unloaded = true,
  },
  git_status = {
    window = {
      position = "float",
    }
  }
})
