#!/bin/bash
pane_path=$(tmux display-message -p '#{pane_current_path}' 2>/dev/null)
[ -z "$pane_path" ] && exit 0

if ! git -C "$pane_path" rev-parse --git-dir > /dev/null 2>&1; then
    exit 0
fi

branch=$(git -C "$pane_path" symbolic-ref --short HEAD 2>/dev/null)
if [ -z "$branch" ]; then
    branch=$(git -C "$pane_path" rev-parse --short HEAD 2>/dev/null)
fi
[ -z "$branch" ] && exit 0

status_output=$(git -C "$pane_path" status --porcelain=v2 2>/dev/null)

modified=$(echo "$status_output" | grep -cE '^1 .[MDRCUA] ' 2>/dev/null || echo 0)
staged=$(echo "$status_output" | grep -cE '^1 [MDRCUA]. ' 2>/dev/null || echo 0)
untracked=$(echo "$status_output" | grep -cE '^\? ' 2>/dev/null || echo 0)
stashes=$(git -C "$pane_path" stash list 2>/dev/null | wc -l)

upstream=$(git -C "$pane_path" rev-parse --abbrev-ref '@{upstream}' 2>/dev/null)
ahead=0
behind=0
if [ -n "$upstream" ]; then
    ahead=$(git -C "$pane_path" rev-list --count @{upstream}..HEAD 2>/dev/null || echo 0)
    behind=$(git -C "$pane_path" rev-list --count HEAD..@{upstream} 2>/dev/null || echo 0)
fi

parts=""
[ "$modified" -gt 0 ] 2>/dev/null && parts="${parts} !${modified}"
[ "$untracked" -gt 0 ] 2>/dev/null && parts="${parts} ?${untracked}"
[ "$staged" -gt 0 ] 2>/dev/null && parts="${parts} +${staged}"
[ "$ahead" -gt 0 ] 2>/dev/null && parts="${parts} ⇡${ahead}"
[ "$behind" -gt 0 ] 2>/dev/null && parts="${parts} ⇣${behind}"
[ "$stashes" -gt 0 ] 2>/dev/null && parts="${parts} *${stashes}"

if [ -n "$parts" ]; then
    echo " ${branch}(${parts# })"
else
    echo " ${branch}"
fi
