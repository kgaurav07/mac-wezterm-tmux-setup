# Tmux Cheatsheet

Tmux is a **terminal session manager** that runs inside WezTerm.
Its killer feature: sessions keep running even if WezTerm closes or crashes.
Reopen WezTerm → `tmux attach` → everything is exactly where you left it.

> Config file: `~/.config/tmux/tmux.conf`
> For the big picture of how tmux fits in: see [README.md](README.md)

---

## The Prefix Key

**Every tmux command starts with `Ctrl+B`.**

This is a **sequence**, not a chord. Do it in this exact order:
1. Hold `Ctrl`, tap `B`, then **release both**
2. Wait a tiny moment
3. Press the next key **on its own** — no Ctrl, no modifiers

> The most common mistake: holding `Ctrl` down while pressing the second key. That does NOT work.

**Alternative: right-click** inside any tmux pane to get a menu with split options — useful when you're unsure about the key sequence.

---

## Starting and Stopping

| Command | Action |
|---------|--------|
| `tmux` | Start a new tmux session |
| `tmux attach` | Re-attach to last session after detaching |
| `tmux ls` | List all running sessions |
| `tmux new -s myproject` | Start a new session with a name |
| `Ctrl+B` then `d` | **Detach** — leave tmux (session keeps running in background) |

---

## Switching Sessions

| Keys | Action |
|------|--------|
| `Ctrl+B` then `T` | **Open sesh picker** — fuzzy jump to any session or project |
| `Ctrl+B` then `L` | **Last session** — toggle between your last two sessions |
| `Ctrl+B` then `$` | Rename current session |

> **What happens when you pick a folder in sesh (`Ctrl+B T`):**
> Sesh creates a **new tmux session** for that project and switches you into it.
> Your previous session does NOT vanish — it keeps running in the background.
> ```
> Before:  main (attached)
> After:   main (detached, still running)
>          03_CIS (attached ← you are here)
> ```
> Use `Ctrl+B L` to instantly toggle back to your previous session.
> Use `Ctrl+B T` again to pick any session from the list.

> **To close a session you no longer need:**
> ```bash
> tmux kill-session -t 03_CIS
> ```
> Or inside the sesh picker (`Ctrl+B T`), highlight it and press `Ctrl+D`.

---

## Pane Splits

A **pane** is a split section of your terminal screen within a session.

| Keys | Action |
|------|--------|
| `Ctrl+B` then `/` | Split pane **left/right** (side by side) |
| `Ctrl+B` then `v` | Split pane **top/bottom** |
| `Ctrl+B` then `x` | **Kill** current pane |
| `Ctrl+B` then `m` | **Maximize** / restore current pane (toggle) |

> Note: these are custom bindings in your config — NOT tmux defaults.
> Default tmux uses `%` and `"` but yours uses `/` and `v`.

---

## Moving Between Panes

With `vim-tmux-navigator` installed (it is), you can move between panes using:

| Keys | Action |
|------|--------|
| `Ctrl+H` | Move to pane on the **left** |
| `Ctrl+J` | Move to pane **below** |
| `Ctrl+K` | Move to pane **above** |
| `Ctrl+L` | Move to pane on the **right** |

---

## Resizing Panes

| Keys | Action |
|------|--------|
| `Ctrl+B` then `←` | Resize pane left |
| `Ctrl+B` then `→` | Resize pane right |
| `Ctrl+B` then `↑` | Resize pane up |
| `Ctrl+B` then `↓` | Resize pane down |

---

## Copy Mode (scrolling and copying text)

Normal arrow keys just cycle through previous commands — they do NOT scroll output.
To scroll you need copy mode, OR use the trackpad (mouse scroll works directly).

**Enter copy mode:** `Ctrl+B` then `V` (capital V — custom binding)

### Navigating in copy mode

| Key | Action |
|-----|--------|
| `↑` / `↓` | Scroll one line at a time |
| `Ctrl+U` | Scroll up half page |
| `Ctrl+D` | Scroll down half page |
| `g` | Jump to very top (oldest output) |
| `G` | Jump to very bottom (newest output) |
| `/` | Search forward |
| `?` | Search backward |
| `n` | Next search result |
| `q` or `Escape` | Exit copy mode |

### Selecting and copying text

