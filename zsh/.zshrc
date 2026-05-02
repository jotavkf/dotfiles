if [[ $- == *i* ]]; then
  export ZELLIJ_CONFIG_DIR="$HOME/.config/zellij"

  source <(fzf --zsh)
  eval "$(zoxide init zsh)"
  eval "$(mise activate zsh)"
  eval "$(starship init zsh)"

  if [[ "$TERM" == "xterm-ghostty" ]]; then
    eval "$(zellij setup --generate-auto-start zsh)"
  fi
fi

alias lzd='lazydocker'
alias lzg='lazygit'
alias cd='z'
