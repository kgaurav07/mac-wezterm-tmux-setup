# mac-wezterm-tmux-setup

A complete Mac terminal environment — keyboard-driven, fast, and repeatable.

**What you get:** WezTerm + tmux + sesh + zoxide + nvim + eza + starship + fzf + fd

```
WezTerm (terminal app)
  └── tmux (session manager — keeps sessions alive)
        └── sesh + zoxide (fuzzy project switcher)
              └── nvim (code editor)
```

---

## Quick Start

```bash
git clone https://github.com/kgaurav07/mac-wezterm-tmux-setup
cd mac-wezterm-tmux-setup
./install.sh
```

Then follow the 5 manual steps printed at the end.

---

## What install.sh Does

1. Installs Homebrew (if missing)
2. Installs all CLI tools: `tmux sesh zoxide fzf fd nvim eza starship lazygit`
3. Installs WezTerm app and Lilex Nerd Font (via `brew --cask`)
4. Installs TPM (tmux plugin manager)
5. Copies configs from `configs/` → `~/.config/` (backs up existing files)
6. Adds `zoxide`, `starship`, and `eza` aliases to `~/.zshrc`

**Safe to re-run** — skips already-installed tools, backs up existing configs before overwriting.

---

## Repo Structure

```
mac-wezterm-tmux-setup/
├── install.sh              ← run this once on a new Mac
├── README.md               ← you are here
├── .gitignore
├── configs/                ← config files, copied to ~/.config/ by install.sh
│   ├── nvim/               ← full Neovim config
│   ├── tmux/
│   │   └── tmux.conf
│   ├── wezterm/
│   │   └── wezterm.lua
│   └── sesh/
│       └── sesh.toml.template   ← edit after install to add your projects
└── mysetup/
    └── docs/               ← cheatsheets for every tool
        ├── README.md        ← start here — architecture overview
        ├── wezterm.md
        ├── zoxide.md
        ├── tmux.md
        ├── sesh.md
        ├── nvim.md
        ├── lua.md
        ├── fd.md
        ├── fzf.md
        ├── eza.md
        └── starship.md
```

---

## After Running install.sh — Manual Steps

| Step | What to do |
|------|-----------|
| 1 | Open **WezTerm** from Applications |
| 2 | Run `tmux`, then press `Ctrl+B` then `Shift+I` to install tmux plugins |
| 3 | Run `nvim .` — lazy.nvim auto-installs plugins on first launch |
| 4 | Run `source ~/.zshrc` to activate shell changes |
| 5 | Edit `~/.config/sesh/sesh.toml` to add your project paths |

---

## Customising

| What | Where |
|------|-------|
| Terminal colours, font | `configs/wezterm/wezterm.lua` |
| tmux keybindings | `configs/tmux/tmux.conf` |
| nvim plugins, LSP servers | `configs/nvim/lua/blake/plugins/` |
| Project shortcuts | `~/.config/sesh/sesh.toml` (not in git — personal) |

---

## Learn the Tools

See `mysetup/docs/` for step-by-step guides on every tool.
Start with [`mysetup/docs/README.md`](docs/README.md) for the big picture.

---

## Requirements

- macOS (uses `pbcopy` for clipboard, `brew` for installs, WezTerm `.app`)
- Git (pre-installed on macOS via Xcode Command Line Tools)
- Internet connection (for Homebrew and plugin installs)