| Key | Action |
|-----|--------|
| `v` | Start character-by-character selection |
| `Shift+V` | Select whole line |
| `y` | Copy selection → Mac clipboard (paste with `Cmd+V` anywhere) |

> Real world use: command output scrolled past, you need to copy an error message →
> `Ctrl+B V` → scroll up → `Shift+V` → `y` → paste into Slack/email.

> Copied text goes straight to your Mac clipboard via `pbcopy`.

---

## Understanding the Status Bar

### Top bar (pane border)

```
09:41 [34/34]                    [0/31]
```

| Element | Meaning |
|---------|---------|
| `09:41` | Current time |
| `[34/34]` | Scroll position — at line 34 of 34 = you're at the bottom |
| `[0/31]` | Other pane — 0 lines from bottom, 31 lines of history above |
| `> zsh` | Active pane (green border + `>` marker) |
| `  zsh` | Inactive pane (grey border, no marker) |

> When you scroll up in copy mode, the left number changes — e.g. `[10/34]` means 10 lines from the bottom.

### Bottom status bar

```
main » 0 0    |    0:[tmux]*    |    HQFHJH7K7Y « 10:20:17  01-Apr-26
```

| Element | Meaning |
|---------|---------|
| `main` | Your current **session name** |
| `0 0` | Window number, pane number |
| `0:[tmux]*` | Window 0 named `tmux`, `*` = currently active window |
| `HQFHJH7K7Y` | Your Mac hostname |
| `10:20:17` | Current time |
| `01-Apr-26` | Today's date |

---

## Renaming Sessions

Good names matter once you have multiple projects running.

```bash
# From outside tmux
tmux rename-session -t main myproject

# From inside tmux
Ctrl+B then $
```

---

## The tmux Command Prompt

`Ctrl+B` then `:` opens a command line at the bottom of tmux.
You can type any tmux command directly — useful for things not bound to a key.

```
Ctrl+B :  then type:  rename-session myproject
Ctrl+B :  then type:  setw synchronize-panes on
```

---

## Synchronized Panes

Run the same command in ALL panes at the same time.
Useful when you want to run identical commands across multiple terminals.

```
Ctrl+B : setw synchronize-panes on    ← turn on
Ctrl+B : setw synchronize-panes off   ← turn off
```

---

## Level 2 Features (learn later)

You don't need these now — come back once sesh and nvim feel comfortable:

| Feature | What it is |
|---------|-----------|
| **tmux windows** | A layer between sessions and panes — like tabs inside a session. Most people skip this and use sessions instead. |
| **tmux scripting** | Shell scripts that auto-create sessions, panes, run commands on startup — e.g. auto-open editor + server + logs for a project. |
| **Custom layouts** | Pre-defined pane arrangements (even split, main-left, tiled) you can switch to with one command. |

---



| Keys | Action |
|------|--------|
| `Ctrl+B` then `r` | **Reload tmux config** — apply changes to tmux.conf without restart |

---

## Attach and Detach — Real Scenarios

Think of tmux like a **TV running in a background room**:
- **Attach** = walking into the room and watching the TV
- **Detach** = leaving the room — the TV keeps playing
- **WezTerm closing** = you left the house — TV still playing
- **Reboot** = power cut — TV turns off

### Scenario 1 — You close WezTerm accidentally
```
Claude Code running in tmux
↓
You close WezTerm window
↓
tmux session keeps running in background ✅
↓
Reopen WezTerm → tmux attach
↓
Claude Code exactly where you left it ✅
```

### Scenario 2 — You detach manually
```
Claude Code running in tmux
↓
Ctrl+B d  (detach) — back at normal shell, tmux invisible but running
↓
tmux attach
↓
Claude Code exactly where you left it ✅
```
> This is the intended daily workflow — detach when switching context, attach to come back.

### Scenario 3 — You reboot your Mac
```
Claude Code running in tmux
↓
Reboot
↓
tmux process is KILLED — everything in memory is gone ❌
↓
tmux starts fresh, continuum restores session layout
BUT Claude Code process is gone — just an empty shell ⚠️
```
> What continuum **saves**: directory, pane layout, session name.
> What continuum **does NOT save**: running processes, command output, screen contents.

