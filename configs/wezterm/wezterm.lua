-- Minimal WezTerm configuration using iTerm2 color schemes
local wezterm = require "wezterm"
local act = wezterm.action
local config = wezterm.config_builder()

-- Use built-in iTerm2 color scheme (WezTerm ships with 700+ schemes)
-- Popular options: "Dracula", "Kanagawa (Gogh)", "Gruvbox Dark (Gogh)",
--                  "GruvboxDark", "nord", "Tokyo Night", "Catppuccin Mocha"
-- See full list: https://wezterm.org/colorschemes/
config.color_scheme = 'Aardvark Blue'

-- Font (adjust to your preference)
config.font = wezterm.font_with_fallback({
  {family='Lilex Nerd Font Mono', weight='Regular'},
  {family='SauceCodePro Nerd Font Mono', weight='Regular'},
  {family='FiraCode Nerd Font Mono', weight='Regular'}
})
config.font_size = 10

-- Performance
config.max_fps = 120
config.window_background_opacity = 1.0
config.front_end = "OpenGL"

-- Keybindings - ALT-based for panes and tabs
config.keys = {}

-- Pane management
for _, v in ipairs({
  {"Enter", act.SplitHorizontal{domain='CurrentPaneDomain'}},
  {"w", act.CloseCurrentPane{confirm=true}},
  {"LeftArrow", act.ActivatePaneDirection'Left'},
  {"RightArrow", act.ActivatePaneDirection'Right'},
  {"UpArrow", act.ActivatePaneDirection'Up'},
  {"DownArrow", act.ActivatePaneDirection'Down'},
}) do
  table.insert(config.keys, {mods="ALT", key=v[1], action=v[2]})
end

-- Vertical split
table.insert(config.keys, {mods="ALT|SHIFT", key="Enter",
  action=act.SplitVertical{domain='CurrentPaneDomain'}})

-- Tab management
table.insert(config.keys, {mods="ALT", key="t", action=act.SpawnTab'CurrentPaneDomain'})
table.insert(config.keys, {mods="ALT", key="q", action=act.CloseCurrentTab{confirm=true}})

-- Tab navigation (ALT+1-8)
for i = 0, 7 do
  table.insert(config.keys, {mods="ALT", key=tostring(i+1), action=act.ActivateTab(i)})
end

-- Other
table.insert(config.keys, {mods="ALT", key="c", action=act.CopyTo'ClipboardAndPrimarySelection'})
-- Note: ALT+v intentionally removed so it passes through to tmux (Ctrl+B v = split pane)
table.insert(config.keys, {mods="ALT", key="=", action=act.IncreaseFontSize})
table.insert(config.keys, {mods="ALT", key="-", action=act.DecreaseFontSize})
table.insert(config.keys, {mods="ALT", key="0", action=act.ResetFontSize})

-- Nvim shortcuts (Cmd+key → sends sequences nvim understands)
-- Cmd+S → save file (:w)
table.insert(config.keys, {mods="CMD", key="s",
  action=act.SendString("\x1b:w\r")})
-- Cmd+Shift+S → save without formatting (:noa w)
table.insert(config.keys, {mods="CMD|SHIFT", key="s",
  action=act.SendString("\x1b:noa w\r")})
-- Cmd+Q → quit buffer (:q)
table.insert(config.keys, {mods="CMD", key="q",
  action=act.SendString("\x1b:q\r")})
-- Cmd+O → open sesh picker (Ctrl+B T)
table.insert(config.keys, {mods="CMD", key="o",
  action=act.SendString("\x02T")})
-- Cmd+N → last tmux session (Ctrl+B L)
table.insert(config.keys, {mods="CMD", key="n",
  action=act.SendString("\x02L")})
-- Cmd+M → maximize/restore tmux pane (Ctrl+B m)
table.insert(config.keys, {mods="CMD", key="m",
  action=act.SendString("\x02m")})
-- Cmd+H/J/K/L → move between nvim splits and tmux panes (sends Ctrl+hjkl)
table.insert(config.keys, {mods="CMD", key="h", action=act.SendString("\x08")})
table.insert(config.keys, {mods="CMD", key="j", action=act.SendString("\x0a")})
table.insert(config.keys, {mods="CMD", key="k", action=act.SendString("\x0b")})
table.insert(config.keys, {mods="CMD", key="l", action=act.SendString("\x0c")})
-- Cmd+F → Telescope find files
table.insert(config.keys, {mods="CMD", key="f",
  action=act.SendString("\x1b:Telescope find_files\r")})
-- Cmd+Shift+F → Telescope live grep
table.insert(config.keys, {mods="CMD|SHIFT", key="f",
  action=act.SendString("\x1b:Telescope live_grep\r")})
-- Cmd+G → open lazygit (Space+ls in nvim)
table.insert(config.keys, {mods="CMD", key="g",
  action=act.SendString(" ls")})
-- Cmd+Option+J/K → jump 10 lines down/up in nvim (sends Alt+j/k)
table.insert(config.keys, {mods="CMD|ALT", key="j", action=act.SendString("\x1bj")})
table.insert(config.keys, {mods="CMD|ALT", key="k", action=act.SendString("\x1bk")})

-- Auto-detect Wayland
local is_wayland = os.getenv("WAYLAND_DISPLAY") ~= nil or
                   os.getenv("XDG_SESSION_TYPE") == "wayland"
config.enable_wayland = is_wayland

-- Hide tab bar if only one tab
config.hide_tab_bar_if_only_one_tab = true

return config
