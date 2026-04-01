# fzf Cheatsheet

`fzf` is a **fuzzy finder** — type a few letters and it narrows down a list in real time.
It's the search popup you see inside the sesh picker and when you run `zi`.

> Install: `brew install fzf` (4.8MB)
> For the big picture: see [README.md](README.md)

---

## What fzf Does in This Setup

fzf is the engine behind two key features:

| Where | How fzf appears |
|-------|----------------|
| **Sesh picker** (`Ctrl+B T`) | The fuzzy popup that lets you search and jump to sessions/projects |
| **Zoxide `zi`** | The interactive directory picker that filters as you type |
| **`cd **<Tab>`** | The shell completion picker for browsing any directory |

You're already using fzf every time you open the sesh picker — it's what makes the search feel instant.

---

## Using fzf Directly

You can pipe any list of text through fzf to get an interactive picker:

```bash
# Pick a file to open in nvim
nvim $(fzf)

# Pick a git branch to switch to
git branch | fzf | xargs git checkout

# Pick a running process to kill
ps aux | fzf | awk '{print $2}' | xargs kill
```

---

## Navigating Inside fzf

These controls work everywhere fzf appears (sesh picker, zi, cd **TAB):

| Key | Action |
|-----|--------|
| Type letters | Narrow results — fuzzy match, spaces mean "AND" |
| `↑` / `↓` | Move up/down |
| `Ctrl+P` / `Ctrl+N` | Also move up/down |
| `Enter` | Select the highlighted item |
| `Escape` or `Ctrl+C` | Cancel |
| `Tab` | Move down (in sesh picker — custom binding) |
| `Shift+Tab` | Move up (in sesh picker — custom binding) |

### Fuzzy matching tips

```
cis         → matches "03_CIS", "CIS_project", "francisc"
code tmux   → matches paths containing both "code" and "tmux"
'exact      → single quote = exact match for "exact"
^start      → caret = must start with "start"
end$        → dollar = must end with "end"
!skip       → exclamation = NOT matching "skip"
```

---

## The Sesh Picker Uses fzf-tmux

The sesh popup uses `fzf-tmux` (a tmux-aware version of fzf) so the picker appears as a
floating window centered on your terminal instead of taking over the full screen.

The picker has extra key bindings on top of standard fzf — see [sesh.md](sesh.md) for those.

---

## Quick Reference Card

```
# Use fzf to pick a file
nvim $(fzf)

# Use fzf to pick from any command output
any-command | fzf

# Inside any fzf popup:
  Type           → filter results
  ↑/↓            → navigate
  Enter          → select
  Escape         → cancel
  Space          → "AND" (both words must match)
  'word          → exact match
  ^word          → starts with
  word$          → ends with
  !word          → not matching
```

---

## What's Next

See [eza.md](eza.md) — the enhanced `ls` that shows file icons and colors.
