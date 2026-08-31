#!/usr/bin/env bash
# Fuzzy-find a project directory and switch to (or create) a named tmux session.
# Usage: tmux-sessionizer [path]  — skip fzf if path given directly

selected=""

if [[ $# -eq 1 ]]; then
  selected="$1"
else
  selected=$(find \
    ~/projects \
    ~/.dotfiles \
    ~/Documents \
    -mindepth 1 -maxdepth 3 \
    -type d \
    \( -name ".git" -prune -o -name "node_modules" -prune -o -name "build" -prune \) \
    -o -type d -print \
    2>/dev/null \
    | fzf --preview 'ls -la {}' --height 40% --border)
fi

[[ -z "$selected" ]] && exit 0

session_name=$(basename "$selected" | tr ' .:' '_')

if ! tmux has-session -t "$session_name" 2>/dev/null; then
  tmux new-session -ds "$session_name" -c "$selected"
fi

if [[ -n "$TMUX" ]]; then
  tmux switch-client -t "$session_name"
else
  tmux attach-session -t "$session_name"
fi
