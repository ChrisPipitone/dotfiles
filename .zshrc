# pywal theme for terminal colors
cat ~/.cache/wal/sequences && clear

# vim mode
bindkey -v

# work - aws ssh kitty terminal issue
export TERM=xterm-256color

alias config='nvim ~/.config'
alias vi='nvim'
alias vim='nvim'
alias la='ls -a'
alias ll='ls -la'

# Starship theme
eval "$(starship init zsh)"
