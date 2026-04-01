# Nvim Cheatsheet

Nvim (Neovim) is a **terminal code editor** that runs inside a tmux pane.
It has no menus or mouse buttons — everything is keyboard-driven.
That sounds scary, but there are only a handful of things you need to know to start.

> Open it: `nvim .` (opens file explorer) or `nvim filename.md`
> Config file: `~/.config/nvim/`
> For the big picture: see [README.md](README.md)

---

## The Single Most Important Concept: Modes

Nvim has **3 modes**. Everything makes sense once you know which mode you're in.

```
┌─────────────────────────────────────────────────────────┐
│  NORMAL mode  ← you start here. Keys are COMMANDS.      │
│               "j" moves down. "dd" deletes a line.      │
│                                                         │
│  INSERT mode  ← keys TYPE text. Like a normal editor.   │
│               "Hello world" types "Hello world".        │
│                                                         │
│  VISUAL mode  ← keys SELECT text. Like click+drag.      │
│               Then you can copy/delete/indent it.       │
└─────────────────────────────────────────────────────────┘
```

### How to switch modes

| From | To | How |
|------|----|-----|
| Normal | Insert | Press `i` (insert before cursor) or `a` (insert after) or `o` (new line below) |
| Normal | Visual | Press `v` (character select) or `Shift+V` (line select) |
| Insert | Normal | Press `jk` (custom — faster) or `Escape` |
| Visual | Normal | Press `Escape` or `jk` |

> **The most common beginner mistake:** trying to type text while in Normal mode.
> If keys are doing weird things — press `Escape` to get back to Normal mode.

### How to know which mode you're in

Look at the **bottom-left of the screen**:
- Nothing / `NORMAL` = Normal mode
- `INSERT` = Insert mode
- `VISUAL` = Visual mode

---

## The Leader Key

Many shortcuts start with `Space`. In nvim, `Space` is called the **leader key**.

When you see `<leader>ff` in this doc, it means:
1. Press `Space` (release it)
2. Press `f`
3. Press `f`

It's a sequence, not a chord — same idea as `Ctrl+B` in tmux.

> Press `Space` alone and wait a moment — a **which-key popup** appears showing all available shortcuts. It's your built-in cheatsheet.

---

##Survival Basics — Start Here

These are the 10 things you need on day 1:

| Key | Mode | What it does |
|-----|------|-------------|
| `i` | Normal | Enter Insert mode (start typing) |
| `jk` | Insert | Exit Insert mode → back to Normal |
| `Escape` | Any | Back to Normal mode (always safe) |
| `Cmd+S` | Insert/Normal | Save file (WezTerm shortcut) |
| `:w` + Enter | Normal | Save file (nvim native) |
| `Cmd+Q` | Normal | Close buffer / quit (WezTerm shortcut) |
| `:q` + Enter | Normal | Quit (nvim native) |
| `:q!` + Enter | Normal | Quit WITHOUT saving (force quit) |
| `u` | Normal | Undo |
| `Ctrl+R` | Normal | Redo |

> `:` opens the nvim command line at the bottom. Type a command and press Enter.

---

## Moving Around (Normal Mode)

You never need to reach for arrow keys — these are faster:

### Basic movement

| Key | What it does |
|-----|-------------|
| `h` | Move left |
| `j` | Move down |
| `k` | Move up |
| `l` | Move right |
| `w` | Jump forward one **word** |
| `b` | Jump backward one **word** |
| `0` | Jump to start of line |
| `$` | Jump to end of line |
| `gg` | Jump to top of file |
| `G` | Jump to bottom of file |
| `Ctrl+U` | Scroll up half page |
| `Ctrl+D` | Scroll down half page |

### Jump 10 lines at a time

| Key | What it does |
|-----|-------------|
| `Cmd+Option+J` | Jump 10 lines down (WezTerm shortcut) |
| `Cmd+Option+K` | Jump 10 lines up (WezTerm shortcut) |

### Line numbers (left side)

The left gutter shows **relative line numbers**:
- The current line shows its absolute number (e.g. `42`)
- Lines above/below show distance from cursor (e.g. `3`, `2`, `1`)

