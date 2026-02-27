#!/bin/bash

set -euo pipefail

# Codex calls notify scripts with a single JSON argument.
payload="${1:-}"

# Optional stdin fallback for local testing.
if [ -z "$payload" ] && [ ! -t 0 ]; then
  payload="$(cat)"
fi

if [ -z "$payload" ]; then
  echo "Usage: $0 '<codex_notification_json>'" >&2
  exit 1
fi

notif_type=""
thread_id=""
turn_id=""
cwd_from_payload=""
input_messages=""
last_assistant_message=""

if command -v jq >/dev/null 2>&1; then
  notif_type="$(printf '%s' "$payload" | jq -r '.type // empty' 2>/dev/null || true)"
  thread_id="$(printf '%s' "$payload" | jq -r '.["thread-id"] // empty' 2>/dev/null || true)"
  turn_id="$(printf '%s' "$payload" | jq -r '.["turn-id"] // empty' 2>/dev/null || true)"
  cwd_from_payload="$(printf '%s' "$payload" | jq -r '.cwd // empty' 2>/dev/null || true)"
  input_messages="$(printf '%s' "$payload" | jq -r 'if (.["input-messages"] | type) == "array" then .["input-messages"] | map(tostring) | join(" ") elif (.["input-messages"] | type) == "string" then .["input-messages"] else "" end' 2>/dev/null || true)"
  last_assistant_message="$(printf '%s' "$payload" | jq -r '.["last-assistant-message"] // empty' 2>/dev/null || true)"
else
  parsed="$(printf '%s' "$payload" | /usr/bin/python3 -c 'import json,sys
try:
    data=json.load(sys.stdin)
except Exception:
    data={}
input_messages=data.get("input-messages", "")
if isinstance(input_messages, list):
    input_messages=" ".join(str(x) for x in input_messages)
elif not isinstance(input_messages, str):
    input_messages=""
fields=[
    str(data.get("type", "")),
    str(data.get("thread-id", "")),
    str(data.get("turn-id", "")),
    str(data.get("cwd", "")),
    str(input_messages),
    str(data.get("last-assistant-message", "")),
]
print("\x1f".join(fields), end="")
' 2>/dev/null || true)"
  IFS=$'\x1f' read -r notif_type thread_id turn_id cwd_from_payload input_messages last_assistant_message <<< "$parsed"
fi

# Codex currently documents agent-turn-complete for external notify hooks.
if [ -n "$notif_type" ] && [ "$notif_type" != "agent-turn-complete" ]; then
  exit 0
fi

title="Codex"
if [ -n "$last_assistant_message" ]; then
  title="Codex: $last_assistant_message"
fi

message="$input_messages"
if [ -z "$message" ]; then
  message="Turn complete"
fi

cwd_path="$cwd_from_payload"
if [ -z "$cwd_path" ]; then
  cwd_path="$PWD"
fi

repo_name=""
if [ -n "$cwd_path" ] && git -C "$cwd_path" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  repo_root="$(git -C "$cwd_path" rev-parse --show-toplevel 2>/dev/null || true)"
  if [ -n "$repo_root" ]; then
    repo_name="$(basename "$repo_root")"
  fi
fi

subtitle="$repo_name"
if [ -z "$subtitle" ] && [ -n "$cwd_path" ]; then
  subtitle="$(basename "$cwd_path")"
fi
if [ -n "$turn_id" ]; then
  if [ -n "$subtitle" ]; then
    subtitle="$subtitle • $turn_id"
  else
    subtitle="$turn_id"
  fi
fi

if command -v terminal-notifier >/dev/null 2>&1; then
  args=( -title "$title" -message "$message" )
  if [ -n "$subtitle" ]; then
    args+=( -subtitle "$subtitle" )
  fi
  if [ -n "$thread_id" ]; then
    args+=( -group "codex-$thread_id" )
  fi
  terminal-notifier "${args[@]}"
else
  esc_message="${message//\"/\\\"}"
  esc_title="${title//\"/\\\"}"
  esc_subtitle="${subtitle//\"/\\\"}"

  if [ -n "$subtitle" ]; then
    osascript -e "display notification \"$esc_message\" with title \"$esc_title\" subtitle \"$esc_subtitle\""
  else
    osascript -e "display notification \"$esc_message\" with title \"$esc_title\""
  fi
fi
