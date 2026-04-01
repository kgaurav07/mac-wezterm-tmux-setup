#!/bin/bash
# =============================================================================
# mac-wezterm-tmux-setup — uninstall-ubuntu.sh
# Removes everything installed by install.sh on Ubuntu.
#
# Usage (run from Lima or any Ubuntu machine):
#   curl -fsSL https://raw.githubusercontent.com/kgaurav07/mac-wezterm-tmux-setup/main/uninstall-ubuntu.sh | bash
#
# Purpose: clean-room reset so you can retest the install script from scratch
# without reprovisioning the VM.
#
# What is removed:
#   - ~/.config/nvim, tmux, wezterm, sesh
#   - ~/.local/share/nvim (lazy.nvim plugins, telescope build)
#   - ~/.local/state/nvim, ~/.cache/nvim
#   - /usr/local/bin: nvim, lazygit, sesh, starship
#   - ~/.local/bin: fd symlink, zoxide
#   - eza apt repo + package
#   - Lines added to ~/.zshrc by the install script
#
# What is NOT removed:
#   - tmux, fzf, curl, git, unzip, build-essential (system basics)
#   - zsh itself
#   - Any other system packages
# =============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC}  $1"; }
success() { echo -e "${GREEN}[OK]${NC}    $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $1"; }

# Guard: Ubuntu only
if [[ "$(uname)" != "Linux" ]] || ! command -v apt &>/dev/null; then
  echo -e "${RED}[ERROR]${NC} This script is for Ubuntu/Debian only."
  exit 1
fi

echo ""
echo "============================================="
echo "  mac-wezterm-tmux-setup — uninstaller"
echo "  Ubuntu clean-room reset"
echo "  Home: $HOME"
echo "============================================="
echo ""
echo -e "${YELLOW}This will remove:${NC}"
echo "  ~/.config/nvim  ~/.config/tmux  ~/.config/wezterm  ~/.config/sesh"
echo "  ~/.local/share/nvim  ~/.local/state/nvim  ~/.cache/nvim"
echo "  /usr/local/bin/nvim  /usr/local/bin/lazygit  /usr/local/bin/sesh  /usr/local/bin/starship"
echo "  ~/.local/bin/fd  ~/.local/bin/zoxide"
echo "  eza package + apt repo"
echo "  Lines added to ~/.zshrc by install script"
echo ""
read -r -p "Are you sure? [y/N] " confirm
if [[ ! "$confirm" =~ ^[yY]$ ]]; then
  echo "Aborted."
  exit 0
fi
echo ""

# -----------------------------------------------------------------------------
# 1. Remove config directories
# -----------------------------------------------------------------------------
info "Removing ~/.config directories..."
for dir in nvim tmux wezterm sesh; do
  if [[ -d "$HOME/.config/$dir" ]]; then
    rm -rf "$HOME/.config/$dir"
    success "  Removed ~/.config/$dir"
  else
    info "  ~/.config/$dir — not found, skipping"
  fi
done

# -----------------------------------------------------------------------------
# 2. Remove nvim data/state/cache
# -----------------------------------------------------------------------------
info "Removing nvim data, state, and cache..."
for path in \
  "$HOME/.local/share/nvim" \
  "$HOME/.local/state/nvim" \
  "$HOME/.cache/nvim"; do
  if [[ -d "$path" ]]; then
    rm -rf "$path"
    success "  Removed $path"
  else
    info "  $path — not found, skipping"
  fi
done

# -----------------------------------------------------------------------------
# 3. Remove binaries from /usr/local/bin
# -----------------------------------------------------------------------------
info "Removing binaries from /usr/local/bin..."
for bin in nvim lazygit sesh starship; do
  if [[ -f "/usr/local/bin/$bin" ]]; then
    sudo rm -f "/usr/local/bin/$bin"
    success "  Removed /usr/local/bin/$bin"
  else
    info "  /usr/local/bin/$bin — not found, skipping"
  fi
done

# -----------------------------------------------------------------------------
# 4. Remove ~/.local/bin entries
# -----------------------------------------------------------------------------
info "Removing ~/.local/bin entries..."
for entry in fd zoxide; do
  if [[ -e "$HOME/.local/bin/$entry" ]]; then
    rm -f "$HOME/.local/bin/$entry"
    success "  Removed ~/.local/bin/$entry"
  else
    info "  ~/.local/bin/$entry — not found, skipping"
  fi
done

# -----------------------------------------------------------------------------
# 5. Remove eza apt repo and package
# -----------------------------------------------------------------------------
info "Removing eza..."
if dpkg -s eza &>/dev/null 2>&1; then
  sudo apt remove -y eza
  success "  eza package removed"
else
  info "  eza — not installed via apt, skipping"
fi

for f in \
  /etc/apt/sources.list.d/gierens.list \
  /etc/apt/keyrings/gierens.gpg; do
  if [[ -f "$f" ]]; then
    sudo rm -f "$f"
    success "  Removed $f"
  fi
