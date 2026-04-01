# eza Cheatsheet

`eza` is an enhanced replacement for `ls` — it shows file icons, git status, colors by file type,
and tree views. Your `~/.zshrc` replaces the default `ls` with eza automatically.

> Install: `brew install eza` (1.4MB)
> For the big picture: see [README.md](README.md)

---

## Your Configured Aliases

These are already set up in `~/.zshrc`. You can use them immediately:

### Basic listing

| Alias | Command | What it shows |
|-------|---------|--------------|
| `ls` | `eza --icons` | Simple list with icons (replaces standard ls) |
| `l` | `eza --icons` | Same as `ls` |
| `ll` | `eza -lg --icons` | Long format with git status |
| `la` | `eza -lag --icons` | Long format + hidden files + git status |

### Tree views

| Alias | Command | What it shows |
|-------|---------|--------------|
| `lt` | `eza -lTg --icons` | Full tree (all levels) |
| `lt1` | `eza -lTg --level=1 --icons` | Tree, 1 level deep |
| `lt2` | `eza -lTg --level=2 --icons` | Tree, 2 levels deep |
| `lt3` | `eza -lTg --level=3 --icons` | Tree, 3 levels deep |
| `lta` | `eza -lTag --icons` | Tree with hidden files |
| `lta1` | `eza -lTag --level=1 --icons` | Tree (hidden) 1 level |
| `lta2` | `eza -lTag --level=2 --icons` | Tree (hidden) 2 levels |
| `lta3` | `eza -lTag --level=3 --icons` | Tree (hidden) 3 levels |

---

## What the Columns Mean (in `ll` / `la`)

```
drwxr-xr-x  user  staff   4.0k  Jan 15  nvim/
.rw-r--r--  user  staff   1.2k  Jan 15  README.md
```

| Column | Meaning |
|--------|---------|
| `drwxr-xr-x` | Permissions (`d` = directory, `-` = file) |
| `user` | Owner (your macOS username) |
| `staff` | Group |
| `4.0k` | Size (human-readable) |
| `Jan 15` | Last modified date |
| `nvim/` | Name (directories end in `/`) |

### Git status column (shown in `ll` / `la`)

When inside a git repo, eza adds a column showing git status:

| Symbol | Meaning |
|--------|---------|
| `M` | Modified |
| `A` | Added (staged) |
| `?` | Untracked |
| `-` | Ignored |
| (blank) | Unchanged |

---

## Icons Require a Nerd Font

The icons (file symbols, folder symbols) only show correctly if your terminal uses a **Nerd Font**.
Your WezTerm is already configured with Lilex Nerd Font — so icons work out of the box.

If you switch terminals and icons show as `?` boxes, install a Nerd Font:
```bash
brew install --cask font-meslo-lg-nerd-font
```

---

## Common eza Flags (for manual use)

| Flag | What it does |
|------|-------------|
| `-l` | Long format (permissions, size, date) |
| `-a` | Include hidden files (dotfiles) |
| `-g` | Show git status column |
| `-T` | Tree view (recursive) |
| `--level=N` | Tree depth limit |
| `--icons` | Show file type icons |
| `--sort=size` | Sort by file size |
| `--sort=modified` | Sort by last modified |
| `-r` | Reverse sort order |

---

## Quick Reference Card

```
ls          → list with icons
ll          → long format + git status
la          → long format + hidden files + git status
lt          → full tree view
lt2         → tree, 2 levels deep
lta2        → tree with hidden files, 2 levels deep

# Sort by size
eza -l --sort=size

# Sort by most recently modified
eza -l --sort=modified
```

---

## What's Next

See [starship.md](starship.md) — the shell prompt that shows your git branch, cloud context, and more.
