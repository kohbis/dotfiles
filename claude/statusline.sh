#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract current working directory
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
cwd="${cwd/#$HOME/~}"

# Extract model display name and trim before "anthropic"
model=$(echo "$input" | jq -r '.model.display_name')
model=$(echo "$model" | sed 's/.*anthropic\.//')

# Extract context used percentage (100 - remaining)
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
used=""
if [ -n "$remaining" ]; then
  used=$((100 - remaining))
fi

# Extract cost
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')

# Extract token usage
input_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
output_tokens=$(echo "$input" | jq -r '.context_window.total_output_tokens // empty')

# Extract mode
mode=$(echo "$input" | jq -r '.mode // empty')

# Get git information
git_info=''
if [ -d "${cwd/#\~/$HOME}/.git" ] 2>/dev/null; then
  cd "${cwd/#\~/$HOME}" 2>/dev/null && \
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

# Build context info
context_info=""
if [ -n "$used" ]; then
  context_info=$(printf " \e[1;33m[%d%%]\e[00m" "$used")
fi

token_info=""
if [ -n "$input_tokens" ] && [ -n "$output_tokens" ]; then
  # Format tokens with K suffix for readability
  fmt_tokens() {
    local t=$1
    if [ "$t" -ge 1000000 ]; then
      printf "%.1fM" "$(echo "scale=1; $t / 1000000" | bc)"
    elif [ "$t" -ge 1000 ]; then
      printf "%.1fK" "$(echo "scale=1; $t / 1000" | bc)"
    else
      printf "%d" "$t"
    fi
  }
  in_fmt=$(fmt_tokens "$input_tokens")
  out_fmt=$(fmt_tokens "$output_tokens")
  token_info=$(printf " \e[0;37m[↑%s ↓%s]\e[00m" "$in_fmt" "$out_fmt")
fi

# Print status line in order: cwd, gitinfo, mode, model, context, tokens
printf "\e[1;31m%s\e[00m\e[1;36m%s\e[00m%s \e[1;35m%s\e[00m%s%s" \
  "$cwd" "$git_info" "$mode_info" "$model" "$context_info" "$token_info"
