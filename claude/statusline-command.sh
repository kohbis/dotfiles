#!/bin/bash
# ~/.claude/statusline-command.sh
# 3-line Claude Code status line with rate-limit info

# Read JSON input from stdin
input=$(cat)

# ── ANSI 24-bit colors ────────────────────────────────────────────────────────
C_GREEN='\e[38;2;151;201;195m'   # #97C9C3  0-49%
C_YELLOW='\e[38;2;229;192;123m'  # #E5C07B  50-79%
C_RED='\e[38;2;224;108;117m'     # #E06C75  80-100%
C_GRAY='\e[38;2;74;88;92m'       # #4A585C  separators
C_RESET='\e[0m'
C_BOLD='\e[1m'

pct_color() {
  local p="${1:-0}"
  if   [ "$p" -ge 80 ]; then printf '%s' "$C_RED"
  elif [ "$p" -ge 50 ]; then printf '%s' "$C_YELLOW"
  else                        printf '%s' "$C_GREEN"
  fi
}

# 10-segment progress bar using ▰▱
prog_bar() {
  local p="${1:-0}" bar='' i filled
  filled=$(( p / 10 ))
  for i in 0 1 2 3 4 5 6 7 8 9; do
    [ "$i" -lt "$filled" ] && bar="${bar}▰" || bar="${bar}▱"
  done
  printf '%s' "$bar"
}

# Convert UTC ISO-8601 timestamp to Unix epoch on macOS
iso_to_epoch() {
  TZ=UTC date -j -f "%Y-%m-%dT%H:%M:%SZ" "${1}" "+%s" 2>/dev/null
}

# ── Parse stdin JSON ──────────────────────────────────────────────────────────

jv() { printf '%s' "$input" | jq -r "${1}" 2>/dev/null; }

# Model: "claude-opus-4-6" → "Opus 4.6"
model_raw=$(jv '.model.display_name // "Unknown"')
model_clean=$(printf '%s' "$model_raw" \
  | sed 's/^[Cc]laude[- ]//' \
  | sed 's/\([0-9]\)-\([0-9]\)/\1.\2/g' \
  | sed 's/-/ /g' \
  | awk '{$1=toupper(substr($1,1,1)) substr($1,2); print}')

# Context window usage %
rem=$(jv '.context_window.remaining_percentage // 100')
rem_int="${rem%%.*}"; rem_int="${rem_int:-100}"
context_pct=$(( 100 - rem_int ))

# Lines added / removed (try common field paths with fallback to 0)
lines_added=$(printf '%s' "$input" | jq -r \
  '.session.diff.added // .diff.lines_added // .session.lines_added // .changes.added // 0' \
  2>/dev/null || echo 0)
lines_removed=$(printf '%s' "$input" | jq -r \
  '.session.diff.removed // .diff.lines_removed // .session.lines_removed // .changes.removed // 0' \
  2>/dev/null || echo 0)

# Git branch from current working directory
cwd=$(jv '.workspace.current_dir // ""')
cwd_abs="${cwd/#\~/$HOME}"
git_branch=""
if [ -n "$cwd_abs" ] && [ -d "$cwd_abs" ]; then
  git_branch=$(git -C "$cwd_abs" --no-optional-locks branch --show-current 2>/dev/null || true)
fi

# ── Rate-limit usage (360s cache) ─────────────────────────────────────────────

CACHE_FILE="/tmp/claude-usage-cache.json"
CACHE_TTL=360

fetch_usage_api() {
  local token
  token=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null \
          | jq -r '.access_token // empty' 2>/dev/null)
  [ -z "$token" ] && return 1
  curl -sf \
    -H "Authorization: Bearer $token" \
    "https://api.anthropic.com/api/oauth/usage" 2>/dev/null
}

load_usage_data() {
  if [ -f "$CACHE_FILE" ]; then
    local mtime now age
    mtime=$(stat -f %m "$CACHE_FILE" 2>/dev/null || echo 0)
    now=$(date +%s)
    age=$(( now - mtime ))
    if [ "$age" -lt "$CACHE_TTL" ]; then
      cat "$CACHE_FILE"
      return 0
    fi
  fi
  local data
  data=$(fetch_usage_api 2>/dev/null) || return 0
  [ -n "$data" ] || return 0
  printf '%s' "$data" > "$CACHE_FILE"
  printf '%s' "$data"
}