This lets you say `5j` to jump exactly 5 lines down, or `3k` to jump 3 lines up.

### Search

| Key | What it does |
|-----|-------------|
| `/word` + Enter | Search forward for "word" |
| `?word` + Enter | Search backward for "word" |
| `n` | Next match (stays centered on screen) |
| `N` | Previous match |
| `Space+nh` | Clear search highlights |
| `*` | Search for word under cursor |

---

## File Explorer (nvim-tree)

The file explorer shows your project's folder structure on the left side.

| Key | What it does |
|-----|-------------|
| `Space+ee` | Toggle file explorer open/close |
| `Space+ef` | Reveal current file in explorer |
| `Space+ec` | Collapse all folders |
| `Space+er` | Refresh explorer |

### Inside the file explorer

| Key | What it does |
|-----|-------------|
| `Enter` | Open file / expand folder |
| `a` | Create a new file or folder (end with `/` for folder) |
| `d` | Delete file/folder |
| `r` | Rename |
| `x` | Cut |
| `c` | Copy |
| `p` | Paste |
| `q` | Close explorer |
| `H` | Toggle hidden files |
| `?` | Show all explorer keybindings |

> Move back to your code: use `Ctrl+H` (vim-tmux-navigator — same as moving between tmux panes)

---

## Finding Files (Telescope)

Telescope is a **fuzzy finder popup** — type a few letters to find anything instantly.

| Key | What it finds |
|-----|--------------|
| `Space+ff` | Files in current project (fuzzy search by name) |
| `Space+fr` | Recently opened files |
| `Space+fs` | Search for a string inside all files (live grep) |
| `Space+fc` | Search for the word under your cursor in all files |
| `Space+ft` | Find all TODO/FIXME comments in the project |

### Inside Telescope

| Key | Action |
|-----|--------|
| Type | Filter results in real time |
| `Ctrl+J` / `Ctrl+K` | Move down / up |
| `Enter` | Open selected file |
| `Escape` | Close without opening |
| `Ctrl+Q` | Send results to quickfix list |

---

## Splits and Windows

You can split the editor into multiple panes — just like tmux panes, but inside nvim.

| Key | What it does |
|-----|-------------|
| `Space+sv` | Split **vertically** (side by side) |
| `Space+sh` | Split **horizontally** (top / bottom) |
| `Space+se` | Make all splits equal size |
| `Space+sx` | Close current split |

### Moving between splits (and tmux panes)

| Key | What it does |
|-----|-------------|
| `Ctrl+H` | Move to pane/split on the left |
| `Ctrl+J` | Move to pane/split below |
| `Ctrl+K` | Move to pane/split above |
| `Ctrl+L` | Move to pane/split on the right |

> These same keys work seamlessly between nvim splits AND tmux panes — `vim-tmux-navigator` handles the routing automatically.

---

## Buffers

A **buffer** is an open file. You can have many files open at once — they appear as tabs in the bar at the top.

| Key | What it does |
|-----|-------------|
| `Space+bb` | Browse all open buffers (Telescope picker) |
| `Space+bn` | Next buffer |
| `Space+bp` | Previous buffer |
| `Space+bd` | Delete (close) current buffer |
| `Space+bl` | Jump to last buffer (toggle between two) |

---

## Editing Text

### In Normal mode

| Key | What it does |
|-----|-------------|
| `dd` | Delete (cut) current line |
| `yy` | Copy (yank) current line |
| `p` | Paste below current line |
| `x` | Delete character under cursor |
| `ciw` | Change inner word (delete word + enter Insert) |
| `dw` | Delete from cursor to end of word |
| `.` | Repeat the last change |
| `>>` | Indent line right |
| `<<` | Indent line left |

### In Visual mode (after selecting text)

| Key | What it does |
|-----|-------------|
| `y` | Copy (yank) selection |
| `d` | Delete selection |
| `>` | Indent right |
| `<` | Indent left |
| `*` | Search for selected text |

### Wrap word in quotes (Normal mode)

