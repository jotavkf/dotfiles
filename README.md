# Dotfiles

Personal macOS dotfiles and package setup.

## Install

```sh
./install.sh
```

The installer:

- installs Homebrew packages from `Brewfile` when `brew` is available
- copies zsh config into a managed block in `~/.zshrc`
- copies Ghostty config into `~/.config/ghostty/config`
- copies Zellij config into `~/.config/zellij/config.kdl`
- backs up existing unmanaged app configs with a timestamp before replacing them

## Layout

```text
Brewfile                  Homebrew formulae and casks
install.sh                Bootstrap script
zsh/.zshrc                Shell configuration copied into ~/.zshrc
ghostty/.config/ghostty/config
zellij/.config/zellij/config.kdl
```

## Manual Package Install

```sh
brew bundle --file Brewfile
```
