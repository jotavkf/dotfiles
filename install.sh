#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSHRC="$HOME/.zshrc"
ZSH_SOURCE="$DOTFILES_DIR/zsh/.zshrc"
GHOSTTY_TARGET="$HOME/.config/ghostty/config"
GHOSTTY_SOURCE="$DOTFILES_DIR/ghostty/config"
MISE_TARGET="$HOME/.config/mise/config.toml"
MISE_SOURCE="$DOTFILES_DIR/mise/config.toml"
ZELLIJ_TARGET="$HOME/.config/zellij/config.kdl"
ZELLIJ_SOURCE="$DOTFILES_DIR/zellij/config.kdl"

if ! xcode-select -p >/dev/null 2>&1; then
  printf 'macOS developer tools not found; starting installer. Re-run this script after it finishes.\n'
  xcode-select --install
  exit 1
fi

if command -v brew >/dev/null 2>&1; then
  brew bundle --file "$DOTFILES_DIR/Brewfile"
else
  printf 'Homebrew not found; skipping package install.\n'
fi

git_name="${GIT_USER_NAME:-$(git config --global user.name || true)}"
git_email="${GIT_USER_EMAIL:-$(git config --global user.email || true)}"

if [ -z "$git_name" ] && [ -t 0 ]; then
  printf 'Git user.name: '
  read -r git_name
fi

if [ -z "$git_email" ] && [ -t 0 ]; then
  printf 'Git user.email: '
  read -r git_email
fi

if [ -n "$git_name" ]; then
  git config --global user.name "$git_name"
else
  printf 'Git user.name not set; skipping.\n'
fi

if [ -n "$git_email" ]; then
  git config --global user.email "$git_email"
else
  printf 'Git user.email not set; skipping.\n'
fi

git config --global pull.rebase true
git config --global core.editor nano

mkdir -p "$(dirname "$GHOSTTY_TARGET")" "$(dirname "$MISE_TARGET")" "$(dirname "$ZELLIJ_TARGET")"
ln -sfn "$ZSH_SOURCE" "$ZSHRC"
ln -sfn "$GHOSTTY_SOURCE" "$GHOSTTY_TARGET"
ln -sfn "$MISE_SOURCE" "$MISE_TARGET"
ln -sfn "$ZELLIJ_SOURCE" "$ZELLIJ_TARGET"

if command -v mise >/dev/null 2>&1; then
  mise trust "$MISE_SOURCE"
  mise install
else
  printf 'mise not found; skipping tool install.\n'
fi

printf 'Dotfiles installed.\n'
