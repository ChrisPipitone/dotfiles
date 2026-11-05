[[ $- != *i* ]] && return

for e in nvim vim vi; do command -v "$e" &>/dev/null && export EDITOR="$e" && break; done

HISTSIZE=5000
HISTFILESIZE=$HISTSIZE
HISTCONTROL=ignoreboth:erasedups
shopt -s histappend cdspell checkwinsize globstar

set -o vi
bind -m vi-insert '"\C-l": clear-screen'
bind 'set completion-ignore-case on'
bind 'set completion-map-case on'
bind 'set show-all-if-ambiguous on'
bind 'set colored-stats on'

[[ -r /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion

alias ls='ls --color=auto'
alias la='ls -la'
alias ll='ls -l'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias c='clear'
alias decompress='tar -xzf'
alias g='git'
alias gs='git status'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'

n() { [[ $# -eq 0 ]] && $EDITOR . || $EDITOR "$@"; }
compress() { tar -czf "${1%/}.tar.gz" "${1%/}"; }

alias cconf='cmake -S . -B build'
alias cb='cmake --build build'
cr() { ./build/"$@"; }

# Read $? before anything else clobbers it
__prompt() {
  local s=$? c='\[\e[32m\]' b
  (( s )) && c='\[\e[31m\]'
  b=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
  [[ -n $b ]] && b=" \[\e[35m\]$b\[\e[0m\]"
  PS1="\[\e[33m\]\h\[\e[0m\] \[\e[36m\]\w\[\e[0m\]$b\n$c❯\[\e[0m\] "
  history -a; history -n
}
PROMPT_COMMAND=__prompt
