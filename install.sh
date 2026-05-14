#!/usr/bin/env bash

set -e

echo "Installing DX toolkit..."

OS="$(uname -s)"

install_macos() {
  echo "Detected macOS"
  if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Install it first: https://brew.sh/"
    exit 1
  fi
  echo "Installing packages via brew..."
  brew install bat eza ripgrep fd
}

install_linux() {
  echo "Detected Linux"
  if command -v apt &> /dev/null; then
    echo "Installing via apt..."
    sudo apt update
    sudo apt install -y ripgrep fd-find eza
    sudo apt install -y bat || true
  elif command -v pacman &> /dev/null; then
    echo "Installing via pacman..."
    sudo pacman -S --noconfirm bat eza ripgrep fd
  else
    echo "Unsupported package manager."
    exit 1
  fi
}

case "$OS" in
  Darwin) install_macos ;;
  Linux) install_linux ;;
  *) echo "Unsupported OS: $OS"; exit 1 ;;
esac

echo "Setting up Docker aliases..."

if command -v fish &> /dev/null; then
  echo "Configuring fish aliases..."
  fish -c "alias drmv 'docker rm -v'; funcsave drmv"
  fish -c "alias drm 'docker rm'; funcsave drm"
fi

if [ -f "$HOME/.bashrc" ]; then
  if ! grep -q "alias drm=" "$HOME/.bashrc"; then
    echo "Adding aliases to .bashrc"
    echo -e "\n# Docker aliases\nalias drm='docker rm'\nalias drmv='docker rm -v'" >> "$HOME/.bashrc"
  fi
fi

if [ -f "$HOME/.zshrc" ]; then
  if ! grep -q "alias drm=" "$HOME/.zshrc"; then
    echo "Adding aliases to .zshrc"
    echo -e "\n# Docker aliases\nalias drm='docker rm'\nalias drmv='docker rm -v'" >> "$HOME/.zshrc"
  fi
fi

echo "Installing fish functions from directory..."
FISH_DIR="$HOME/.config/fish/functions"
mkdir -p "$FISH_DIR"
if [ -d "functions" ]; then
    cp functions/*.fish "$FISH_DIR/" 2>/dev/null || true
fi

echo "Done"
echo "Restart your shell or run: source ~/.config/fish/config.fish (for fish)"