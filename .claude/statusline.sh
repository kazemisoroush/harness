#!/bin/bash
# Read all of stdin into a variable
input=$(cat)

# Extract fields with jq, "// 0" provides fallback for null
MODEL=$(echo "$input" | jq -r '.model.display_name')
DIR=$(echo "$input" | jq -r '.workspace.current_dir')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
USED=$(echo "$input" | jq -r '(.context_window.current_usage.input_tokens // 0) + (.context_window.current_usage.cache_creation_input_tokens // 0) + (.context_window.current_usage.cache_read_input_tokens // 0)')
TOTAL=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
COST_FMT=$(printf '%.4f' "$COST")

# Format token count as human-readable: 11k, 200k, 1M, etc.
fmt_tokens() {
    local n=$1
    if [ "$n" -ge 1000000 ]; then
        printf '%dM' $((n / 1000000))
    elif [ "$n" -ge 1000 ]; then
        printf '%dk' $((n / 1000))
    else
        printf '%d' "$n"
    fi
}
USED_FMT=$(fmt_tokens "$USED")
TOTAL_FMT=$(fmt_tokens "$TOTAL")

# OSC 8 hyperlink helper, renders clickable text in supporting terminals
hyperlink() {
    printf '\033]8;;%s\033\\%s\033]8;;\033\\' "$1" "$2"
}

# Build progress bar: printf -v creates a run of spaces, then
# ${var// /▓} replaces each space with a block character
BAR_WIDTH=10
FILLED=$((PCT * BAR_WIDTH / 100))
EMPTY=$((BAR_WIDTH - FILLED))
BAR=""
[ "$FILLED" -gt 0 ] && printf -v FILL "%${FILLED}s" && BAR="${FILL// /▓}"
[ "$EMPTY" -gt 0 ] && printf -v PAD "%${EMPTY}s" && BAR="${BAR}${PAD// /░}"

echo "[$MODEL] $BAR ${USED_FMT}/${TOTAL_FMT} 💰 \$$COST_FMT"

if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null)
    STAGED=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
    MODIFIED=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')

    GIT_STATUS=""
    [ "$STAGED" -gt 0 ] && GIT_STATUS="${GREEN}+${STAGED}${RESET}"
    [ "$MODIFIED" -gt 0 ] && GIT_STATUS="${GIT_STATUS}${YELLOW}~${MODIFIED}${RESET}"

    # Derive project name and web URL from origin remote
    REMOTE=$(git remote get-url origin 2>/dev/null)
    PROJECT_LABEL="${DIR##*/}"
    PROJECT_URL=""
    if [ -n "$REMOTE" ]; then
        # Normalize git@host:owner/repo(.git) and https/ssh URLs to https
        CLEAN=$(echo "$REMOTE" | sed -E \
            -e 's#^git@([^:]+):#https://\1/#' \
            -e 's#^ssh://git@#https://#' \
            -e 's#\.git$##')
        PROJECT_URL="$CLEAN"
        # owner/repo for the label
        PROJECT_LABEL=$(echo "$CLEAN" | sed -E 's#^https?://[^/]+/##')
    fi

    PROJECT_DISPLAY="$PROJECT_LABEL"
    [ -n "$PROJECT_URL" ] && PROJECT_DISPLAY=$(hyperlink "$PROJECT_URL" "$PROJECT_LABEL")

    # Look up an open PR for the current branch, cached for 60s to avoid lag
    PR_DISPLAY=""
    if command -v gh >/dev/null 2>&1 && [ -n "$BRANCH" ]; then
        CACHE_DIR="${TMPDIR:-/tmp}/claude-statusline-pr"
        mkdir -p "$CACHE_DIR" 2>/dev/null
        CACHE_KEY=$(echo "$REMOTE#$BRANCH" | tr '/:@' '___')
        CACHE_FILE="$CACHE_DIR/$CACHE_KEY"
        if [ ! -f "$CACHE_FILE" ] || [ $(( $(date +%s) - $(stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0) )) -gt 60 ]; then
            gh pr list --head "$BRANCH" --state open --json number,url --limit 1 \
                > "$CACHE_FILE" 2>/dev/null || echo '[]' > "$CACHE_FILE"
        fi
        PR_NUMBER=$(jq -r '.[0].number // empty' "$CACHE_FILE" 2>/dev/null)
        PR_URL=$(jq -r '.[0].url // empty' "$CACHE_FILE" 2>/dev/null)
        if [ -n "$PR_NUMBER" ]; then
            PR_DISPLAY=" | 🔀 $(hyperlink "$PR_URL" "PR #$PR_NUMBER")"
        fi
    fi

    echo -e "[$MODEL] 📁 $PROJECT_DISPLAY | 🌿 $BRANCH $GIT_STATUS$PR_DISPLAY"
else
    echo "[$MODEL] 📁 ${DIR##*/}"
fi
