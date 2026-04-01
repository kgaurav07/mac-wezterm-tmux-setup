#!/bin/bash
# =============================================================================
# mac-wezterm-tmux-setup — install.sh
# Sets up a complete Mac terminal environment:
#   WezTerm + tmux + sesh + zoxide + nvim + eza + starship + fd + fzf
#
# Usage:
#   git clone https://github.com/kgaurav07/mac-wezterm-tmux-setup
#   cd mac-wezterm-tmux-setup
#   ./install.sh
#
# Safe to run multiple times — skips already-installed tools, backs up
# existing configs before overwriting.
# =============================================================================

set -e

# Colours for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Colour

info()    { echo -e "${BLUE}[INFO]${NC}  $1"; }
success() { echo -e "${GREEN}[OK]${NC}    $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Where this script lives — configs/ is relative to it
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIGS_DIR="$REPO_DIR/configs"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"

echo ""
echo "============================================="
echo "  mac-wezterm-tmux-setup installer"
echo "  Repo: $REPO_DIR"
echo "  Home: $HOME"
echo "============================================="
echo ""

# -----------------------------------------------------------------------------
# 1. macOS check
# -----------------------------------------------------------------------------
if [[ "$(uname)" != "Darwin" ]]; then
  error "This setup is macOS-only (uses pbcopy, brew, WezTerm .app)."
fi
success "macOS detected"

# -----------------------------------------------------------------------------
# 2. Homebrew
# -----------------------------------------------------------------------------
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Add brew to PATH for the rest of this script
  eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || eval "$(/usr/local/bin/brew shellenv)" 2>/dev/null
  success "Homebrew installed"
else
  success "Homebrew already installed"
fi

# -----------------------------------------------------------------------------
# 3. CLI tools via brew
# -----------------------------------------------------------------------------
CLI_TOOLS=(tmux sesh zoxide fzf fd nvim eza starship lazygit)

info "Installing CLI tools (skipping already-installed)..."
for tool in "${CLI_TOOLS[@]}"; do
  if brew list "$tool" &>/dev/null; then
    success "  $tool — already installed"
  else
    info "  Installing $tool..."
    brew install "$tool"
    success "  $tool installed"
  fi
done

# -----------------------------------------------------------------------------
# 4. Cask apps (WezTerm + Nerd Font)
# -----------------------------------------------------------------------------
CASK_APPS=(wezterm font-lilex-nerd-font)

info "Installing cask apps (skipping already-installed)..."
for cask in "${CASK_APPS[@]}"; do
  if brew list --cask "$cask" &>/dev/null; then
    success "  $cask — already installed"
  else
    info "  Installing $cask..."
    brew install --cask "$cask"
    success "  $cask installed"
  fi
done

# -----------------------------------------------------------------------------
# 5. TPM — Tmux Plugin Manager
# -----------------------------------------------------------------------------
TPM_DIR="$HOME/.config/tmux/plugins/tpm"
if [[ -d "$TPM_DIR" ]]; then
  success "TPM already installed"
else
  info "Installing TPM (Tmux Plugin Manager)..."
  mkdir -p "$HOME/.config/tmux/plugins"
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
  success "TPM installed"
fi

# -----------------------------------------------------------------------------
# 6. Copy configs to ~/.config/
# Helper: copy_config <src_dir_or_file> <dest_dir_or_file>
#   - dest doesn't exist        → copy
#   - dest exists, same content → skip
#   - dest exists, different    → back up then copy
# -----------------------------------------------------------------------------
copy_config() {
  local src="$1"
  local dest="$2"

  if [[ ! -e "$src" ]]; then
    warn "Source not found, skipping: $src"
    return
  fi

  if [[ ! -e "$dest" ]]; then
    # Destination doesn't exist — just copy
    mkdir -p "$(dirname "$dest")"
    cp -r "$src" "$dest"
    success "Copied: $dest"
  else
    # Destination exists — check if different
    if diff -rq "$src" "$dest" &>/dev/null; then
      success "Already up to date: $dest"
    else
      local backup="${dest}.backup.${TIMESTAMP}"
      warn "Backing up existing: $dest → $backup"
      mv "$dest" "$backup"
      cp -r "$src" "$dest"
      success "Updated: $dest"
    fi
  fi
}

info "Copying configs to ~/.config/..."
mkdir -p "$HOME/.config"

copy_config "$CONFIGS_DIR/nvim"            "$HOME/.config/nvim"
copy_config "$CONFIGS_DIR/tmux/tmux.conf"  "$HOME/.config/tmux/tmux.conf"
copy_config "$CONFIGS_DIR/wezterm/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua"
mkdir -p "$HOME/.config/sesh"

# sesh.toml: only copy template if no personal config exists yet
if [[ -f "$HOME/.config/sesh/sesh.toml" ]]; then
  success "sesh.toml already exists — leaving your personal sessions untouched"
else
  cp "$CONFIGS_DIR/sesh/sesh.toml.template" "$HOME/.config/sesh/sesh.toml"
  success "Copied sesh.toml.template → ~/.config/sesh/sesh.toml (edit to add your projects)"
fi

# -----------------------------------------------------------------------------
# 7. ~/.zshrc additions (append only if not already present)
# -----------------------------------------------------------------------------
ZSHRC="$HOME/.zshrc"
touch "$ZSHRC"

append_if_missing() {
  local line="$1"
  local marker="$2"   # a unique string to search for (avoids partial matches)
  if grep -qF "$marker" "$ZSHRC" 2>/dev/null; then
    success "  Already in .zshrc: $marker"
  else
    echo "$line" >> "$ZSHRC"
    success "  Added to .zshrc: $marker"
  fi
}

info "Updating ~/.zshrc..."
append_if_missing 'eval "$(zoxide init zsh)"'    'zoxide init zsh'
append_if_missing 'eval "$(starship init zsh)"'  'starship init zsh'
append_if_missing 'export PATH'                  'export PATH'

# eza aliases block — add as a group if any are missing
if grep -q 'alias ls="eza' "$ZSHRC" 2>/dev/null; then
  success "  eza aliases already in .zshrc"
else
  cat >> "$ZSHRC" << 'EOF'

# eza (better ls)
alias l="eza --icons"
alias ls="eza --icons"
alias ll="eza -lg --icons"
alias la="eza -lag --icons"
alias lt="eza -lTg --icons"
alias lt1="eza -lTg --level=1 --icons"
alias lt2="eza -lTg --level=2 --icons"
alias lt3="eza -lTg --level=3 --icons"
alias lta="eza -lTag --icons"
alias lta1="eza -lTag --level=1 --icons"
alias lta2="eza -lTag --level=2 --icons"
alias lta3="eza -lTag --level=3 --icons"
EOF
  success "  eza aliases added to .zshrc"
fi

# -----------------------------------------------------------------------------
# 8. Done — print manual steps
# -----------------------------------------------------------------------------
echo ""
echo "============================================="
echo -e "${GREEN}  Installation complete!${NC}"
echo "============================================="
echo ""
echo "Manual steps remaining (cannot be automated):"
echo ""
echo "  1. Open WezTerm"
echo "     If it's not your default terminal yet, open it from Applications."
echo ""
echo "  2. Start tmux and install plugins:"
echo "     tmux"
echo "     Then press:  Ctrl+B  then  Shift+I"
echo "     Wait for 'Done' message, then press Escape."
echo ""
echo "  3. Open nvim — plugins install automatically on first launch:"
echo "     nvim ."
echo "     Wait for lazy.nvim to finish installing, then restart nvim."
echo ""
echo "  4. Reload your shell to activate zshrc changes:"
echo "     source ~/.zshrc"
echo ""
echo "  5. Edit your sesh sessions (optional):"
echo "     nvim ~/.config/sesh/sesh.toml"
echo "     Add your own project paths."
echo ""
echo "Docs: see mysetup/docs/ in this repo for cheatsheets on every tool."
echo ""
