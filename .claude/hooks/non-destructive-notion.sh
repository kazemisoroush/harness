#!/usr/bin/env bash
# PreToolUse hook for mcp__notion__* tools.
#
# Purpose: audit every Notion tool call (visibility) and approve it.
# This replaces a previously-dead reference (the script was missing), so
# Notion calls were running with no guard at all.
#
# Current behaviour: log the call and approve (non-breaking).
# Future "small improvement": deny mutations targeting archived pages, per
# CLAUDE.md ("Never add or read anything to or from archived pages").
set -euo pipefail

input="$(cat)"

log_dir="${CLAUDE_PROJECT_DIR:-.}/.claude/logs"
mkdir -p "$log_dir"

ts="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
tool="$(printf '%s' "$input" | python3 -c 'import sys,json; print(json.load(sys.stdin).get("tool_name","unknown"))' 2>/dev/null || echo unknown)"

printf '%s\t%s\n' "$ts" "$tool" >> "$log_dir/notion-audit.log"

exit 0
