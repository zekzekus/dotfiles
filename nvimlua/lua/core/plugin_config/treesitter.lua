-- require 'nvim-treesitter.install'.compilers = { 'clang' }

local tsitter = prequire("nvim-treesitter.configs")

if not tsitter then
  return
end

tsitter.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "lua", "python", "vim", "vimdoc", "query" },
  -- ensure_installed = "all",
  -- ignore_install = { "phpdoc", },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,
  auto_install = true,
  ignore_install = { "yaml" },

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
  },

  -- YATI Indenter
  yati = {
    enable = true,
    -- Disable by languages, see `Supported languages`
    disable = { "php" },

    -- Whether to enable lazy mode (recommend to enable this if bad indent happens frequently)
    default_lazy = true,

    -- Determine the fallback method used when we cannot calculate indent by tree-sitter
    --   "auto": fallback to vim auto indent
    --   "asis": use current indent as-is
    --   "cindent": see `:h cindent()`
    -- Or a custom function return the final indent result.
    default_fallback = "auto"
  },
  indent = {
    enable = true,
    -- disable = { "yaml", "python" },
  },
}
