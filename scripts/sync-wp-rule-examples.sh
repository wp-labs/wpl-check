#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat >&2 <<'EOF'
Usage:
  sync-wp-rule-examples.sh [wp-rule-repo] [output-root]

Defaults:
  wp-rule-repo -> ../wp-rule
  output-root  -> examples/wpl-check/library/wp-rule

The script copies a curated allowlist of examples and normalizes:
  parse.wpl  -> rule.wpl
  sample.dat -> sample.txt
EOF
}

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
wp_rule_repo="${1:-$repo_root/../wp-rule}"
output_root="${2:-$repo_root/examples/wpl-check/library/wp-rule}"

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ ! -d "$wp_rule_repo/models/wpl" ]]; then
  echo "wp-rule models/wpl not found under: $wp_rule_repo" >&2
  usage
  exit 1
fi

examples=(
  "learn/kvarr"
  "learn/json"
  "raw/nginx"
  "raw/aws"
  "raw/sysmon"
  "fluent-bit/nginx"
)

mkdir -p "$output_root"

for rel in "${examples[@]}"; do
  src_dir="$wp_rule_repo/models/wpl/$rel"
  dst_dir="$output_root/$rel"
  parse_file="$src_dir/parse.wpl"
  sample_file="$src_dir/sample.dat"

  if [[ ! -f "$parse_file" ]]; then
    echo "missing parse.wpl: $parse_file" >&2
    exit 1
  fi

  if [[ ! -f "$sample_file" ]]; then
    echo "missing sample.dat: $sample_file" >&2
    exit 1
  fi

  mkdir -p "$dst_dir"
  cp "$parse_file" "$dst_dir/rule.wpl"
  cp "$sample_file" "$dst_dir/sample.txt"
  echo "synced $rel -> ${dst_dir#$repo_root/}"
done

cat <<EOF

Next steps:
  wpl-check sample --package --rule-name nginx $output_root/raw/nginx
  wpl-check sample --package --rule-name aws $output_root/raw/aws
EOF
