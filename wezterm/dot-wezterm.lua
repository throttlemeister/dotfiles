-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.default_prog = { "/usr/bin/fish" }

-- For example, changing the color scheme:
config.color_scheme = "Catppuccin Frappe"

-- Font config
config.font = wezterm.font("IosevkaTermNF-Light")

-- Background opacity
config.window_background_opacity = 0.95

-- Windows size
config.initial_cols = 135
config.initial_rows = 35

-- Remove tabbar
config.enable_tab_bar = false

-- and finally, return the configuration to wezterm
return config
