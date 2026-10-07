#!/bin/bash

# Runs on every status update, so keep process spawns minimal:
# one jq call, one git call, and bash builtins for everything else.

# Extract all fields in one jq call (\x1f keeps empty fields, unlike tab)
IFS=$'\x1f' read -r cwd_full model remaining five_hour seven_day mode < <(
  jq -r '[
    .workspace.current_dir,
    .model.display_name,
    (.context_window.remaining_percentage // ""),
    (.rate_limits.five_hour.used_percentage // ""),
    (.rate_limits.seven_day.used_percentage // ""),
    (.mode // "")
  ] | map(tostring) | join("\u001f")'
)

# Shorten cwd: $HOME -> ~, ~/workspace/ -> ~/w…/
cwd=$cwd_full
[[ $cwd == "$HOME"* ]] && cwd="~${cwd#"$HOME"}"
[[ $cwd == "~/workspace/"* ]] && cwd="~/w…/${cwd#"~/workspace/"}"

# Context used percentage (100 - remaining)
used=""
if [ -n "$remaining" ]; then
  used=$((100 - remaining))
fi

# Git branch and dirty flag from a single `git status` call
git_info=''
if [ -d "$cwd_full/.git" ]; then
  branch=''
  oid=''
  dirty=''
  while IFS= read -r line; do
    case $line in
      '# branch.head '*) branch=${line#'# branch.head '} ;;
      '# branch.oid '*) oid=${line#'# branch.oid '} ;;
      '#'*) ;;
      *) dirty='*' ;;
    esac
  done < <(git -C "$cwd_full" --no-optional-locks status --porcelain=v2 --branch 2>/dev/null)

  [ "$branch" = '(detached)' ] && branch=${oid:0:7}
  git_info="$branch$dirty"

  # Limit git_info to max 25 bytes
  if [ ${#git_info} -gt 25 ]; then
    git_info="${git_info:0:22}..."
  fi

  git_info=" ($git_info)"
fi

# Build mode info
mode_info=""
if [ -n "$mode" ]; then
  printf -v mode_info " \e[1;32m[%s]\e[00m" "$mode"
fi

# Append "label ● pct%" to metrics with a TrueColor gradient dot (green -> yellow -> red)
SEP=$'\033[2m · \033[0m'
metrics=""
add_metric() {
  local label=$1 pct=$2 color item
  if [ "$pct" -lt 50 ]; then
    printf -v color '\033[38;2;%d;200;80m' $((pct * 51 / 10))
  else
    local g=$((200 - (pct - 50) * 4))
    [ "$g" -lt 0 ] && g=0
    printf -v color '\033[38;2;255;%d;60m' "$g"
  fi
  printf -v item "%s %s●\033[0m \033[1m%d%%\033[0m" "$label" "$color" "$pct"
  metrics="${metrics:+$metrics$SEP}$item"
}

[ -n "$used" ] && add_metric "ctx" "$used"
if [ -n "$five_hour" ]; then
  printf -v pct "%.0f" "$five_hour"
  add_metric "5h" "$pct"
fi
if [ -n "$seven_day" ]; then
  printf -v pct "%.0f" "$seven_day"
  add_metric "7d" "$pct"
fi

# Print status line: line1=cwd/git/mode/model, line2=metrics
printf "\e[1;31m%s\e[00m\e[1;36m%s\e[00m%s \e[1;35m%s\e[00m" \
  "$cwd" "$git_info" "$mode_info" "$model"
[ -n "$metrics" ] && printf "\n%s" "$metrics"
