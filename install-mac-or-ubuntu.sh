#!/bin/bash
# =============================================================================
# mac-wezterm-tmux-setup — install-mac-or-ubuntu.sh
# Sets up a complete terminal environment on macOS OR Ubuntu.
#
# macOS:  WezTerm + tmux + sesh + zoxide + nvim + eza + starship + fd + fzf + lazygit
# Ubuntu: tmux + sesh + zoxide + nvim + eza + starship + fd + fzf + lazygit
#         (WezTerm and fonts are skipped — GUI tools, install separately on host)
#
# Usage:
#   git clone https://github.com/kgaurav07/mac-wezterm-tmux-setup
#   cd mac-wezterm-tmux-setup
#   chmod +x install-mac-or-ubuntu.sh
#   ./install-mac-or-ubuntu.sh
#
# Safe to run multiple times — skips already-installed tools, backs up
# existing configs before overwriting.
# =============================================================================

set -e

# -----------------------------------------------------------------------------
# Colours
# -----------------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC}  $1"; }
success() { echo -e "${GREEN}[OK]${NC}    $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

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
# 1. Detect OS and environment
# -----------------------------------------------------------------------------
OS=""
IS_HEADLESS=false

if [[ "$(uname)" == "Darwin" ]]; then
  OS="macos"
  success "Detected: macOS"
elif [[ "$(uname)" == "Linux" ]]; then
  # Check for Ubuntu/Debian
  if command -v apt &>/dev/null; then
    OS="ubuntu"
    success "Detected: Ubuntu/Debian Linux"
    # Headless = no DISPLAY and no WAYLAND_DISPLAY (e.g. Lima VM, SSH)
    if [[ -z "${DISPLAY}" && -z "${WAYLAND_DISPLAY}" ]]; then
      IS_HEADLESS=true
      info "Headless environment detected (no display) — skipping GUI tools"
    fi
  else
    error "Unsupported Linux distro. This script supports Ubuntu/Debian only."
  fi
else
  error "Unsupported OS: $(uname)"
fi

# -----------------------------------------------------------------------------
# 2. Install packages
# -----------------------------------------------------------------------------

# --- macOS: use Homebrew ---
if [[ "$OS" == "macos" ]]; then
  if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || eval "$(/usr/local/bin/brew shellenv)" 2>/dev/null
    success "Homebrew installed"
  else
    success "Homebrew already installed"
  fi

  CLI_TOOLS=(tmux sesh zoxide fzf fd nvim eza starship lazygit)
  info "Installing CLI tools..."
  for tool in "${CLI_TOOLS[@]}"; do
    if brew list "$tool" &>/dev/null; then
      success "  $tool — already installed"
    else
      info "  Installing $tool..."
      brew install "$tool"
      success "  $tool installed"
    fi
  done

  if [[ "$IS_HEADLESS" == false ]]; then
    info "Installing GUI apps (WezTerm + Nerd Font)..."
    for cask in wezterm font-lilex-nerd-font; do
      if brew list --cask "$cask" &>/dev/null; then
        success "  $cask — already installed"
      else
        info "  Installing $cask..."
        brew install --cask "$cask"
        success "  $cask installed"
      fi
    done
  fi
fi

# --- Ubuntu: use apt + targeted installers ---
if [[ "$OS" == "ubuntu" ]]; then
  info "Updating apt..."
  sudo apt update -qq

  # Core tools available in apt
  APT_TOOLS=(tmux fzf curl git unzip)
  info "Installing apt packages..."
  for tool in "${APT_TOOLS[@]}"; do
    if dpkg -s "$tool" &>/dev/null 2>&1; then
      success "  $tool — already installed"
    else
      sudo apt install -y "$tool"
      success "  $tool installed"
    fi
  done

  # fd — packaged as fd-find on Ubuntu, binary is fdfind
  if command -v fdfind &>/dev/null || command -v fd &>/dev/null; then
    success "  fd — already installed"
  else
    info "  Installing fd-find..."
    sudo apt install -y fd-find
    # Create fd alias so scripts work as expected
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(which fdfind)" "$HOME/.local/bin/fd"
    success "  fd installed (aliased fdfind → fd)"
  fi

  # nvim — snap gives the latest stable version
  if command -v nvim &>/dev/null; then
    success "  nvim — already installed"
  else
    info "  Installing nvim via snap..."
    sudo snap install nvim --classic
    success "  nvim installed"
  fi

  # zoxide — official install script
  if command -v zoxide &>/dev/null; then
    success "  zoxide — already installed"
  else
    info "  Installing zoxide..."
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    success "  zoxide installed"
  fi

  # eza — via Homebrew on Linux (most reliable) or cargo
  if command -v eza &>/dev/null; then
    success "  eza — already installed"
  else
    # Try Homebrew on Linux first, fall back to cargo
    if command -v brew &>/dev/null; then
      info "  Installing eza via Homebrew..."
      brew install eza
    elif command -v cargo &>/dev/null; then
      info "  Installing eza via cargo..."
      cargo install eza
    else
      warn "  eza: neither Homebrew nor cargo found. Install manually: cargo install eza"
    fi
    command -v eza &>/dev/null && success "  eza installed"
  fi

  # starship — official install script
  if command -v starship &>/dev/null; then
    success "  starship — already installed"
  else
    info "  Installing starship..."
    curl -sSfL https://starship.rs/install.sh | sh -s -- --yes
    success "  starship installed"
  fi

  # sesh — via Homebrew on Linux or go install
  if command -v sesh &>/dev/null; then
    success "  sesh — already installed"
  else
    if command -v brew &>/dev/null; then
      info "  Installing sesh via Homebrew..."
      brew install sesh
      success "  sesh installed"
    elif command -v go &>/dev/null; then
      info "  Installing sesh via go..."
      go install github.com/joshmedeski/sesh/v2@latest
      success "  sesh installed"
    else
      warn "  sesh: install Homebrew (https://brew.sh) or Go, then run: brew install sesh"
    fi
  fi

  # lazygit — official install
  if command -v lazygit &>/dev/null; then
    success "  lazygit — already installed"
  else
    info "  Installing lazygit..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name"' | sed 's/.*"v\([^"]*\)".*/\1/')
    curl -sSfL "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" | tar -xz -C /tmp lazygit
    sudo install /tmp/lazygit /usr/local/bin
    success "  lazygit installed"
  fi
