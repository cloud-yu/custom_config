#!/bin/bash

# ═══════════════════════════════════════════════════════════════════════════════
# Configuration — customize colors and blocks here
# ═══════════════════════════════════════════════════════════════════════════════

fg_colors=("#3D0066" "#FFF3D4" "#001F3F" "#1A1A1A" "#F5F5F5" "#2D004B")
bg_colors=("#FFD700" "#2E8B57" "#FF8C42" "#1E89FF" "#C41E3A" "#00CED1")

barrier_L=''  # U+E0B0 — right-pointing
barrier_R=''  # U+E0B2 — left-pointing

# ── Block content and visibility conditions ───────────────────────────────────
# To add/reorder blocks: edit the arrays below.  Indices are auto-assigned by
# position, so the color cycles automatically.  Condition is a tmux format
# expression — if non-empty the block (and its preceding barrier) is shown.
#
#   content = what to display (tmux format string)
#   cond    = tmux condition (empty = always visible)

git_cmd="bash ~/.config/tmux/scripts/tmux-git-status.sh"

# -- Left side ----------------------------------------------------------------

# shellcheck disable=SC2034
left_content=(
  " ❐ #S "                                      # 0  session
#  " #{pane_current_path} "                       # 1  path
  " #(${git_cmd}) "                                # 2  git
)

# shellcheck disable=SC2034
left_cond=(
  ""                                              # always
#  "pane_current_path"
  "#(${git_cmd})"
)

# -- Right side ---------------------------------------------------------------

indicators_prefix=${indicators_prefix:-¶}     # U+00B6
indicators_mouse=${indicators_mouse:-}   # U+F245
indicators_sync=${indicators_sync:-}      # U+EA77

username_text=$(id -u -n)
root=$(if [ "$(id -u)" -eq 0 ]; then printf "!"; fi)
os_text="$(hostnamectl 2>/dev/null | grep 'Operating System' | awk -F':' '{gsub(/^ +| +$/,"",$2); print $2}')"

right_content=(
  " #{?client_prefix,${indicators_prefix} ,}#{?pane_synchronized,${indicators_sync} ,}#{?mouse,${indicators_mouse} ,}"  # 0  indicators
  " #{pane_index} #{?#{&&:#{&&:#{pane_at_left},#{pane_at_right}},#{&&:#{pane_at_top},#{pane_at_bottom}}},,#{?#{&&:#{pane_at_left},#{pane_at_right}},,#{?pane_at_left,L,}#{?pane_at_right,R,}}#{?#{&&:#{pane_at_top},#{pane_at_bottom}},,#{?pane_at_top,T,}#{?pane_at_bottom,B,}} }"  # 1  pane location
  " %R | %d %b "                                # 2  datetime
  " ${username_text}${root} "                    # 3  username
)

right_cond=("#{||:#{||:#{client_prefix},#{pane_synchronized}},#{mouse}}" "" "" "")

if [ -n "$os_text" ]; then
  right_content+=(" ${os_text} ")                # 4  os info
  right_cond+=("")
fi

# ═══════════════════════════════════════════════════════════════════════════════
# Helpers — no need to touch below unless changing the color/layout logic
# ═══════════════════════════════════════════════════════════════════════════════

