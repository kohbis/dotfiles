#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract current working directory
cwd_full=$(echo "$input" | jq -r '.workspace.current_dir')
cwd=$(echo "$cwd_full" | sed "s|^$HOME|~|; s|^~/workspace/|~/w…/|")

# Extract model display name and trim before "anthropic"
model=$(echo "$input" | jq -r '.model.display_name')

# Extract context used percentage (100 - remaining)
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
used=""
if [ -n "$remaining" ]; then
  used=$((100 - remaining))
fi

# Extract rate limit percentages
five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# Extract mode
mode=$(echo "$input" | jq -r '.mode // empty')

# Get git information
git_info=''
if [ -d "$cwd_full/.git" ] 2>/dev/null; then
  cd "$cwd_full" 2>/dev/null && \
  git_info=$(git -c advice.detachedHead=false -c core.fileMode=false --no-optional-locks branch --show-current 2>/dev/null || \
             git --no-optional-locks rev-parse --short HEAD 2>/dev/null)
  [ -n "$(git --no-optional-locks status --porcelain 2>/dev/null)" ] && git_info="$git_info*"

  # Limit git_info to max 25 bytes
  if [ ${#git_info} -gt 25 ]; then
    git_info="${git_info:0:22}..."
  fi

  git_info=" ($git_info)"
fi

# Build mode info
mode_info=""
if [ -n "$mode" ]; then
  mode_info=$(printf " \e[1;32m[%s]\e[00m" "$mode")
fi

# TrueColor gradient: green -> yellow -> red
gradient() {
  local pct=$1
  if [ "$pct" -lt 50 ]; then
    local r=$(( pct * 51 / 10 ))
    printf '\033[38;2;%d;200;80m' "$r"
  else
    local g=$(( 200 - (pct - 50) * 4 ))
    [ "$g" -lt 0 ] && g=0
    printf '\033[38;2;255;%d;60m' "$g"
  fi
}

# Format: "label ● pct%" with gradient dot and bold percentage
dot_item() {
  local label=$1
  local pct=$2
  printf "%s $(gradient $pct)●\033[0m \033[1m%d%%\033[0m" "$label" "$pct"
}

# Build metrics line with · separator
SEP="\033[2m · \033[0m"
metrics=""

if [ -n "$used" ]; then
  metrics=$(dot_item "ctx" "$used")
fi
if [ -n "$five_hour" ]; then
  pct=$(printf "%.0f" "$five_hour")
  item=$(dot_item "5h" "$pct")
  metrics="${metrics:+$metrics$(printf "$SEP")}$item"
fi
if [ -n "$seven_day" ]; then
  pct=$(printf "%.0f" "$seven_day")
  item=$(dot_item "7d" "$pct")
  metrics="${metrics:+$metrics$(printf "$SEP")}$item"
fi

# Print status line: line1=cwd/git/mode/model, line2=metrics
printf "\e[1;31m%s\e[00m\e[1;36m%s\e[00m%s \e[1;35m%s\e[00m" \
  "$cwd" "$git_info" "$mode_info" "$model"
[ -n "$metrics" ] && printf "\n%s" "$metrics"