fi

# -----------------------------------------------------------------------------
# 3. TPM — Tmux Plugin Manager
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
# 4. Copy configs to ~/.config/
# -----------------------------------------------------------------------------
copy_config() {
  local src="$1"
  local dest="$2"

  if [[ ! -e "$src" ]]; then
    warn "Source not found, skipping: $src"
    return
  fi

  if [[ ! -e "$dest" ]]; then
    mkdir -p "$(dirname "$dest")"
    cp -r "$src" "$dest"
    success "Copied: $dest"
  else
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

copy_config "$CONFIGS_DIR/nvim"                   "$HOME/.config/nvim"
copy_config "$CONFIGS_DIR/tmux/tmux.conf"         "$HOME/.config/tmux/tmux.conf"
copy_config "$CONFIGS_DIR/wezterm/wezterm.lua"     "$HOME/.config/wezterm/wezterm.lua"
mkdir -p "$HOME/.config/sesh"

if [[ -f "$HOME/.config/sesh/sesh.toml" ]]; then
  success "sesh.toml already exists — leaving your personal sessions untouched"
else
  cp "$CONFIGS_DIR/sesh/sesh.toml.template" "$HOME/.config/sesh/sesh.toml"
  success "Copied sesh.toml.template → ~/.config/sesh/sesh.toml"
fi

# -----------------------------------------------------------------------------
# 5. Patch tmux.conf clipboard command for Ubuntu
#    macOS uses pbcopy; Ubuntu uses xclip (X11) or wl-copy (Wayland)
# -----------------------------------------------------------------------------
TMUX_CONF="$HOME/.config/tmux/tmux.conf"

if [[ "$OS" == "ubuntu" ]]; then
  if [[ -n "${WAYLAND_DISPLAY}" ]]; then
    CLIPBOARD_CMD="wl-copy"
    if ! command -v wl-copy &>/dev/null; then
      info "Installing wl-clipboard for Wayland..."
      sudo apt install -y wl-clipboard
    fi
  else
    CLIPBOARD_CMD="xclip -selection clipboard"
    if ! command -v xclip &>/dev/null; then
      info "Installing xclip for X11..."
      sudo apt install -y xclip
    fi
  fi

  # Replace pbcopy with the appropriate clipboard command
  if grep -q "pbcopy" "$TMUX_CONF"; then
    sed -i "s|pbcopy|$CLIPBOARD_CMD|g" "$TMUX_CONF"
    success "tmux.conf: replaced pbcopy → $CLIPBOARD_CMD"
  fi
fi

# -----------------------------------------------------------------------------
# 6. ~/.zshrc additions
# -----------------------------------------------------------------------------
ZSHRC="$HOME/.zshrc"
touch "$ZSHRC"

append_if_missing() {
  local line="$1"
  local marker="$2"
  if grep -qF "$marker" "$ZSHRC" 2>/dev/null; then
    success "  Already in .zshrc: $marker"
  else
    echo "$line" >> "$ZSHRC"
    success "  Added to .zshrc: $marker"
  fi
}

info "Updating ~/.zshrc..."
append_if_missing 'eval "$(zoxide init zsh)"'   'zoxide init zsh'
append_if_missing 'eval "$(starship init zsh)"' 'starship init zsh'
append_if_missing 'export PATH'                 'export PATH'

# Add ~/.local/bin to PATH on Ubuntu (needed for fd alias, zoxide, starship)
if [[ "$OS" == "ubuntu" ]]; then
  append_if_missing 'export PATH="$HOME/.local/bin:$PATH"' '.local/bin'
fi

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
# 7. Print manual steps
# -----------------------------------------------------------------------------
echo ""
echo "============================================="
echo -e "${GREEN}  Installation complete!${NC}"
echo "  OS: $OS$([ "$IS_HEADLESS" = true ] && echo " (headless)")"
echo "============================================="
echo ""
echo "Manual steps remaining:"
echo ""

if [[ "$OS" == "macos" ]]; then
  echo "  1. Open WezTerm from Applications"
  echo ""
fi

echo "  $([ "$OS" == "macos" ] && echo 2 || echo 1). Start tmux and install plugins:"
echo "     tmux"
echo "     Then press:  Ctrl+B  then  Shift+I"
echo "     Wait for 'Done', then press Escape."
echo ""
echo "  $([ "$OS" == "macos" ] && echo 3 || echo 2). Open nvim — plugins install automatically:"
echo "     nvim ."
echo "     Wait for lazy.nvim to finish, then restart nvim."
echo ""
echo "  $([ "$OS" == "macos" ] && echo 4 || echo 3). Reload your shell:"
echo "     source ~/.zshrc"
echo ""
echo "  $([ "$OS" == "macos" ] && echo 5 || echo 4). Edit your sesh sessions:"
echo "     nvim ~/.config/sesh/sesh.toml"
echo ""

if [[ "$OS" == "ubuntu" && "$IS_HEADLESS" == true ]]; then
  echo "  Note: WezTerm and fonts are not installed in headless mode."
  echo "  Install WezTerm on your host Mac — it connects to this environment via tmux."
  echo ""
fi

echo "Docs: see docs/ in this repo for cheatsheets on every tool."
echo ""
