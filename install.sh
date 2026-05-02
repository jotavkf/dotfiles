#!/usr/bin/env bash
set -euo pipefail

trap 'status=$?; if [ $status -ne 0 ]; then printf "\n  \033[31m[𝘅] Dotfiles setup failed\033[0m\n"; fi; exit $status' EXIT

reset="\033[0m"
dim="\033[2m"
green="\033[32m"
yellow="\033[33m"
bold="$(tput bold 2>/dev/null || true)"
normal="$(tput sgr0 2>/dev/null || true)"
dot="\033[31m▸ ${reset}"
count=1

print_in_green() {
  printf "%b  [✓] %s%b\n" "$green" "$1" "$reset"
}

print_success_muted() {
  printf "  %b[✓] %s%b\n" "$dim" "$1" "$reset"
}

print_warning() {
  printf "%b  [!] %s%b\n" "$yellow" "$1" "$reset"
}

step() {
  printf "\n %b%s%b\n" "$dot" "$1" "$reset"
}

chapter() {
  printf "\n✦  %b%s. %s%b\n└─────────────────────────────────────────────────────○\n" "$bold" "$((count++))" "$1" "$normal"
}

show_intro() {
  local colors=('\033[38;5;226m' '\033[38;5;227m' '\033[38;5;228m' '\033[38;5;229m' '\033[38;5;230m' '\033[38;5;222m' '\033[38;5;221m')
  local i=0

  printf "\n"
  while IFS= read -r line; do
    printf "%b%s%b\n" "${colors[$((i % ${#colors[@]}))]}" "$line" "$reset"
    i=$((i + 1))
  done <<'EOF'
  ██████╗   ██████╗  ████████╗ ███████╗ ██╗ ██╗      ███████╗ ███████╗
  ██╔══██╗ ██╔═══██╗ ╚══██╔══╝ ██╔════╝ ██║ ██║      ██╔════╝ ██╔════╝
  ██║  ██║ ██║   ██║    ██║    █████╗   ██║ ██║      █████╗   ███████╗
  ██║  ██║ ██║   ██║    ██║    ██╔══╝   ██║ ██║      ██╔══╝   ╚════██║
  ██████╔╝ ╚██████╔╝    ██║    ██║      ██║ ███████╗ ███████╗ ███████║
  ╚═════╝   ╚═════╝     ╚═╝    ╚═╝      ╚═╝ ╚══════╝ ╚══════╝ ╚══════╝
EOF

  printf "\nWelcome to Dotfiles!\n"
  printf "This turns a macOS machine into your configured development setup.\n"
  printf "It is safe to rerun and keeps config files linked to this repository.\n"
  printf "You can cancel at any time by pressing ctrl+c.\n"
}

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSHRC="$HOME/.zshrc"
ZSH_SOURCE="$DOTFILES_DIR/zsh/.zshrc"
GHOSTTY_TARGET="$HOME/.config/ghostty/config"
GHOSTTY_SOURCE="$DOTFILES_DIR/ghostty/config"
MISE_TARGET="$HOME/.config/mise/config.toml"
MISE_SOURCE="$DOTFILES_DIR/mise/config.toml"
ZELLIJ_TARGET="$HOME/.config/zellij/config.kdl"
ZELLIJ_SOURCE="$DOTFILES_DIR/zellij/config.kdl"
CURSOR_TARGET="$HOME/Library/Application Support/Cursor/User/settings.json"
CURSOR_SOURCE="$DOTFILES_DIR/cursor/settings.json"

show_intro

chapter "Checking macOS developer tools…"

if ! xcode-select -p >/dev/null 2>&1; then
  print_warning "macOS developer tools not found; starting installer. Re-run this script after it finishes."
  xcode-select --install
  exit 1
else
  print_success_muted "Command-line tools already installed. Skipping"
fi

chapter "Installing Homebrew packages…"

if command -v brew >/dev/null 2>&1; then
  step "Installing packages from Brewfile"
  printf -- "\n--------------------------------------------------------\n"
  brew bundle --file "$DOTFILES_DIR/Brewfile"
  printf -- "--------------------------------------------------------\n"
  print_in_green "Homebrew packages installed!"
else
  print_warning "Homebrew not found; skipping package install."
fi

chapter "Setting up Git…"

git_name="${GIT_USER_NAME:-$(git config --global --get user.name || true)}"
git_email="${GIT_USER_EMAIL:-$(git config --global --get user.email || true)}"

if [[ "$git_name" == -* ]]; then
  print_warning "Ignoring invalid Git user.name: $git_name"
  git_name=""
fi

if [[ "$git_email" == -* ]]; then
  print_warning "Ignoring invalid Git user.email: $git_email"
  git_email=""
fi

if [ -z "$git_name" ] && [ -t 0 ]; then
  printf '  [?] Git user.name: '
  read -r git_name
fi

if [ -z "$git_email" ] && [ -t 0 ]; then
  printf '  [?] Git user.email: '
  read -r git_email
fi

if [ -n "$git_name" ]; then
  git config --global user.name "$git_name"
  print_success_muted "Git name set to: $git_name"
else
  print_warning "Git user.name not set; skipping."
fi

if [ -n "$git_email" ]; then
  git config --global user.email "$git_email"
  print_success_muted "Git email set to: $git_email"
else
  print_warning "Git user.email not set; skipping."
fi

git config --global pull.rebase true
git config --global core.editor nano
print_in_green "Git setup completed!"

chapter "Linking configuration files…"

step "Creating configuration directories"
mkdir -p "$(dirname "$GHOSTTY_TARGET")" "$(dirname "$MISE_TARGET")" "$(dirname "$ZELLIJ_TARGET")" "$(dirname "$CURSOR_TARGET")"

step "Linking shell, terminal, editor, and tool configs"
ln -sfn "$ZSH_SOURCE" "$ZSHRC"
print_success_muted "Linked zsh configuration"
ln -sfn "$GHOSTTY_SOURCE" "$GHOSTTY_TARGET"
print_success_muted "Linked Ghostty configuration"
ln -sfn "$MISE_SOURCE" "$MISE_TARGET"
print_success_muted "Linked mise configuration"
ln -sfn "$ZELLIJ_SOURCE" "$ZELLIJ_TARGET"
print_success_muted "Linked Zellij configuration"
ln -sfn "$CURSOR_SOURCE" "$CURSOR_TARGET"
print_success_muted "Linked Cursor settings"

chapter "Setting up development tools…"

if command -v mise >/dev/null 2>&1; then
  print_success_muted "mise detected"
  step "Trusting mise configuration"
  mise trust "$MISE_SOURCE"
  step "Installing configured tools"
  mise install
  print_in_green "Development tools installed!"
else
  print_warning "mise not found; skipping tool install."
fi

chapter "Setup complete!"
print_in_green "Your Mac is now ready to use!"
print_success_muted "You may need to restart open apps for all changes to take effect."
