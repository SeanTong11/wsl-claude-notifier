#!/bin/bash
# tmux-jump.sh — Switch tmux client to target session:window
# Called from Windows-side tmux-jump.ps1 via wsl.exe
TARGET="$1"
[ -z "$TARGET" ] && exit 1

SESSION="${TARGET%%:*}"

# Find the most recently active tmux client
CLIENT=$(tmux list-clients -F '#{client_activity} #{client_name}' | sort -rn | head -1 | cut -d' ' -f2-)
[ -z "$CLIENT" ] && exit 1

# Switch client to target session, then select window
tmux switch-client -c "$CLIENT" -t "$SESSION" 2>/dev/null
tmux select-window -t "$TARGET" 2>/dev/null
