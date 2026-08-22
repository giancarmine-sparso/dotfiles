#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

PACKAGES=(
  git
  curl
  stow
  zsh
  neovim
  vim
  tmux
  kitty
  zathura
  ripgrep
  fd
  fzf
  shellcheck
  tree
  atuin
  zoxide
  delta
  eza
  fastfetch
  btop
)

STOW_PACKAGES=(
  atuin
  kitty
  nvim
  vim
  zathura
  zsh
)

detect_package_manager() {
  if command -v dnf >/dev/null 2>&1; then
    PACKAGE_MANAGER="dnf"
  elif command -v apt-get >/dev/null 2>&1; then
    PACKAGE_MANAGER="apt"
  elif command -v pacman >/dev/null 2>&1; then
    PACKAGE_MANAGER="pacman"
  elif command -v zypper >/dev/null 2>&1; then
    PACKAGE_MANAGER="zypper"
  elif command -v apk >/dev/null 2>&1; then
    PACKAGE_MANAGER="apk"
  else
    echo "Error: unsupported package manager." >&2
    exit 1
  fi
}

package_name() {
  local package="$1"

  case "$PACKAGE_MANAGER:$package" in
  dnf:vim) echo "vim-enhanced" ;;
  dnf:fd) echo "fd-find" ;;
  dnf:shellcheck) echo "ShellCheck" ;;
  dnf:delta) echo "git-delta" ;;

  apt:fd) echo "fd-find" ;;
  apt:delta) echo "git-delta" ;;

  pacman:delta) echo "git-delta" ;;

  zypper:delta) echo "git-delta" ;;

  *)
    echo "$package"
    ;;
  esac
}

install_system_packages() {
  local packages=()
  local package

  for package in "${PACKAGES[@]}"; do
    packages+=("$(package_name "$package")")
  done

  echo "==> Installing system packages with $PACKAGE_MANAGER..."

  case "$PACKAGE_MANAGER" in
  dnf)
    sudo dnf install -y "${packages[@]}"
    ;;

  apt)
    sudo apt-get update
    sudo apt-get install -y "${packages[@]}"
    ;;

  pacman)
    sudo pacman -S --needed --noconfirm "${packages[@]}"
    ;;

  zypper)
    sudo zypper install -y "${packages[@]}"
    ;;

  apk)
    sudo apk add "${packages[@]}"
    ;;

  *)
    echo "Error: unsupported package manager: $PACKAGE_MANAGER" >&2
    exit 1
    ;;
  esac
}

install_python_tools() {
  export PATH="$HOME/.local/bin:$PATH"

  if ! command -v uv >/dev/null 2>&1; then
    echo "==> Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
  fi

  if ! command -v ruff >/dev/null 2>&1; then
    echo "==> Installing ruff..."
    uv tool install ruff
  fi
}

install_rust() {
  export PATH="$HOME/.cargo/bin:$PATH"

  if ! command -v cargo >/dev/null 2>&1; then
    echo "==> Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs |
      sh -s -- -y
  fi
}

stow_dotfiles() {
  cd "$DOTFILES_DIR"

  stow --restow --target="$HOME" "${STOW_PACKAGES[@]}"
  stow --restow --no-folding --target="$HOME" tmux
}

#tmux
install_tmux_plugins() {
  local tpm_dir="$HOME/.config/tmux/plugins/tpm"

  if [[ ! -d "$tpm_dir" ]]; then
    echo "==> Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
  fi

  echo "==> Installing tmux plugins..."
  "$tpm_dir/bin/install_plugins"
}

#zsh come shell principale
setup_zsh() {
  local zsh_path

  zsh_path="$(command -v zsh)"

  if [[ "$SHELL" == "$zsh_path" ]]; then
    echo "==> Zsh is already the default shell."
    return
  fi

  echo "==> Setting Zsh as the default shell..."

  if ! grep -qxF "$zsh_path" /etc/shells; then
    echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
  fi

  chsh -s "$zsh_path"
}

#config autoamtica nvim
setup_neovim() {
  echo "==> Setting up Neovim..."

  if [[ ! -f "$HOME/.config/nvim/init.lua" ]]; then
    echo "Error: Neovim configuration not found." >&2
    return 1
  fi

  nvim --headless "+Lazy! sync" +qa
}

check_stow_conflicts() {
  echo "==> Checking for Stow conflicts..."

  cd "$DOTFILES_DIR"

  if ! stow --simulate --restow --target="$HOME" "${STOW_PACKAGES[@]}"; then
    echo "Error: Stow conflicts detected." >&2
    echo "Resolve the conflicts above before running the bootstrap again." >&2
    return 1
  fi

  if ! stow --simulate --restow --no-folding --target="$HOME" tmux; then
    echo "Error: Stow conflicts detected for tmux." >&2
    echo "Resolve the conflicts above before running the bootstrap again." >&2
    return 1
  fi

  echo "==> No Stow conflicts found."
}
# Main

detect_package_manager
install_system_packages
setup_zsh
install_rust
install_python_tools

check_stow_conflicts
stow_dotfiles

setup_neovim
install_tmux_plugins

echo "==> Bootstrap complete."
echo "==> Log out and back in for shell changes to take effect."
