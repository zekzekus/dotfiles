-- require('lualine').setup {
-- 	options = {
-- 		icons_enabled = true,
-- 		theme = 'gruvbox',
-- 	},
-- 	sections = {
-- 		lualine_a = {
-- 			{
-- 				'filename',
-- 				path = 1,
-- 			}
-- 		}
-- 	}
-- }

require('lualine').setup {
  options = {
    theme = 'dracula',
    -- theme = 'nord',
    path = 1,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
}
