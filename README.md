# Dotfiles

Personal macOS dotfiles and package setup.

## Install

```sh
./install.sh
```

The installer:

- installs Homebrew packages from `Brewfile` when `brew` is available
- sources zsh config from a managed block in `~/.zshrc`
- symlinks Ghostty config into `~/.config/ghostty/config`
- symlinks Zellij config into `~/.config/zellij/config.kdl`

## Layout

```text
Brewfile                  Homebrew formulae and casks
install.sh                Bootstrap script
zsh/.zshrc                Shell configuration sourced from ~/.zshrc
ghostty/config            Ghostty configuration
zellij/config.kdl         Zellij configuration
```

## Manual Package Install

```sh
brew bundle --file Brewfile
```
