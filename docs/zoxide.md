# Zoxide Cheatsheet

Zoxide is a **smarter `cd`** command. It remembers every directory you visit,
so over time you can jump anywhere with just a few letters instead of typing the full path.

> Think of it like browser history, but for your terminal directories.

---

## The Basics — Start Here

| Command | What it does | Example |
|---------|-------------|---------|
| `z foo` | Jump to the best matching directory | `z dotfiles` → jumps to your dotfiles folder |
| `z foo bar` | Match a path containing **both** words | `z code proj` → jumps to ~/code/my-project |
| `zi` | **Interactive** picker — fuzzy search all known dirs | Arrow keys to pick, Enter to jump |
| `zi foo` | Interactive picker pre-filtered for "foo" | |
| `cd some/path` | Normal cd — zoxide silently learns this path | Use `cd` as normal, zoxide remembers it |

> **Important:** Zoxide starts empty. It learns as you `cd` around. The more you use it, the smarter it gets.

---

## Navigating the `zi` Interactive Picker

When you run `zi` you get a fuzzy search popup:

| Key | Action |
|-----|--------|
| Type letters | Narrow down results |
| `↑` / `↓` | Move up/down through the list |
| `Ctrl+P` / `Ctrl+N` | Also move up/down |
| `Enter` | Jump to highlighted directory |
| `Escape` or `Ctrl+C` | Cancel, stay where you are |

The number on the left (e.g. `8.0`) is the **score** — higher means you've visited it more recently and more often.

**What does `3/3` or `1/23` mean?**
- The right number (23) = total directories zoxide knows
- The left number (1) = your cursor position in the filtered results
- As you type, the list narrows and both numbers change

**The bottom bar** (e.g. `01_KG_on_HANA/`) shows shell tab completions for the highlighted path — it is NOT a drill-down navigator. You cannot arrow into it.

---

## Browsing Unvisited Directories

> **Key distinction:**
> - `z` / `zi` = jump to places you've **already visited** (zoxide only knows these)
> - `cd **<TAB>` = browse **anywhere**, even places you've never been

### Browse any folder interactively (fzf required — already installed)

```bash
cd **<TAB>
```

Type `cd ` then `**` then press `Tab`. fzf opens and shows everything on your system.
Type to filter (e.g. `CIS`) → arrow keys to pick → `Enter` to jump.

### See subdirectories of a known path (text list only, not interactive)

```bash
z cis <SPACE><TAB>
```

Shows a text list of subfolders inside the matched CIS directory.
To jump to one, type its name directly:

```bash
z cis Fortescue
```

But this only works if you've visited that subfolder before.
If `zoxide: no match found` — use `cd **<TAB>` instead.

---



Zoxide learns automatically when you use `cd`. But you can also add directories manually:

```bash
# Add a single directory manually
zoxide add ~/Downloads

# Add multiple directories at once
zoxide add ~/Downloads ~/Documents ~/Desktop

# Add a project folder
zoxide add ~/path/to/my-project
```

> To quickly teach zoxide your important spots right now:
> ```bash
> zoxide add ~/Downloads ~/Desktop ~/Documents
> ```

---

## Viewing What Zoxide Knows

```bash
# List all directories zoxide has learned
zoxide query --list

# List all directories WITH their scores
zoxide query --list --score

# Search for a specific keyword in the list
zoxide query --list code

# Show ALL entries including directories that no longer exist on disk
zoxide query --all --list
```

---

## Deleting / Removing Locations

```bash
# Remove a specific directory from zoxide's memory
zoxide remove /full/path/to/directory

# Remove multiple directories at once
zoxide remove /path/one /path/two

# To find and remove directories that no longer exist on disk:
zoxide query --all --list        # Step 1: see everything including dead paths
zoxide remove /the/dead/path     # Step 2: remove it by the exact path shown
```

> Removing from zoxide does NOT delete the actual folder — it just removes it from zoxide's memory.

---

## How the Scoring Works

Every directory has a **frecency score** — a mix of frequency (how often) and recency (how recently).

| Last visited | Score multiplier |
|-------------|-----------------|
| Within last hour | × 4 (very fresh) |
| Within last day | × 2 |
| Within last week | ÷ 2 |
| Older than a week | ÷ 4 (fading) |

So a directory you visited 5 minutes ago beats one you visited 100 times last month.

**To manually boost a directory's score** (run it multiple times):
```bash
zoxide add ~/path/to/important-project
zoxide add ~/path/to/important-project
zoxide add ~/path/to/important-project
```

---

## Useful One-Liners

```bash
# See all your directories ranked by score
zoxide query --list --score

# Interactive picker that also shows deleted/missing directories
zoxide query --all --interactive

# Jump to previous directory (like cd -)
z -

# Go home
z ~
```

---

## Exclude a Directory (Stop Zoxide Learning It)

Add this to your `~/.zshrc` before the `zoxide init` line:

```bash
export _ZO_EXCLUDE_DIRS="$HOME/private/**:$HOME/tmp/**"
```

Multiple paths separated by `:`. Supports glob patterns.

---

## Useful Settings (add to ~/.zshrc before `zoxide init zsh`)

| Setting | What it does | Example |
|---------|-------------|---------|
| `export _ZO_ECHO=1` | Print the matched path before jumping | Good for learning |
| `export _ZO_MAXAGE=10000` | Max number of directories remembered (default 10000) | Lower = smaller DB |
| `export _ZO_EXCLUDE_DIRS="$HOME"` | Never track these directories | |

---

## Quick Reference Card

```
z foo            → jump to best match for "foo"
z foo bar        → jump to match containing both words
zi               → interactive fuzzy picker (all dirs)
zi foo           → interactive fuzzy picker filtered for "foo"

zoxide add <path>          → manually add a directory
zoxide remove <path>       → remove a directory from memory
zoxide query --list        → show all known directories
zoxide query --list --score  → show all with scores
zoxide query --all --list  → show all including deleted
```

---

## What's Next (Phase 2)

Next up: **tmux** — the tool that keeps your terminal sessions alive even if WezTerm closes.
It's what makes `sesh` (session jumping) possible.

See: `mysetup/tmux.md` (created after Phase 2)
