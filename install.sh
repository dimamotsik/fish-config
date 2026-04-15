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
    sudo apt install -y ripgrep fd-find

    if ! command -v bat &> /dev/null; then
      sudo apt install -y bat || true
    fi

  elif command -v pacman &> /dev/null; then
    echo "Installing via pacman..."
    sudo pacman -S --noconfirm bat eza ripgrep fd

  else
    echo "Unsupported package manager. Install manually: bat, eza, ripgrep, fd"
    exit 1
  fi
}

case "$OS" in
  Darwin)
    install_macos
    ;;
  Linux)
    install_linux
    ;;
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

echo "Installing fish functions..."

FISH_DIR="$HOME/.config/fish/functions"
mkdir -p "$FISH_DIR"

cp functions/*.fish "$FISH_DIR/"

echo "Done"
echo "Restart fish: exec fish"

echo "Verify install"

which bat
which eza
which rg
which fd