# Separate #[fg=...]#[bg=...] — tmux #{?} parser splits on commas, so a single
# #[fg=...,bg=...] inside a conditional would break.
block_style() {
  local idx=$(($1 % ${#fg_colors[@]}))
  echo "#[fg=${fg_colors[$idx]}]#[bg=${bg_colors[$idx]}]"
}

barrier_L_style() {
  local li=$(($1 % ${#bg_colors[@]})) ri=$(($2 % ${#bg_colors[@]}))
  echo "#[fg=${bg_colors[$li]}]#[bg=${bg_colors[$ri]}]"
}

barrier_R_style() {
  local li=$(($1 % ${#bg_colors[@]})) ri=$(($2 % ${#bg_colors[@]}))
  echo "#[fg=${bg_colors[$ri]}]#[bg=${bg_colors[$li]}]"
}

trail_style() {
  local idx=$(($1 % ${#bg_colors[@]}))
  echo "#[fg=${bg_colors[$idx]}]#[bg=default]"
}

# ═══════════════════════════════════════════════════════════════════════════════
# Builders — iterate block arrays and assemble the tmux format strings
# ═══════════════════════════════════════════════════════════════════════════════

build_left() {
  local -n content="$1"
  local -n cond="$2"
  local count=${#content[@]}
  local i output

  for ((i=0; i<count; i++)); do
    local c="${content[$i]}"
    local v="${cond[$i]}"

    if [ $i -eq 0 ]; then
      # First block: style + content (no preceding barrier)
      if [ -n "$v" ]; then
        output+="#{?${v},$(block_style $i)${c},}"
      else
        output+="$(block_style $i)${c}"
      fi
    else
      local barrier
      barrier="$(barrier_L_style $((i-1)) $i)${barrier_L}"
      if [ -n "$v" ]; then
        output+="#{?${v},${barrier}$(block_style $i)${c},}"
      else
        output+="${barrier}$(block_style $i)${c}"
      fi
    fi
  done

  # Trailing  that fades from the last visible block's bg → default
  # Chain checks blocks from last→first so the rightmost visible one wins
  local trail
  trail="$(trail_style 0)${barrier_L}"   # fallback = block 0's bg
  for ((i=1; i<count; i++)); do
    local v="${cond[$i]}"
    [ -n "$v" ] && trail="#{?${v},$(trail_style $i)${barrier_L},${trail}}"
  done
  output+="${trail}"

  echo "$output"
}

build_right() {
  local -n content="$1"
  local -n cond="$2"
  local count=${#content[@]}
  local i output

  # Leading  — if the first block is conditional, chain through it so that
  # the first *visible* block's bg is used for the fade-in from default.
  if [ -n "${cond[0]}" ] && [ "$count" -gt 1 ]; then
    output="#{?${cond[0]},$(trail_style 0)${barrier_R},$(trail_style 1)${barrier_R}}"
  else
    output="$(trail_style 0)${barrier_R}"
  fi

  for ((i=0; i<count; i++)); do
    local c="${content[$i]}"
    local v="${cond[$i]}"

    if [ $i -eq 0 ]; then
      # First block: style + content (no preceding barrier)
      # Include its outgoing barrier *inside* the conditional so the barrier
      # also disappears when the first block is empty.
      if [ -n "$v" ]; then
        local nb=""   # outgoing barrier (block 0 → block 1)
        [ "$count" -gt 1 ] && nb="$(barrier_R_style 0 1)${barrier_R}"
        output+="#{?${v},$(block_style $i)${c}${nb},}"
      else
        output+="$(block_style $i)${c}"
      fi
    elif [ $i -eq 1 ] && [ -n "${cond[0]}" ]; then
      # Second block, first is conditional: block 0 already handles the
      # barrier 0→1 inside its conditional.  Start with style + content only.
      if [ -n "$v" ]; then
        output+="#{?${v},$(block_style $i)${c},}"
      else
        output+="$(block_style $i)${c}"
      fi
    else
      local barrier
      barrier="$(barrier_R_style $((i-1)) $i)${barrier_R}"
      if [ -n "$v" ]; then
        output+="#{?${v},${barrier}$(block_style $i)${c},}"
      else
        output+="${barrier}$(block_style $i)${c}"
      fi
    fi
  done

  echo "$output"
}

# ═══════════════════════════════════════════════════════════════════════════════
# Assemble
# ═══════════════════════════════════════════════════════════════════════════════

status_left="$(build_left left_content left_cond)"
status_right="$(build_right right_content right_cond)#[bg=default]"

tmux set-option -g status-left "$status_left"
tmux set-option -g status-right "$status_right"
