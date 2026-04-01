# My Terminal Setup — Architecture Overview

This document explains how all the tools fit together.
Read this first before diving into the individual cheatsheets.

---

## The Full Picture

```
┌─────────────────────────────────────────────────────────────────┐
│  macOS                                                          │
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  WezTerm  (the terminal app — like iTerm2)                │  │
│  │                                                           │  │
│  │  ┌─────────────────┐   ┌─────────────────┐               │  │
│  │  │   Tab 1: Mac    │   │  Tab 2: Server  │  ← ⌥+t        │  │
│  │  │                 │   │  (SSH session)  │               │  │
│  │  │  ┌───────────┐  │   └─────────────────┘               │  │
│  │  │  │   tmux    │  │                                      │  │
│  │  │  │           │  │                                      │  │
│  │  │  │ ┌───┬───┐ │  │                                      │  │
│  │  │  │ │   │   │ │  │  ← tmux panes (splits)               │  │
│  │  │  │ └───┴───┘ │  │                                      │  │
│  │  │  │           │  │                                      │  │
│  │  │  │  session: │  │                                      │  │
│  │  │  │  "proj-A" │  │                                      │  │
│  │  │  └───────────┘  │                                      │  │
│  │  └─────────────────┘                                      │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

---

## The Layers Explained

### Layer 1 — WezTerm (the window)

WezTerm is the **terminal emulator** — the macOS app you see on screen.
It's the outermost layer. Everything else runs inside it.

**What WezTerm owns:**
- **Tabs** — like browser tabs. Use one tab per machine (Mac, server, etc.)
- **Panes** — you can split a WezTerm tab into side-by-side areas too

> See: [wezterm.md](wezterm.md)

---

### Layer 2 — tmux (the session manager)

Tmux runs **inside** a WezTerm tab. It's invisible but powerful.

**What tmux owns:**
- **Sessions** — a named workspace (one per project). Sessions survive WezTerm closing.
- **Windows** — tabs inside tmux (we mostly ignore these — use sessions instead)
- **Panes** — splits inside a tmux session

**The killer feature:** if WezTerm crashes or you close it, your tmux sessions keep running.
`tmux attach` brings everything back exactly as you left it.

> See: [tmux.md](tmux.md)

---

### Layer 3 — sesh + zoxide (the navigator)

**Sesh** is a session picker that runs inside tmux.
Press `Ctrl+B T` → a fuzzy search popup lets you jump to any project instantly.

**Zoxide** feeds sesh the list of directories it knows.
The more you `cd` around, the more zoxide learns, and the more sesh can show you.

> See: [zoxide.md](zoxide.md) | sesh.md (coming soon)

---

### Layer 4 — nvim (the editor)

Neovim is a terminal-based code editor. It runs inside a tmux pane.
It has its own splits, file navigation, and keybindings.

> See: nvim.md (coming soon)

---

## The Confusion: "Panes" Exist Everywhere

Both WezTerm AND tmux have panes (splits). Here's the rule:

| Where | Use case | How to split |
|-------|----------|-------------|
| **WezTerm panes** | Rarely — mostly for side-by-side terminal output without tmux | `⌥ + Enter` |
| **tmux panes** | Always — this is your day-to-day split workflow | `Ctrl+B /` or `Ctrl+B v` |

**Rule of thumb:**
- Use **WezTerm tabs** (`⌥+t`) to switch between machines
- Use **tmux sessions** (`Ctrl+B T`) to switch between projects
- Use **tmux panes** (`Ctrl+B /`) to split your screen within a project

---

## How the Shortcuts Flow

```
WezTerm key          →  what happens
─────────────────────────────────────────────────────
⌥ + t               →  new WezTerm tab (new machine/context)
⌥ + Enter           →  split WezTerm pane (rarely used)
⌥ + Arrow keys      →  move between WezTerm panes

Ctrl+B prefix        →  tmux command (everything below is tmux)
─────────────────────────────────────────────────────
Ctrl+B  T           →  sesh picker (jump to any project)
Ctrl+B  L           →  last tmux session (toggle between 2)
Ctrl+B  d           →  detach (leave tmux, goes to background)
Ctrl+B  /           →  split tmux pane left/right
Ctrl+B  v           →  split tmux pane top/bottom
Ctrl+B  x           →  kill current tmux pane
Ctrl+B  m           →  maximize/restore current pane
```

---

## The Learning Path

| Step | Tool | Status |
|------|------|--------|
| 0 | WezTerm | ✅ Done |
| 1 | zoxide | ✅ Done |
| 2 | tmux | ✅ Done |
| 3 | sesh | ✅ Done |
| 4 | nvim | ✅ Done |

---

## Cheatsheet Index

| File | What it covers |
|------|----------------|
| [wezterm.md](wezterm.md) | WezTerm tabs, panes, copy/paste, font size |
| [zoxide.md](zoxide.md) | Smart `cd`, `z`, `zi`, adding/removing directories |
| [tmux.md](tmux.md) | Sessions, panes, splits, copy mode, sesh integration |
| [sesh.md](sesh.md) | Session picker, project jumping, sesh.toml |
| [fd.md](fd.md) | Fast file finder — powers sesh `Ctrl+F`, OneDrive search |
| [fzf.md](fzf.md) | Fuzzy finder — powers the sesh picker and `zi` |
| [eza.md](eza.md) | Enhanced `ls` with icons, tree views, git status |
| [starship.md](starship.md) | Shell prompt — git branch, language versions, exit codes |
| [nvim.md](nvim.md) | Editor modes, file explorer, Telescope, LSP, git |

---

## Dependencies & Installation

All tools installed via Homebrew. Run `brew install <name>` to install any missing ones.

| Tool | Version | Size | Purpose | Required by |
|------|---------|------|---------|-------------|
| **WezTerm** | — | ~100MB | Terminal emulator (macOS app) | Everything |
| **tmux** | 3.6a | 1.3MB | Session manager | sesh |
| **sesh** | 2.24.2 | 7.2MB | Session picker | tmux |
| **zoxide** | 0.9.9 | 1.0MB | Smart `cd` / directory memory | sesh `Ctrl+X` |
| **fzf** | 0.70.0 | 4.8MB | Fuzzy finder (powers sesh picker) | sesh, zoxide `zi` |
| **fd** | 10.4.2 | 3.0MB | Fast file finder | sesh `Ctrl+F` |
| **nvim** | 0.11.6 | 32MB | Terminal code editor | optional |
| **eza** | 0.23.4 | 1.4MB | Better `ls` with icons | optional |
| **starship** | 1.24.2 | 8.3MB | Shell prompt (shows git, cloud, etc.) | optional |

### Install everything at once
```bash
brew install tmux sesh zoxide fzf fd nvim eza starship
```

### Shell setup (add to ~/.zshrc)
```bash
eval "$(zoxide init zsh)"    # enables z and zi commands
export PATH                  # ensures tmux inherits full PATH
```

---

## Config File Locations

| Tool | Config file |
|------|-------------|
| WezTerm | `~/.config/wezterm/wezterm.lua` |
| tmux | `~/.config/tmux/tmux.conf` |
| sesh | `~/.config/sesh/sesh.toml` |
| nvim | `~/.config/nvim/` |
| zsh shell | `~/.zshrc` |

All configs (except zshrc) are **symlinked** from the dotfiles repo at:
`~/Library/CloudStorage/OneDrive-SAPSE/00_code2/03_OnlineRepos/cca-blake-public-dotfiles/`
