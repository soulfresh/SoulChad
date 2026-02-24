#!/bin/bash

set -euo pipefail

message="${1:-}"
sound="${2:-default}"
title="${3:-Claude Code}"

if [ -z "$message" ]; then
  echo "Usage: $0 <message> [sound] [title]" >&2
  exit 1
fi

repo_name=""
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  repo_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
  if [ -n "$repo_root" ]; then
    repo_name="$(basename "$repo_root")"
  fi
fi

if command -v terminal-notifier >/dev/null 2>&1; then
  if [ -n "$repo_name" ]; then
    terminal-notifier \
      -title "$title" \
      -subtitle "$repo_name" \
      -message "$message" \
      -sound "$sound" \
      -sender com.anthropic.claudefordesktop
  else
    terminal-notifier \
      -title "$title" \
      -message "$message" \
      -sound "$sound" \
      -sender com.anthropic.claudefordesktop
  fi
else
  if [ -n "$repo_name" ]; then
    osascript -e "display notification \"${message}\" with title \"${title}\" subtitle \"${repo_name}\""
  else
    osascript -e "display notification \"${message}\" with title \"${title}\""
  fi
fi
