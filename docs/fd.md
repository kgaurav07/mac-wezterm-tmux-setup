# fd Cheatsheet

`fd` is a **fast file finder** — like the `find` command, but much faster and easier to use.
In this setup, it powers the `Ctrl+F` shortcut inside the sesh picker.

> Install: `brew install fd` (3MB)
> For the big picture: see [README.md](README.md)

---

## What fd Does in This Setup

When you press `Ctrl+F` inside the sesh picker, it runs:

```bash
fd -H -d 2 -t d -E .Trash . ~ ~/Library/CloudStorage/OneDrive-SAPSE
```

This scans your Mac and OneDrive for directories, so you can jump to any project — even ones
zoxide doesn't know about yet.

### Flag breakdown

| Flag / Part | Meaning |
|-------------|---------|
| `-H` | Include hidden directories (like `.git`, `.config`) |
| `-d 2` | Search only 2 levels deep |
| `-t d` | Find directories only (not files) |
| `-E .Trash` | Exclude the Trash folder |
| `.` | Search from the current directory |
| `~` | Also search your home directory |
| `~/Library/CloudStorage/OneDrive-SAPSE` | Also search OneDrive |

### Why two separate search roots?

OneDrive is 4 folders deep from `~`, so `fd -d 2 .` would never reach it.
By listing it as its own root, each path gets its own 2-level search:

```
Search 1:  ~ (depth 2)
           → ~/Downloads
           → ~/Desktop
           → ~/Documents

Search 2:  ~/Library/CloudStorage/OneDrive-SAPSE (depth 2)
           → ~/Library/CloudStorage/OneDrive-SAPSE/00_code2
           → ~/Library/CloudStorage/OneDrive-SAPSE/01_docs
```

---

## Using fd Directly (Outside Sesh)

You rarely need to run `fd` yourself — sesh handles it. But here's how it works if you want to:

```bash
# Find all directories named "config" under ~
fd -t d "config" ~

# Find all .lua files recursively
fd -e lua

# Find files containing "tmux" in their name
fd "tmux"

# Find files, depth 3, including hidden
fd -H -d 3 "project"
```

---

## Common Flags Reference

| Flag | What it does |
|------|-------------|
| `-t d` | Directories only |
| `-t f` | Files only |
| `-e lua` | Filter by extension (e.g., `.lua`) |
| `-H` | Include hidden (dot) files/dirs |
| `-d N` | Maximum search depth |
| `-E pattern` | Exclude matching names |
| `-x command` | Execute a command for each result |

---

## Quick Reference Card

```
# How sesh uses fd (Ctrl+F in the picker):
fd -H -d 2 -t d -E .Trash . ~ ~/Library/CloudStorage/OneDrive-SAPSE

# Find directories named "project"
fd -t d "project" ~

# Find all .md files
fd -e md

# Find files/dirs 3 levels deep including hidden
fd -H -d 3 "keyword"
```

---

## What's Next

See [fzf.md](fzf.md) — the fuzzy finder that powers both `zi` (zoxide interactive) and the sesh picker.
