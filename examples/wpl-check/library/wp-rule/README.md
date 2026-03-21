# Mirrored `wp-rule` Examples

This directory keeps a small curated mirror of `wp-rule` examples that are worth exposing directly in `wpl-check`.

## Why This Exists

- `wpl-check` is the main user entry point for local drafting and validation.
- `wp-rule` remains the upstream shared rule library.
- Users should not need to clone `wp-rule` just to see realistic examples.

## Selection Criteria

Mirror an example only when it satisfies most of these:

- It covers a parsing shape that is not already represented in `examples/wpl-check/core/`.
- It is useful as a reusable adaptation template, not only as a project-specific artifact.
- It is stable enough that small upstream churn is unlikely to break the teaching value.
- It demonstrates a production-like structure that users are likely to encounter.
- It runs cleanly through `wpl-check sample` after the filename mapping.

Prefer examples that add one of these capabilities:

- nested JSON extraction
- outer envelope plus inner log parsing
- long multi-column access logs
- KV arrays or mixed typed fields
- package-based organization that reflects real rule libraries

## Do Not Mirror

- near-duplicates of existing `core/` or mirrored examples
- examples that depend on repository-wide validation rather than a local sample pair
- highly project-specific rules with weak reuse value
- noisy examples that are hard to explain and add no new parsing shape

## Mapping Rules

Each mirrored directory normalizes upstream naming:

- `parse.wpl` -> `rule.wpl`
- `sample.dat` -> `sample.txt`

Use explicit package mode when running these examples:

```bash
wpl-check sample --package --rule-name nginx examples/wpl-check/library/wp-rule/raw/nginx
```

## Refresh Workflow

1. Review candidates in `../wp-rule/models/wpl/`.
2. Decide whether the example adds a new reusable parsing shape.
3. Sync the curated allowlist with:

```bash
bash scripts/sync-wp-rule-examples.sh ../wp-rule
```

4. Re-run representative validations:

```bash
./target/debug/wpl-check sample --package --rule-name nginx examples/wpl-check/library/wp-rule/raw/nginx
./target/debug/wpl-check sample --package --rule-name sysmon examples/wpl-check/library/wp-rule/raw/sysmon
```

## Current Curated Set

- `learn/kvarr`
- `learn/json`
- `raw/nginx`
- `raw/aws`
- `raw/sysmon`
- `fluent-bit/nginx`
