# Set the directory to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# fzf shell integration loads ^T, ^R, Alt+C, and fzf-completion for ^I
eval "$(fzf --zsh)"
# Reset ^I to expand-or-complete so fzf-tab wraps the standard widget, not fzf-completion
bindkey '^I' expand-or-complete

# zsh-completions must come before compinit; fzf-tab must come after;
# zsh-autosuggestions and zsh-syntax-highlighting after fzf-tab
zinit light zsh-users/zsh-completions
autoload -Uz compinit && compinit
zinit cdreplay -q
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:*:*' fzf-preview 'lsd --color=always --icon=always $realpath 2>/dev/null || ls --color $realpath 2>/dev/null'

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt correct

export EDITOR='nvim'

# vim mode
bindkey -v
bindkey "^?" backward-delete-char

alias vi='nvim'
alias vim='nvim'
if command -v lsd &>/dev/null; then
  alias ls='lsd'
  alias la='lsd -la'
  alias ll='lsd -lA'
  alias lt='lsd --tree'
elif command -v colorls &>/dev/null; then
  alias ls='colorls'
  alias la='colorls -la'
  alias ll='colorls -l'
fi
alias config='cd ~/.config && nvim'
alias c='clear'

# Shell integrations
[[ -f "$HOME/.config/ls-colors.sh" ]] && source "$HOME/.config/ls-colors.sh"
eval "$(starship init zsh)"

# Transient prompt via preexec — collapses previous 2-line prompt to ❯ before output
# Uses precmd to capture exit status before anything else modifies $?
_transient_last_status=0
_transient_precmd() { _transient_last_status=$?; }
precmd_functions=(_transient_precmd "${precmd_functions[@]}")

_transient_preexec() {
  local color
  (( _transient_last_status == 0 )) && color=$'\e[32m' || color=$'\e[31m'
  printf '\e[2A\r\e[J%s❯\e[0m %s\n' "$color" "$1"
}
add-zsh-hook preexec _transient_preexec

PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"
export PATH

[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"
