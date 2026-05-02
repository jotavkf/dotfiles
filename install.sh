#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSHRC="$HOME/.zshrc"
ZSH_SOURCE="$DOTFILES_DIR/zsh/.zshrc"
START_MARKER="# >>> dotfiles setup >>>"
END_MARKER="# <<< dotfiles setup <<<"
GHOSTTY_TARGET="$HOME/.config/ghostty/config"
GHOSTTY_SOURCE="$DOTFILES_DIR/ghostty/config"
ZELLIJ_TARGET="$HOME/.config/zellij/config.kdl"
ZELLIJ_SOURCE="$DOTFILES_DIR/zellij/config.kdl"

if command -v brew >/dev/null 2>&1; then
  brew bundle --file "$DOTFILES_DIR/Brewfile"
else
  printf 'Homebrew not found; skipping package install.\n'
fi

touch "$ZSHRC"

tmp_zshrc="$(mktemp)"
in_dotfiles_block=0

while IFS= read -r line || [ -n "$line" ]; do
  if [ "$line" = "$START_MARKER" ]; then
    in_dotfiles_block=1
    continue
  fi

  if [ "$line" = "$END_MARKER" ]; then
    in_dotfiles_block=0
    continue
  fi

  if [ "$in_dotfiles_block" -eq 0 ]; then
    printf '%s\n' "$line" >> "$tmp_zshrc"
  fi
done < "$ZSHRC"

{
  if [ -s "$tmp_zshrc" ]; then
    printf '\n'
  fi

  printf '%s\n' "$START_MARKER"
  printf 'source %q\n' "$ZSH_SOURCE"
  printf '%s\n' "$END_MARKER"
} >> "$tmp_zshrc"

mv "$tmp_zshrc" "$ZSHRC"

mkdir -p "$(dirname "$GHOSTTY_TARGET")" "$(dirname "$ZELLIJ_TARGET")"
ln -sfn "$GHOSTTY_SOURCE" "$GHOSTTY_TARGET"
ln -sfn "$ZELLIJ_SOURCE" "$ZELLIJ_TARGET"

printf 'Dotfiles installed.\n'
