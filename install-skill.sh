#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat >&2 <<EOF
Usage:
  install-skill.sh <skill-name> [options]

Options:
  --agent <name>         Agent host metadata to highlight after install.
                         Default: openai
  --codex-home <path>    Codex home. Used only for openai/codex installs.
                         Default: ~/.codex
  --target-dir <path>    Install directly into this directory.
  --list-agents          Print supported agent hosts and exit.
  -h, --help             Show this help.

Examples:
  install-skill.sh wpl-rule-check
  install-skill.sh wpl-rule-check --agent anthropic --target-dir ./dist/skills
  install-skill.sh wpl-rule-check --list-agents

Notes:
  - openai/codex defaults to ~/.codex/skills/<skill-name>
  - other agents default to:
      ${XDG_DATA_HOME:-$HOME/.local/share}/wpl-check/skills/<skill-name>
EOF
}

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
skill_name=""
agent="openai"
codex_home="${HOME}/.codex"
target_dir=""
src_dir=""
tmp_dir=""

cleanup() {
  if [[ -n "$tmp_dir" && -d "$tmp_dir" ]]; then
    rm -rf "$tmp_dir"
  fi
}

trap cleanup EXIT

normalize_agent() {
  case "$1" in
    openai|codex)
      printf 'openai\n'
      ;;
    anthropic|claude)
      printf 'anthropic\n'
      ;;
    gemini|google)
      printf 'gemini\n'
      ;;
    cursor)
      printf 'cursor\n'
      ;;
    cline)
      printf 'cline\n'
      ;;
    continue)
      printf 'continue\n'
      ;;
    generic)
      printf 'generic\n'
      ;;
    *)
      return 1
      ;;
  esac
}

list_agents() {
  cat <<'EOF'
openai
anthropic
gemini
cursor
cline
continue
generic
EOF
}

resolve_local_src() {
  local candidate="$repo_root/tools/skills/$skill_name"
  if [[ -d "$candidate" ]]; then
    src_dir="$candidate"
    return 0
  fi
  return 1
}

resolve_remote_src() {
  local ref="${WPL_CHECK_REF:-main}"
  local archive_url=""
  local extracted_root=""
  local kind=""

  tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/wpl-check-skill.XXXXXX")"

  for kind in heads tags; do
    archive_url="https://github.com/wp-labs/wpl-check/archive/refs/${kind}/${ref}.tar.gz"
    if curl -fsSL "$archive_url" | tar -xzf - -C "$tmp_dir"; then
      extracted_root="$tmp_dir/wpl-check-$ref"
      break
    fi
  done

  if [[ -z "$extracted_root" || ! -d "$extracted_root" ]]; then
    echo "failed to download wpl-check archive for ref: $ref" >&2
    exit 1
  fi

  src_dir="$extracted_root/tools/skills/$skill_name"

  if [[ ! -d "$src_dir" ]]; then
    echo "skill source not found in downloaded archive: $src_dir" >&2
    exit 1
  fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    --list-agents)
      list_agents
      exit 0
      ;;
    --agent)
      if [[ $# -lt 2 ]]; then
        echo "missing value for --agent" >&2
        exit 2
      fi
      if ! agent="$(normalize_agent "$2")"; then
        echo "unsupported agent: $2" >&2
        echo "use --list-agents to see supported values" >&2
        exit 2
      fi
      shift 2
      ;;
    --codex-home)
      if [[ $# -lt 2 ]]; then
        echo "missing value for --codex-home" >&2
        exit 2
      fi
      codex_home="$2"
      shift 2
      ;;
    --target-dir)
      if [[ $# -lt 2 ]]; then
        echo "missing value for --target-dir" >&2
        exit 2
      fi
      target_dir="$2"
      shift 2
      ;;
    -*)
      echo "unknown option: $1" >&2
      usage
      exit 2
      ;;
    *)
      if [[ -n "$skill_name" ]]; then
        echo "unexpected extra argument: $1" >&2
        usage
        exit 2
      fi
      skill_name="$1"
      shift
      ;;
  esac
done

if [[ -z "$skill_name" ]]; then
  usage
  exit 2
fi

if ! resolve_local_src; then
  resolve_remote_src
fi

if [[ -z "$target_dir" ]]; then
  if [[ "$agent" == "openai" ]]; then
    target_dir="$codex_home/skills/$skill_name"
  else
    target_dir="${XDG_DATA_HOME:-$HOME/.local/share}/wpl-check/skills/$skill_name"
  fi
fi

mkdir -p "$(dirname "$target_dir")"
rm -rf "$target_dir"
cp -R "$src_dir" "$target_dir"

agent_file="$target_dir/agents/$agent.yaml"
portable_prompt="$target_dir/references/portable-system-prompt.md"

echo "installed $skill_name -> $target_dir"
if [[ -f "$agent_file" ]]; then
  echo "agent metadata: $agent_file"
fi
if [[ -f "$portable_prompt" && "$agent" != "openai" ]]; then
  echo "portable prompt: $portable_prompt"
fi
