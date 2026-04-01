# Sesh Cheatsheet

Sesh is a **session picker** that sits on top of tmux.
Press `Ctrl+B T` and get a fuzzy search popup to jump to any project instantly.

> Config file: `~/.config/sesh/sesh.toml`
> For the big picture: see [README.md](README.md)

---

## Opening the Picker

```
Ctrl+B  T
```

---

## What the Picker Shows

```
─── Active tmux sessions ───
  main
  03_CIS

─── Zoxide directories ───        ← dirs you've visited before
  ~/Library/.../00_code2
  ~/Library/.../03_CIS

─── Configured sessions ───       ← from sesh.toml
  nvim config
  tmux config
```

---

## Picker Controls (inside the popup)

| Key | What it shows |
|-----|--------------|
| `Ctrl+A` | Everything combined (default) |
| `Ctrl+T` | Active tmux sessions only |
| `Ctrl+G` | Configured sessions from sesh.toml only |
| `Ctrl+X` | Zoxide directories only |
| `Ctrl+F` | Find ANY directory on disk (fd search) |
| `Ctrl+D` | Kill the highlighted session |
| `Tab` / `Shift+Tab` | Move down / up |
| `Enter` | Jump to selected |
| `Escape` | Close picker, stay where you are |

---

## What Happens When You Pick Something

Sesh creates a **new tmux session** for that project and switches you into it.
Your previous session keeps running in the background — nothing is lost.

```
Before:  main (attached)
After:   main (detached, still running)
         03_CIS (attached ← you are here)
```

Use `Ctrl+B L` to instantly toggle back to your previous session.

---

## Ctrl+F — Find Any Directory

`Ctrl+F` uses `fd` to search your filesystem. The command it runs:

```bash
fd -H -d 2 -t d -E .Trash .
```

| Part | Meaning |
|------|---------|
| `-H` | Include hidden directories |
| `-d 2` | Only 2 levels deep from each search root |
| `-t d` | Directories only (not files) |
| `-E .Trash` | Exclude Trash |
| `.` | Search from home directory |

> You can add extra search roots for deep locations (e.g. external drives, cloud storage folders).
> Add them as additional paths after `.` — each gets its own 2-level search independently.

> `fd` must be installed: `brew install fd` (3MB)

---

## Configuring Your Own Sessions (sesh.toml)

Add frequently used projects so they always appear in the picker under `Ctrl+G`:

```toml
[[session]]
name = "my-project"
path = "~/path/to/project"
startup_command = "nvim ."
```

File location: `~/.config/sesh/sesh.toml`
(copied from `configs/sesh/sesh.toml.template` in the repo by `install.sh`)

Current configured sessions:
- **Downloads** — `~/Downloads`, runs `ls`
- **tmux config** — `~/.config/tmux`, opens `tmux.conf` in nvim
- **nvim config** — `~/.config/nvim`, opens nvim
- **sesh config** — `~/.config/sesh`, opens `sesh.toml` in nvim

---

## Zoxide + Sesh = the full power

The more you `cd` and `z` around your projects, the more zoxide learns.
Sesh surfaces all those learned directories under `Ctrl+X`.

Over time `Ctrl+X` becomes your complete project list — no configuration needed.

---

## Quick Reference Card

```
Ctrl+B  T           → open sesh picker
Ctrl+B  L           → toggle to last session (fastest way back)

Inside picker:
  Ctrl+A            → show everything
  Ctrl+T            → tmux sessions only
  Ctrl+X            → zoxide dirs only
  Ctrl+G            → configured sessions (sesh.toml)
  Ctrl+F            → find any dir on disk
  Ctrl+D            → kill highlighted session
  Enter             → jump to selection
  Escape            → close picker
```

---

## What's Next (Phase 4)

Next up: **nvim** — the editor. Open it with `nvim .` inside any project session.

See: [nvim.md](nvim.md)
