local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'vimbones'

config.font = wezterm.font 'Berkeley Mono Nerd Complete'
config.font_size = 15.0

config.hide_tab_bar_if_only_one_tab = true

-- config.leader = { key = "a", mods="CTRL" }
-- config.keys = {
--   { key = "%",  mods="LEADER",          action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}} },
--   { key = "\"", mods="LEADER",          action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}} },
--   { key = "h",  mods = "LEADER",        action=wezterm.action{ActivatePaneDirection="Left"}},
--   { key = "j",  mods = "LEADER",        action=wezterm.action{ActivatePaneDirection="Down"}},
--   { key = "k",  mods = "LEADER",        action=wezterm.action{ActivatePaneDirection="Up"}},
--   { key = "l",  mods = "LEADER",        action=wezterm.action{ActivatePaneDirection="Right"}},
--   { key = "H",  mods = "LEADER|SHIFT",  action=wezterm.action{AdjustPaneSize={"Left", 5}}},
--   { key = "J",  mods = "LEADER|SHIFT",  action=wezterm.action{AdjustPaneSize={"Down", 5}}},
--   { key = "K",  mods = "LEADER|SHIFT",  action=wezterm.action{AdjustPaneSize={"Up", 5}}},
--   { key = "L",  mods = "LEADER|SHIFT",  action=wezterm.action{AdjustPaneSize={"Right", 5}}},
-- }

return config