done

# -----------------------------------------------------------------------------
# 6. Remove lines added to ~/.zshrc
# -----------------------------------------------------------------------------
ZSHRC="$HOME/.zshrc"

if [[ ! -f "$ZSHRC" ]]; then
  info ".zshrc not found — nothing to clean"
else
  info "Cleaning ~/.zshrc..."

  # Patterns added by the install script
  PATTERNS=(
    'zoxide init zsh'
    'starship init zsh'
    '.local/bin'
    'XDG_DATA_HOME'
    'XDG_CACHE_HOME'
    'XDG_CONFIG_HOME'
    'XDG_STATE_HOME'
    '# eza (better ls)'
    'alias l="eza'
    'alias ls="eza'
    'alias ll="eza'
    'alias la="eza'
    'alias lt="eza'
    'alias lt1="eza'
    'alias lt2="eza'
    'alias lt3="eza'
    'alias lta='
    'alias lta1='
    'alias lta2='
    'alias lta3='
  )

  ZSHRC_BACKUP="${ZSHRC}.backup.$(date +%Y%m%d_%H%M%S)"
  cp "$ZSHRC" "$ZSHRC_BACKUP"
  info "  Backed up .zshrc → $ZSHRC_BACKUP"

  ORIGINAL_LINES=$(wc -l < "$ZSHRC")
  for pattern in "${PATTERNS[@]}"; do
    sed -i "\|${pattern}|d" "$ZSHRC"
  done
  # Remove blank lines left at end of file
  sed -i -e '/^[[:space:]]*$/{ /./!d; }' "$ZSHRC" 2>/dev/null || true
  NEW_LINES=$(wc -l < "$ZSHRC")
  REMOVED=$((ORIGINAL_LINES - NEW_LINES))
  success "  Removed $REMOVED line(s) from ~/.zshrc"
fi

# -----------------------------------------------------------------------------
# 7. Post-uninstall validation
# -----------------------------------------------------------------------------
echo ""
echo "============================================="
echo "  Post-uninstall validation"
echo "============================================="

WARN_COUNT=0

check_gone_binary() {
  local name="$1"
  local cmd="$2"
  if command -v "$cmd" &>/dev/null 2>&1; then
    echo -e "${YELLOW}[STILL PRESENT]${NC} $name — $(which "$cmd")"
    WARN_COUNT=$((WARN_COUNT + 1))
  else
    echo -e "${GREEN}[GONE]${NC}  $name"
  fi
}

check_gone_path() {
  local label="$1"
  local path="$2"
  if [[ -e "$path" ]]; then
    echo -e "${YELLOW}[STILL PRESENT]${NC} $label — $path"
    WARN_COUNT=$((WARN_COUNT + 1))
  else
    echo -e "${GREEN}[GONE]${NC}  $label"
  fi
}

check_zshrc_clean() {
  local label="$1"
  local marker="$2"
  if grep -qF "$marker" "$ZSHRC" 2>/dev/null; then
    echo -e "${YELLOW}[STILL PRESENT]${NC} .zshrc: $label"
    WARN_COUNT=$((WARN_COUNT + 1))
  else
    echo -e "${GREEN}[GONE]${NC}  .zshrc: $label"
  fi
}

# Binaries
check_gone_binary "nvim"      nvim
check_gone_binary "lazygit"   lazygit
check_gone_binary "sesh"      sesh
check_gone_binary "starship"  starship
check_gone_binary "eza"       eza
check_gone_binary "zoxide"    zoxide

# Paths
check_gone_path "~/.config/nvim"          "$HOME/.config/nvim"
check_gone_path "~/.config/tmux"          "$HOME/.config/tmux"
check_gone_path "~/.config/sesh"          "$HOME/.config/sesh"
check_gone_path "~/.local/share/nvim"     "$HOME/.local/share/nvim"
check_gone_path "~/.local/bin/fd"         "$HOME/.local/bin/fd"
check_gone_path "~/.local/bin/zoxide"     "$HOME/.local/bin/zoxide"
check_gone_path "eza apt keyring"         "/etc/apt/keyrings/gierens.gpg"
check_gone_path "eza apt source"          "/etc/apt/sources.list.d/gierens.list"

# .zshrc cleanliness
check_zshrc_clean "zoxide init"           "zoxide init zsh"
check_zshrc_clean "starship init"         "starship init zsh"
check_zshrc_clean "eza aliases"           'alias ls="eza'
check_zshrc_clean "XDG vars"              "XDG_DATA_HOME"

echo ""
if [[ $WARN_COUNT -eq 0 ]]; then
  echo -e "${GREEN}  Clean. Ready to reinstall.${NC}"
  echo ""
  echo "  Run install:"
  echo "  curl -fsSL https://raw.githubusercontent.com/kgaurav07/mac-wezterm-tmux-setup/main/install.sh | bash"
else
  echo -e "${YELLOW}  $WARN_COUNT item(s) still present — review above.${NC}"
fi
echo ""
