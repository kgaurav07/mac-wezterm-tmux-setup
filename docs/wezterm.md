# WezTerm Cheatsheet

WezTerm is your **terminal emulator** — the app that runs your terminal on macOS.
Think of it like iTerm2, but more customizable. Your shortcuts use the `Option` key (⌥).

> Config file: `~/.config/wezterm/wezterm.lua`

---

## Pane Management (splitting the terminal window)

A **pane** is a split section inside a single tab.

| Shortcut | Action | Notes |
|----------|--------|-------|
| `⌥ + Enter` | Split pane **horizontally** (side by side) | Creates a new pane to the right |
| `⌥ + Shift + Enter` | Split pane **vertically** (top/bottom) | Creates a new pane below |
| `⌥ + w` | Close current pane | Asks for confirmation |

---

## Pane Navigation (moving between panes)

| Shortcut | Action | Notes |
|----------|--------|-------|
| `⌥ + ←` | Move focus to pane on the **left** | |
| `⌥ + →` | Move focus to pane on the **right** | |
| `⌥ + ↑` | Move focus to pane **above** | |
| `⌥ + ↓` | Move focus to pane **below** | |

---

## Tab Management

A **tab** is like a browser tab — a separate terminal inside the same WezTerm window.

| Shortcut | Action | Notes |
|----------|--------|-------|
| `⌥ + t` | Open a **new tab** | |
| `⌥ + q` | **Close** current tab | Asks for confirmation |
| `⌥ + 1` | Go to tab 1 | |
| `⌥ + 2` | Go to tab 2 | Numbers 1–8 work |
| `⌥ + ←` | Go to **previous** tab | Also works for pane nav (context-dependent) |
| `⌥ + →` | Go to **next** tab | |

> The tab bar auto-hides when there is only one tab open.

---

## Copy & Paste

| Shortcut | Action | Notes |
|----------|--------|-------|
| `⌥ + c` | **Copy** selected text | Copies to both clipboard and primary selection |
| `Cmd + v` | **Paste** from clipboard | Use Cmd+V for paste — ⌥+v is reserved for tmux |
| `Right-click` | **Copy** text | Quick copy without keyboard |
| `Middle-click` | **Split** pane horizontally | Middle mouse button shortcut |
| `Shift + Middle-click` | **Close** current pane | Instant close, no confirmation |

---

## Font Size

| Shortcut | Action |
|----------|--------|
| `⌥ + =` | Increase font size |
| `⌥ + -` | Decrease font size |
| `⌥ + 0` | Reset font size to default (10pt) |

---

## Nvim Shortcuts (Cmd+key)

These shortcuts work when you're inside nvim in a tmux pane.
WezTerm intercepts `Cmd+key` and sends the right sequence to nvim.

### File operations

| Shortcut | What it does |
|----------|-------------|
| `Cmd+S` | Save file |
| `Cmd+Shift+S` | Save without running formatters |
| `Cmd+Q` | Quit current buffer |

### Navigation

| Shortcut | What it does |
|----------|-------------|
| `Cmd+H/J/K/L` | Move between nvim splits and tmux panes seamlessly |
| `Cmd+Option+J` | Jump 10 lines down |
| `Cmd+Option+K` | Jump 10 lines up |
| `Cmd+F` | Telescope — find files |
| `Cmd+Shift+F` | Telescope — search text inside all files |

### Session / window

| Shortcut | What it does |
|----------|-------------|
| `Cmd+O` | Open sesh picker (jump to any project) |
| `Cmd+N` | Toggle to last tmux session |
| `Cmd+M` | Maximize / restore current tmux pane |
| `Cmd+G` | Open lazygit |

---

## Appearance

| Setting | Value | Where to change |
|---------|-------|-----------------|
| Color scheme | Aardvark Blue (dark blue theme) | `config.color_scheme` in wezterm.lua |
| Font | Lilex Nerd Font Mono (falls back to SauceCodePro, FiraCode) | `config.font` in wezterm.lua |
| Font size | 10pt | `config.font_size` in wezterm.lua |
| Transparency | None (fully opaque) | `config.window_background_opacity = 1.0` |

---

## What's Next (Phase 1)

Once you're comfortable here, the next step is installing **zoxide** — a smarter `cd` command
that remembers your directories. This is the foundation for using `sesh` (session manager).

See: [zoxide.md](zoxide.md)