usage_json=$(load_usage_data 2>/dev/null || true)

five_hour_pct=0
seven_day_pct=0
five_hour_reset_str=""
seven_day_reset_str=""

if [ -n "$usage_json" ]; then
  fh_util=$(printf '%s' "$usage_json" | jq -r '.five_hour.utilization // 0' 2>/dev/null || echo 0)
  sd_util=$(printf '%s' "$usage_json" | jq -r '.seven_day.utilization // 0' 2>/dev/null || echo 0)
  five_hour_pct=$(awk "BEGIN {printf \"%d\", $fh_util * 100}" 2>/dev/null || echo 0)
  seven_day_pct=$(awk "BEGIN {printf \"%d\", $sd_util * 100}" 2>/dev/null || echo 0)

  fh_reset=$(printf '%s' "$usage_json" | jq -r '.five_hour.reset_at // empty' 2>/dev/null || true)
  sd_reset=$(printf '%s' "$usage_json" | jq -r '.seven_day.reset_at // empty' 2>/dev/null || true)

  # 5h reset: "4pm"
  if [ -n "$fh_reset" ]; then
    ep=$(iso_to_epoch "$fh_reset") && {
      h=$(LC_ALL=C TZ="Asia/Tokyo" date -r "$ep" "+%l" | xargs)
      ap=$(LC_ALL=C TZ="Asia/Tokyo" date -r "$ep" "+%p" | tr '[:upper:]' '[:lower:]')
      five_hour_reset_str="${h}${ap}"
    } || true
  fi

  # 7d reset: "Mar 6 at 1pm"
  if [ -n "$sd_reset" ]; then
    ep=$(iso_to_epoch "$sd_reset") && {
      mo=$(LC_ALL=C TZ="Asia/Tokyo" date -r "$ep" "+%b")
      dy=$(LC_ALL=C TZ="Asia/Tokyo" date -r "$ep" "+%e" | xargs)
      h=$(LC_ALL=C TZ="Asia/Tokyo" date -r "$ep" "+%l" | xargs)
      ap=$(LC_ALL=C TZ="Asia/Tokyo" date -r "$ep" "+%p" | tr '[:upper:]' '[:lower:]')
      seven_day_reset_str="${mo} ${dy} at ${h}${ap}"
    } || true
  fi
fi

# ── Build 3-line output ───────────────────────────────────────────────────────

SEP="${C_GRAY}│${C_RESET}"

# Line 1: 🧠 Opus 4.6 │ 📊 0% │ ✏️ +42/-1 │ 🪾 main
ctx_c=$(pct_color "$context_pct")
L1="${C_BOLD}🧠 ${model_clean}${C_RESET} ${SEP} ${ctx_c}📊 ${context_pct}%${C_RESET} ${SEP} ✏️  +${lines_added}/-${lines_removed} ${SEP} 🪾 ${git_branch}"

# Line 2: 🕰️ 5h  ▰▱▱▱▱▱▱▱▱▱  13%  Resets 4pm (Asia/Tokyo)
fh_c=$(pct_color "$five_hour_pct")
fh_bar=$(prog_bar "$five_hour_pct")
L2="🕰️ 5h  ${fh_c}${fh_bar}  ${five_hour_pct}%${C_RESET}"
[ -n "$five_hour_reset_str" ] && L2="${L2}  Resets ${five_hour_reset_str} (Asia/Tokyo)"

# Line 3: 🗓️ 7d  ▰▰▰▰▰▱▱▱▱▱  55%  Resets Mar 6 at 1pm (Asia/Tokyo)
sd_c=$(pct_color "$seven_day_pct")
sd_bar=$(prog_bar "$seven_day_pct")
L3="🗓️ 7d  ${sd_c}${sd_bar}  ${seven_day_pct}%${C_RESET}"
[ -n "$seven_day_reset_str" ] && L3="${L3}  Resets ${seven_day_reset_str} (Asia/Tokyo)"

printf '%b\n%b\n%b\n' "$L1" "$L2" "$L3"