### Scenario 4 — SSH to a remote server (tmux's killer feature)
```
SSH into server → start tmux → start long running job
↓
Your internet drops / laptop closes
↓
SSH disconnects BUT tmux on the server keeps running ✅
↓
SSH back in → tmux attach
↓
Job still running, all output still there ✅
```

### Scenario 5 — Mac reboot with VM (OrbStack/Lima) + Claude Code

```
Mac reboots
↓
OrbStack/Lima VM stops (it's a process on your Mac)
↓
VM restarts when OrbStack starts back up
↓
tmux inside VM is GONE (killed when VM stopped)
↓
tmux-continuum restores the session layout
(empty shell in the right directory, but no running process)
```

When you SSH back in:
- ✅ tmux session exists (continuum restored layout)
- ✅ You're in the right directory
- ❌ Claude Code process is gone
- ❌ Screen output is gone

**But Claude's Restore feature saves you:**

```
SSH back in → tmux attach
↓
type: claude
↓
Claude asks: "Restore previous session? (Y/n)"
↓
Press Y
↓
Full conversation history restored ✅
Context of what you were working on ✅
Claude continues where it left off ✅
```

> What IS lost: any output mid-run when VM stopped.
> What is NOT lost: the conversation, files Claude created/edited, your work.

### Complete survival table (with VM + Claude)

| Event | tmux | Claude process | Claude conversation |
|-------|------|---------------|-------------------|
| Close WezTerm | ✅ | ✅ | ✅ |
| Detach (`Ctrl+B d`) | ✅ | ✅ | ✅ |
| Mac sleep / wake | ✅ | ✅ | ✅ |
| Mac reboot | ❌ layout only | ❌ | ✅ via Restore |
| VM restart | ❌ layout only | ❌ | ✅ via Restore |
| SSH disconnect | ✅ | ✅ | ✅ |

> A reboot is a minor interruption, not a disaster. `claude` → `Y` to restore and you're back within seconds.

---





Your tmux is configured with **tmux-continuum** and **tmux-resurrect**:
- Sessions **auto-save** every 15 minutes
- Sessions **auto-restore** when you restart tmux (that's why many sessions appeared!)

To manually save: `Ctrl+B` then `Ctrl+S`
To manually restore: `Ctrl+B` then `Ctrl+R`

---

## First Time Plugin Install

If plugins aren't working, press this **once** inside tmux:

```
Ctrl+B then Shift+I
```

Wait for the "Done" message, then press `Escape`.
This installs: vim-tmux-navigator, tmux-resurrect, tmux-continuum, and others.

---

## Sesh PATH Fix

If sesh shows `zoxide: executable not found`, tmux doesn't know where zoxide is.
Fix it by running this once:

```bash
tmux set-environment -g PATH "$PATH"
```

Then reload config: `Ctrl+B` then `r`

---

## Quick Reference Card

```
# Outside tmux
tmux                        → start tmux
tmux attach                 → re-attach after detaching
tmux ls                     → list all sessions
tmux new -s myproject       → new named session
tmux rename-session -t old new → rename session

# Inside tmux (all start with Ctrl+B)
Ctrl+B  d             → detach (session keeps running)
Ctrl+B  T             → sesh picker  ← jump to any project
Ctrl+B  L             → last session (toggle between 2)
Ctrl+B  $             → rename current session
Ctrl+B  :             → open tmux command prompt

Ctrl+B  /             → split left/right
Ctrl+B  v             → split top/bottom
Ctrl+B  x             → kill pane
Ctrl+B  m             → maximize/restore pane

Ctrl+H/J/K/L          → move between panes (no prefix needed)

Ctrl+B  V             → enter copy mode (scroll + copy)
  ↑/↓  Ctrl+U/D       → scroll in copy mode
  Shift+V             → select line
  y                   → copy to clipboard
  q / Escape          → exit copy mode

Ctrl+B  r             → reload config
Ctrl+B  Shift+I       → install plugins (first time only)
Ctrl+B  Ctrl+S        → manually save session state
Ctrl+B  Ctrl+R        → manually restore session state
```

---

## What's Next (Phase 3)

Next: **sesh** — the session picker that ties zoxide + tmux together.
Press `Ctrl+B T` inside tmux to open it.

See: `mysetup/sesh.md` (created after Phase 3)
