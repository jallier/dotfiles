local wezterm = require("wezterm")
local act = wezterm.action
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

local function save_workspace_state()
	local state = resurrect.workspace_state.get_workspace_state()
	resurrect.state_manager.save_state(state)
	resurrect.state_manager.write_current_state(state.workspace, "workspace")
end

local function save_window_state(_, pane)
	resurrect.state_manager.save_state(resurrect.window_state.get_window_state(pane:window()))
end

local function save_tab_state(_, pane)
	resurrect.state_manager.save_state(resurrect.tab_state.get_tab_state(pane:tab()))
end

local function save_workspace_and_window(window, pane)
	save_workspace_state()
	save_window_state(window, pane)
end

local function load_saved_state(window, pane)
	resurrect.fuzzy_loader.fuzzy_load(window, pane, function(id)
		local state_type = string.match(id, "^([^/]+)")
		id = string.match(id, "([^/]+)$")
		id = string.match(id, "(.+)%..+$")
		local opts = {
			relative = true,
			restore_text = true,
			on_pane_restore = resurrect.tab_state.default_on_pane_restore,
		}

		if state_type == "workspace" then
			resurrect.workspace_state.restore_workspace(resurrect.state_manager.load_state(id, state_type), opts)
		elseif state_type == "window" then
			resurrect.window_state.restore_window(
				pane:window(),
				resurrect.state_manager.load_state(id, state_type),
				opts
			)
		elseif state_type == "tab" then
			resurrect.tab_state.restore_tab(
				pane:tab(),
				resurrect.state_manager.load_state(id, state_type),
				opts
			)
		end
	end)
end

wezterm.on("resurrect.state_manager.periodic_save.finished", function()
	local workspace = wezterm.mux.get_active_workspace()
	if workspace then
		resurrect.state_manager.write_current_state(workspace, "workspace")
	end
end)

wezterm.on("augment-command-palette", function()
	return {
		{
			brief = "Resurrect: Save Workspace",
			action = wezterm.action_callback(save_workspace_state),
		},
		{
			brief = "Resurrect: Save Window",
			action = wezterm.action_callback(save_window_state),
		},
		{
			brief = "Resurrect: Save Tab",
			action = wezterm.action_callback(save_tab_state),
		},
		{
			brief = "Resurrect: Save Workspace and Window",
			action = wezterm.action_callback(save_workspace_and_window),
		},
		{
			brief = "Resurrect: Load Saved State",
			action = wezterm.action_callback(load_saved_state),
		},
	}
end)

wezterm.on("gui-startup", resurrect.state_manager.resurrect_on_gui_startup)
resurrect.state_manager.periodic_save({
	interval_seconds = 15 * 60,
	save_workspaces = true,
})

-- local config = wezterm.config_builder()
local config = {}

config.color_scheme = "Catppuccin Macchiato"
-- config.font = wezterm.font_with_fallback("JetBrains Mono")
config.font_size = 13

-- Slightly transparent and blurred background
config.window_background_opacity = 0.9
config.macos_window_background_blur = 30
-- Removes the title bar, leaving only the tab bar. Keeps
-- the ability to resize by dragging the window's edges.
-- On macOS, 'RESIZE|INTEGRATED_BUTTONS' also looks nice if
-- you want to keep the window controls visible and integrate
-- them into the tab bar.
config.window_decorations = "RESIZE"

-- config.pane_focus_follows_mouse = true
config.pane_focus_follows_mouse = false -- having to set this because of an issue with deskflow
config.front_end = "WebGpu"
config.command_palette_font_size = 18

-- Disable audible beep and visual flash, use notification instead
config.audible_bell = "Disabled"
config.visual_bell = {
	fade_in_duration_ms = 0,
	fade_out_duration_ms = 0,
}

config.audible_bell = "SystemBeep"

-- This was a test, but its kinda useful
wezterm.on("window-config-reloaded", function(window, pane)
	window:toast_notification("wezterm", "configuration reloaded!", nil, 4000)
end)

wezterm.on("update-status", function(window)
	-- Grab the utf8 character for the "powerline" left facing
	-- solid arrow.
	local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

	-- Grab the current window's configuration, and from it the
	-- palette (this is the combination of your chosen colour scheme
	-- including any overrides).
	local color_scheme = window:effective_config().resolved_palette
	local bg = color_scheme.background
	local fg = color_scheme.foreground

	window:set_right_status(wezterm.format({
		-- First, we draw the arrow...
		{ Background = { Color = "none" } },
		{ Foreground = { Color = bg } },
		{ Text = SOLID_LEFT_ARROW },
		-- Then we draw our text
		{ Background = { Color = bg } },
		{ Foreground = { Color = fg } },
		{ Text = " " .. wezterm.hostname() .. " " },
	}))
end)

-- Table mapping keypresses to actions
config.keys = {
	-- Sends ESC + b and ESC + f sequence, which is used
	-- for telling your shell to jump back/forward.
	{
		key = "LeftArrow",
		mods = "OPT",
		action = wezterm.action.SendString("\x1bb"),
	},
	{
		key = "RightArrow",
		mods = "OPT",
		action = wezterm.action.SendString("\x1bf"),
	},
	{
		key = ",",
		mods = "SUPER",
		action = wezterm.action.SpawnCommandInNewTab({
			cwd = wezterm.home_dir,
			args = { "nvim", wezterm.config_file },
			set_environment_variables = {
				NVIM_APPNAME = "lazyvim",
			},
		}),
	},
	-- Ensure that alt enter works in the shell instead of fullscreening the app
	{
		key = "Enter",
		mods = "ALT",
		action = wezterm.action.DisableDefaultAssignment,
	},
	-- Pass ctrl+shift+r through to terminal applications (e.g. jjui)
	{
		key = "r",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SendKey({ key = "r", mods = "CTRL|SHIFT" }),
	},
	{
		key = "E",
		mods = "CTRL|SHIFT",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			initial_value = "",
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{
		key = "w",
		mods = "ALT",
		action = wezterm.action_callback(save_workspace_state),
	},
	{
		key = "W",
		mods = "ALT",
		action = wezterm.action_callback(save_window_state),
	},
	{
		key = "T",
		mods = "ALT",
		action = wezterm.action_callback(save_tab_state),
	},
	{
		key = "s",
		mods = "ALT",
		action = wezterm.action_callback(save_workspace_and_window),
	},
	{
		key = "r",
		mods = "ALT",
		action = wezterm.action_callback(load_saved_state),
	},
}

-- Loop to create bindings for moving tabs to a specific position (1-8)
for i = 1, 8 do
	table.insert(config.keys, {
		-- Key: "1", "2", etc.
		key = tostring(i),
		-- Mods: Command + Option (standard for Mac productivity)
		mods = "CMD|OPT",
		-- MoveTab is 0-based, so subtract 1 from our loop index
		action = wezterm.action.MoveTab(i - 1),
	})
end

config.set_environment_variables = {
	PATH = "/opt/homebrew/bin:" .. os.getenv("PATH"),
}

return config
