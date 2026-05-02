#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSHRC="$HOME/.zshrc"
ZSH_SOURCE="$DOTFILES_DIR/zsh/.zshrc"
GHOSTTY_TARGET="$HOME/.config/ghostty/config"
GHOSTTY_SOURCE="$DOTFILES_DIR/ghostty/config"
ZELLIJ_TARGET="$HOME/.config/zellij/config.kdl"
ZELLIJ_SOURCE="$DOTFILES_DIR/zellij/config.kdl"

if command -v brew >/dev/null 2>&1; then
  brew bundle --file "$DOTFILES_DIR/Brewfile"
else
  printf 'Homebrew not found; skipping package install.\n'
fi

mkdir -p "$(dirname "$GHOSTTY_TARGET")" "$(dirname "$ZELLIJ_TARGET")"
ln -sfn "$ZSH_SOURCE" "$ZSHRC"
ln -sfn "$GHOSTTY_SOURCE" "$GHOSTTY_TARGET"
ln -sfn "$ZELLIJ_SOURCE" "$ZELLIJ_TARGET"

printf 'Dotfiles installed.\n'
