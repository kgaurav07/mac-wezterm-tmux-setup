# fd Cheatsheet

`fd` is a **fast file finder** — like the `find` command, but much faster and easier to use.
In this setup, it powers the `Ctrl+F` shortcut inside the sesh picker.

> Install: `brew install fd` (3MB)
> For the big picture: see [README.md](README.md)

---

## What fd Does in This Setup

When you press `Ctrl+F` inside the sesh picker, it runs:

```bash
fd -H -d 2 -t d -E .Trash .
```

This scans your home directory for folders, so you can jump to any project — even ones
zoxide doesn't know about yet.

### Flag breakdown

| Flag / Part | Meaning |
|-------------|---------|
| `-H` | Include hidden directories (like `.git`, `.config`) |
| `-d 2` | Search only 2 levels deep |
| `-t d` | Find directories only (not files) |
| `-E .Trash` | Exclude the Trash folder |
| `.` | Search from home directory |

### Adding extra search roots

If your projects live deep in a cloud storage folder or external drive (more than 2 levels from `~`),
add it as an extra search root so it gets its own 2-level search:

```bash
fd -H -d 2 -t d -E .Trash . ~/my-cloud-drive
```

Each root is searched independently at depth 2 — so the extra path doesn't force you
to increase the global depth limit.

To make this permanent, edit `~/.config/tmux/tmux.conf` and update the `ctrl-f` bind line:

```bash
--bind 'ctrl-f:change-prompt(  )+reload(fd -H -d 2 -t d -E .Trash . ~/my-cloud-drive)'
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
fd -H -d 2 -t d -E .Trash .

# With an extra search root (e.g. cloud storage or external drive):
fd -H -d 2 -t d -E .Trash . ~/my-cloud-drive

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