| Key | What it does |
|-----|-------------|
| `Space+"` | Wrap word under cursor in double quotes |
| `Space+'` | Wrap word under cursor in single quotes |
| `Space+`` ` | Wrap word under cursor in backticks |

---

## Git Integration (gitsigns)

When you're inside a git repo, nvim shows changes in the left gutter:
- `+` green = new line added
- `~` yellow = line changed
- `-` red = line deleted

These changed sections are called **hunks**.

| Key | What it does |
|-----|-------------|
| `hn` | Jump to **next** hunk |
| `hp` | Jump to **previous** hunk |
| `Space+hs` | Stage hunk (add it to git staging area) |
| `Space+hr` | Reset hunk (undo the change) |
| `Space+hb` | Show git blame for current line |
| `Space+hB` | Toggle git blame on all lines |
| `Space+hd` | Diff this file against last commit |

### Lazygit (full git UI)

Press `Cmd+G` (WezTerm shortcut) to open lazygit — a full terminal git interface where you can commit, push, view history, etc.

---

## LSP — Code Intelligence

LSP (Language Server Protocol) gives nvim IDE features: go to definition, autocomplete, errors, etc.
It activates automatically when you open a code file (`.js`, `.py`, `.lua`, `.ts`, etc.).

| Key | What it does |
|-----|-------------|
| `gd` | **Go to definition** — jump to where a function/variable is defined |
| `gR` | **Show references** — where is this used in the project? |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `K` | **Hover docs** — show documentation for what's under cursor |
| `Space+ca` | **Code actions** — fix suggestions, auto-imports, etc. |
| `Space+rn` | **Rename** — rename a variable/function across the whole project |
| `Space+d` | Show diagnostics (errors/warnings) for current line |
| `Space+D` | Show all diagnostics for current file |
| `[d` | Go to previous error/warning |
| `]d` | Go to next error/warning |
| `Space+rs` | Restart LSP (if it gets stuck) |

> Only errors show inline (not warnings) — keeps the code readable.
> Warnings still appear when you hover (`K`) or check `Space+D`.

---

## Markdown (special features)

This config has special markdown rendering — headings, checkboxes, tables, and code blocks
are styled visually when you're in Normal mode.

| Key | What it does |
|-----|-------------|
| `Space+mr` | Toggle markdown rendering on/off |
| `Cmd+Enter` | Toggle checkbox `[ ]` → `[x]` |

---

## Useful One-Liners

```
# Open nvim in current directory (shows file explorer)
nvim .

# Open a specific file
nvim myfile.md

# Open multiple files as splits
nvim -O file1.md file2.md    # side by side
nvim -o file1.md file2.md    # top/bottom
```

---

## Quick Reference Card

```
# Modes
i           → Insert mode (start typing)
jk / Escape → back to Normal mode
v           → Visual mode (select characters)
Shift+V     → Visual line mode (select whole lines)

# Survival
Cmd+S       → save
Cmd+Q       → quit buffer
:w          → save (nvim native)
:q          → quit
:q!         → quit without saving
u           → undo
Ctrl+R      → redo

# Moving (Normal mode)
h/j/k/l     → left/down/up/right
w / b       → next / prev word
gg / G      → top / bottom of file
Ctrl+U/D    → scroll half page
/word       → search, n = next, N = prev
Space+nh    → clear search highlight

# File explorer
Space+ee    → toggle explorer
Space+ef    → find current file in explorer

# Finding files (Telescope)
Space+ff    → find files
Space+fr    → recent files
Space+fs    → search text in all files
Space+ft    → find TODOs

# Splits
Space+sv    → split vertical
Space+sh    → split horizontal
Space+sx    → close split
Ctrl+H/J/K/L → move between splits/panes

# Buffers
Space+bb    → browse buffers
Space+bn/bp → next / prev buffer
Space+bd    → close buffer

# Git
hn / hp     → next / prev hunk
Space+hs    → stage hunk
Cmd+G       → open lazygit

# LSP (code files only)
gd          → go to definition
gR          → show references
K           → hover docs
Space+ca    → code actions
Space+rn    → rename symbol
```
