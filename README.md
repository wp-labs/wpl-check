# wpl-check

[中文说明](./README.zh.md)

`wpl-check` is the standalone CLI and agent-facing packaging for validating WPL source and running one sample payload through a rule, package, or expression.

The repository bundles:

- the `wpl-check` CLI
- reusable examples under `examples/wpl-check/`
- the `wpl-rule-check` agent skill under `tools/skills/wpl-rule-check/`

`wpl-check` depends on `wp-lang` with its `check` feature enabled.

## What It Provides

- `wpl-check syntax` for source-only validation
- `wpl-check sample` for parsing one payload against WPL
- bundled examples under `examples/wpl-check/core/` and `examples/wpl-check/library/wp-rule/`
- the `wpl-rule-check` agent skill under `tools/skills/wpl-rule-check/`

## Install

```bash
curl -sSf https://get.warpparse.ai/inst-x.sh | bash -s -- wpl-check
```

This installs the latest `wpl-check` binary without requiring a local Rust toolchain.

## Usage

From the `wpl-check` repository root:

```bash
wpl-check syntax examples/wpl-check/core/csv_demo/rule.wpl
wpl-check sample --rule examples/wpl-check/core/csv_demo/rule.wpl examples/wpl-check/core/csv_demo/sample.txt
wpl-check sample --package --rule-name nginx examples/wpl-check/library/wp-rule/raw/nginx
```

## Development From Source

Only use this path when you are developing `wpl-check` itself. Regular users should prefer the install script above.

When developing this repository from source:

```bash
cargo run -- syntax examples/wpl-check/core/csv_demo/rule.wpl
cargo run -- sample --rule examples/wpl-check/core/csv_demo/rule.wpl examples/wpl-check/core/csv_demo/sample.txt
cargo run -- sample --package --rule-name nginx examples/wpl-check/library/wp-rule/fluent-bit/nginx
```

## Example Layout

- `examples/wpl-check/core/` keeps small teaching examples that are easy to adapt.
- `examples/wpl-check/library/wp-rule/` keeps curated real-world examples mirrored from `wp-rule`.
- `examples/wpl-check/library/wp-rule/README.md` defines which upstream examples are worth mirroring and how to refresh them.

Refresh the mirrored library examples from a local `wp-rule` checkout:

```bash
bash scripts/sync-wp-rule-examples.sh ../wp-rule
```

## Install the Skill

Install directly from GitHub without cloning the repository:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/wp-labs/wpl-check/main/install-skill.sh) wpl-rule-check
```

Set `WPL_CHECK_REF=<branch-or-tag>` first if you want a specific published revision instead of `main`.

From the `wpl-check` repository root:

```bash
bash install-skill.sh wpl-rule-check
```

Install for another agent host into a generic skill directory:

```bash
bash install-skill.sh wpl-rule-check --agent anthropic
bash install-skill.sh wpl-rule-check --agent gemini --target-dir ./dist/skills/wpl-rule-check
bash install-skill.sh wpl-rule-check --list-agents
```

## Notes

- The bundled skill is designed to prefer an installed `wpl-check`, and otherwise fall back to a local source checkout for repository maintainers.
- The skill bundle now includes host metadata under `tools/skills/wpl-rule-check/agents/` for `openai`, `anthropic`, `gemini`, `cursor`, `cline`, `continue`, and `generic`.
- Building from source requires Rust. Installing through `https://get.warpparse.ai/inst-x.sh` does not.
- Installing the skill through the GitHub script requires `bash`, `curl`, and `tar`, but does not require Rust.
