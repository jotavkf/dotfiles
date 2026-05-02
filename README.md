# Dotfiles

Personal macOS dotfiles and package setup.

## Install

```sh
./install.sh
```

The installer:

- checks that macOS developer tools are installed
- installs Homebrew packages from `Brewfile` when `brew` is available
- configures Git name, email, pull rebase, and nano as the commit editor
- symlinks zsh config into `~/.zshrc`
- symlinks Ghostty config into `~/.config/ghostty/config`
- symlinks Mise config into `~/.config/mise/config.toml` and installs configured tools
- symlinks Zellij config into `~/.config/zellij/config.kdl`

Git name and email can be provided non-interactively:

```sh
GIT_USER_NAME="Your Name" GIT_USER_EMAIL="you@example.com" ./install.sh
```

## Layout

```text
Brewfile                  Homebrew formulae and casks
install.sh                Bootstrap script
zsh/.zshrc                Shell configuration
ghostty/config            Ghostty configuration
mise/config.toml          Mise tool versions
zellij/config.kdl         Zellij configuration
```

## Manual Package Install

```sh
brew bundle --file Brewfile
```
