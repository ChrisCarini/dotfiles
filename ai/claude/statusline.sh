#!/bin/bash
# Read all of stdin into a variable
input=$(cat)

# Extract fields with jq, "// 0" provides fallback for null
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
DIR=$(echo "$input" | jq -r '.workspace.current_dir')
DURATION_MS=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
MODEL=$(echo "$input" | jq -r '.model.display_name')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

# Colors
RED='\033[31m'
GREEN='\033[32m'
CYAN='\033[36m'
YELLOW='\033[33m'
RESET='\033[0m'

##
# Build the status line parts
##

# $BRANCH - Compute branch
DIR_AND_BRANCH="${DIR##*/}"
if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null)
    STAGED=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
    MODIFIED=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')

    GIT_STATUS=""
    [ "$STAGED" -gt 0 ] && GIT_STATUS="${GREEN}+${STAGED}${RESET}"
    [ "$MODIFIED" -gt 0 ] && GIT_STATUS="${GIT_STATUS}${YELLOW}~${MODIFIED}${RESET}"

    DIR_AND_BRANCH="${DIR_AND_BRANCH} | 🌿 $BRANCH $GIT_STATUS"
fi


# ${BAR_COLOR} - Pick bar color based on context usage
if [ "$PCT" -ge 90 ]; then BAR_COLOR="$RED"
elif [ "$PCT" -ge 70 ]; then BAR_COLOR="$YELLOW"
else BAR_COLOR="$GREEN"; fi

# ${BAR} - Build progress bar: printf creates spaces, tr replaces with blocks
BAR_WIDTH=10
FILLED=$((PCT * BAR_WIDTH / 100))
EMPTY=$((BAR_WIDTH - FILLED))
BAR=""
[ "$FILLED" -gt 0 ] && BAR=$(printf "%${FILLED}s" | tr ' ' '▓')
[ "$EMPTY" -gt 0 ] && BAR="${BAR}$(printf "%${EMPTY}s" | tr ' ' '░')"

# ${COST_FMT} - Format the cost
COST_FMT=$(printf '$%.2f' "$COST")

# ⏱️ ${MINS}m ${SECS}s - Build the total duration
DURATION_SEC=$((DURATION_MS / 1000))
MINS=$((DURATION_SEC / 60))
SECS=$((DURATION_SEC % 60))


##
# Print the status line
##
echo -e "${CYAN}[$MODEL]${RESET} 📁 ${DIR_AND_BRANCH} | ${BAR_COLOR}${BAR}${RESET} ${PCT}% | 💰 ${YELLOW}${COST_FMT}${RESET} | ⏱️ ${MINS}m ${SECS}s"

# Output the original input so chained commands can consume it
echo "${input}" | bunx -y ccstatusline@latest
