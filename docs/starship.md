# Starship Cheatsheet

Starship is your **shell prompt** — the line that appears after every command, showing where you are
and context about your project. It replaces the default `$` prompt with something much more informative.

> Install: `brew install starship` (8.3MB)
> Add to `~/.zshrc`: `eval "$(starship init zsh)"`
> For the big picture: see [README.md](README.md)

---

## What the Prompt Looks Like

```
~/code/my-project on  main ✓  v20.11  took 2s
❯
```

Each part tells you something useful — without you having to type a single command.

---

## Reading the Prompt

| Part | Example | What it means |
|------|---------|--------------|
| Directory | `~/code/my-project` | Your current folder (shortened to 3 levels max) |
| Git branch | ` main` | The git branch you're on (branch icon before name) |
| Git status | `✓` | Clean — no uncommitted changes |
| Git status | `✗` | Has changes (modified, untracked, or staged files) |
| Node version | ` v20.11` | Detected from `package.json` in this folder |
| Duration | `took 2s` | How long the previous command took (only shown if > 2 seconds) |
| Prompt symbol | `❯` | Ready for input (green = last command succeeded, red = it failed) |

---

## Git Status Symbols

| Symbol | Meaning |
|--------|---------|
| `✓` | Working tree clean |
| `✗` | Has changes |
| `+N` | N staged files |
| `!N` | N modified (unstaged) files |
| `?N` | N untracked files |
| `⇡N` | N commits ahead of remote |
| `⇣N` | N commits behind remote |

---

## Language / Tool Detection

Starship auto-detects what kind of project you're in and shows the relevant tool version:

| What you see | Detected from |
|-------------|--------------|
| ` v20.11` | `package.json` or `.node-version` |
| ` 3.11.2` | `.python-version` or `pyproject.toml` |
| ` 1.75.0` | `Cargo.toml` |
| ` 21.0.1` | `pom.xml` or `build.gradle` |
| ` 1.21.0` | `go.mod` |
| ` v3.2.3` | Helm chart files |

The version only shows when you're inside a project of that type — it disappears in other directories.

---

## The Prompt Symbol Color

| Color | Meaning |
|-------|---------|
| Green `❯` | Last command succeeded (exit code 0) |
| Red `❯` | Last command failed (non-zero exit code) |

This is the fastest way to know if a command worked without reading its output.

---

## Customizing Starship

Starship is configured with `~/.config/starship.toml`.
You currently have no custom config, so you're using all the defaults — which already look great.

If you want to change something (hide a module, change colors, reorder sections):

```bash
# Create a config file (starship generates a starter)
starship preset plain-text > ~/.config/starship.toml
nvim ~/.config/starship.toml
```

Full docs: https://starship.rs/config/

---

## Quick Reference Card

```
~/my-project on  main ✓  v20.11  took 2s
❯

Prompt parts:
  ~/my-project       → current directory
   main             → git branch
  ✓                  → git status (clean)
  ✗                  → git status (has changes)
   v20.11           → Node.js version (auto-detected)
  took 2s            → previous command duration (if > 2s)
  ❯ green            → last command succeeded
  ❯ red              → last command failed

Config: ~/.config/starship.toml (optional — defaults work well)
```
