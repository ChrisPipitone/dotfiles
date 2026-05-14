#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

# --- Detect OS / environment ---
OS="$(uname)"
IS_WSL=false
if [[ "$OS" == "Linux" ]] && grep -qi microsoft /proc/version 2>/dev/null; then
  IS_WSL=true
fi

info()    { echo "[+] $*"; }
success() { echo "[✓] $*"; }
warn()    { echo "[!] $*"; }

# --- Detect Linux package manager ---
pkg_mgr() {
  if command -v apt-get &>/dev/null; then echo "apt"
  elif command -v pacman &>/dev/null; then echo "pacman"
  elif command -v dnf &>/dev/null; then echo "dnf"
  else echo "unknown"
  fi
}

install_pkg() {
  case "$(pkg_mgr)" in
    apt)    sudo apt-get install -y "$@" ;;
    pacman) sudo pacman -S --noconfirm "$@" ;;
    dnf)    sudo dnf install -y "$@" ;;
    *)      warn "Unknown package manager — install manually: $*"; return 1 ;;
  esac
}

# --- Sanity check: repo location ---
if [[ "$DOTFILES_DIR" == "$HOME" ]] || \
   ( [[ "$DOTFILES_DIR" == "$HOME/"* ]] && \
     [[ "$DOTFILES_DIR" != "$HOME/dotfiles" && "$DOTFILES_DIR" != "$HOME/.dotfiles" ]] ); then
  echo "Error: dotfiles repo at '$DOTFILES_DIR' conflicts with stow target \$HOME."
  echo "  Move to ~/dotfiles or ~/.dotfiles first."
  exit 1
fi

# --- Ensure git ---
if ! command -v git &>/dev/null; then
  info "Installing git..."
  if [[ "$OS" == "Darwin" ]]; then
    echo "Install Xcode Command Line Tools first: xcode-select --install"
    exit 1
  else
    install_pkg git
  fi
fi

# --- Mac: ensure Homebrew ---
if [[ "$OS" == "Darwin" ]] && ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Add brew to PATH (Apple Silicon vs Intel)
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
fi

# --- Ensure stow ---
if ! command -v stow &>/dev/null; then
  info "Installing stow..."
  if [[ "$OS" == "Darwin" ]]; then
    brew install stow
  else
    install_pkg stow
  fi
fi

# --- Linux: install core packages ---
if [[ "$OS" == "Linux" ]]; then
  info "Installing core packages..."
  MGR="$(pkg_mgr)"

  case "$MGR" in
    apt)
      sudo apt-get update -qq
      install_pkg fzf ripgrep tmux

      # lsd: in apt on Ubuntu 22.04+
      install_pkg lsd 2>/dev/null || {
        warn "lsd not in apt — installing via cargo..."
        if ! command -v cargo &>/dev/null; then
          curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path
          source "$HOME/.cargo/env"
        fi
        cargo install lsd
      }

      # fd: named fd-find in apt; symlink to fd
      install_pkg fd-find 2>/dev/null && {
        mkdir -p "$HOME/.local/bin"
        ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
      } || install_pkg fd 2>/dev/null || true

      # neovim: apt version is often stale — prefer PPA on Ubuntu/Debian
      if command -v add-apt-repository &>/dev/null; then
        sudo add-apt-repository -y ppa:neovim-ppa/unstable 2>/dev/null || true
        sudo apt-get update -qq
      fi
      install_pkg neovim || warn "neovim install failed — install manually"
      ;;

    pacman)
      sudo pacman -S --noconfirm fzf ripgrep tmux neovim lsd fd lazygit
      ;;

    dnf)
      sudo dnf install -y fzf ripgrep tmux neovim lsd fd-find
      ;;
  esac

  # Starship (no universal apt package — use official installer)
  if ! command -v starship &>/dev/null; then
    info "Installing starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
  fi

  if $IS_WSL; then
    warn "WSL detected: clipboard (tmux-yank) needs win32yank — install from https://github.com/equalsraf/win32yank"
  fi
fi

# --- Backup existing real files that would conflict with stow ---
stow_safe() {
  local pkg="$1"
  # --simulate 2>&1 prints conflicts to stderr in the form:
  #   * existing target is not owned by stow: .zshrc
  local conflicts
  conflicts=$(stow -d "$DOTFILES_DIR" -t "$HOME" --simulate "$pkg" 2>&1 || true)

  while IFS= read -r line; do
    local file
    file=$(echo "$line" | grep "existing target is not owned by stow:" | sed 's/.*stow: //' | xargs) || continue
    [[ -z "$file" ]] && continue
    local src="$HOME/$file"
    if [[ -e "$src" && ! -L "$src" ]]; then
      local dest="$BACKUP_DIR/$file"
      mkdir -p "$(dirname "$dest")"
      info "Backing up: $src → $dest"
      mv "$src" "$dest"
    fi
  done <<< "$conflicts"

  stow -d "$DOTFILES_DIR" -t "$HOME" "$pkg"
  success "Stowed $pkg"
}

# --- Stow packages ---
info "Stowing common configs..."
stow_safe common

if [[ "$OS" == "Darwin" ]] && [[ -d "$DOTFILES_DIR/mac" ]]; then
  info "Stowing mac configs..."
  stow_safe mac
  if command -v brew &>/dev/null && [[ -f "$HOME/.Brewfile" ]]; then
    info "Installing Homebrew packages..."
    brew bundle --global
  fi
elif [[ "$OS" == "Linux" ]] && [[ -d "$DOTFILES_DIR/linux" ]]; then
  info "Stowing linux configs..."
  stow_safe linux
fi

# --- Mac: set default theme ---
if [[ "$OS" == "Darwin" ]]; then
  THEME_FILE="$HOME/.config/theme.name"
  if [[ ! -f "$THEME_FILE" ]]; then
    info "Setting default Mac theme to matte-black..."
    mkdir -p "$HOME/.config"
    echo "matte-black" > "$THEME_FILE"
  else
    success "Mac theme: $(cat "$THEME_FILE")"
  fi
fi

# --- TPM ---
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
  info "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
  success "TPM already installed"
fi

# --- Summary ---
echo ""
[[ -d "$BACKUP_DIR" ]] && warn "Pre-existing configs backed up to: $BACKUP_DIR"
success "Done."
echo ""
echo "Next steps:"
echo "  1. Restart shell or: source ~/.zshrc"
echo "  2. tmux: prefix + I  → install plugins"
echo "  3. nvim: :Lazy sync  → :MasonInstallAll"
$IS_WSL && echo "  4. WSL: install win32yank for clipboard support"
echo ""
