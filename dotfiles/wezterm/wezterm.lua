local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.enable_tab_bar = false
config.show_tabs_in_tab_bar = false
config.window_close_confirmation = "NeverPrompt"
config.window_background_opacity = 0.75
config.text_background_opacity = 1.0
config.window_padding = {
	left = "0px",
	right = "0px",
	top = "0px",
	bottom = "0px",
}
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

return config
