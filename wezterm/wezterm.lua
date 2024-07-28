local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.font = wezterm.font 'Berkeley Mono Nerd Complete'
config.font_size = 15.0
config.color_scheme = 'vimbones'
config.hide_tab_bar_if_only_one_tab = true

return config
