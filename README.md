# wpl-check

`wpl-check` is the standalone CLI and agent-facing packaging for validating WPL source and running one sample payload through a rule, package, or expression.

The repository bundles:

- the `wpl-check` CLI
- reusable examples under `examples/wpl-check/`
- the `wpl-rule-check` agent skill under `tools/skills/wpl-rule-check/`

`wpl-check` depends on `wp-lang` with its `check` feature enabled.

## What It Provides

- `wpl-check syntax` for source-only validation
- `wpl-check sample` for parsing one payload against WPL
- bundled examples under `examples/wpl-check/`
- the `wpl-rule-check` agent skill under `tools/skills/wpl-rule-check/`

## Install

```bash
cargo install wpl-check
```

## Usage

From the `wpl-check` repository root:

```bash
cargo run -- syntax examples/wpl-check/csv_demo/rule.wpl
cargo run -- sample --rule examples/wpl-check/csv_demo/rule.wpl examples/wpl-check/csv_demo/sample.txt
```

## In-Repo Development

When developing this directory inside the `wp-lang` checkout root:

```bash
cargo run --manifest-path wpl-check/Cargo.toml -- syntax wpl-check/examples/wpl-check/csv_demo/rule.wpl
cargo run --manifest-path wpl-check/Cargo.toml -- sample --rule wpl-check/examples/wpl-check/csv_demo/rule.wpl wpl-check/examples/wpl-check/csv_demo/sample.txt
```

## Install the Skill

From the `wpl-check` repository root:

```bash
bash scripts/install-codex-skill.sh wpl-rule-check
```

When developing this directory inside the `wp-lang` checkout root:

```bash
bash wpl-check/scripts/install-codex-skill.sh wpl-rule-check
```

## Local Dependency Override

- `Cargo.toml` depends on published `wp-lang = "0.1.4"`.
- A local `[patch.crates-io]` keeps in-repo development pointed at the sibling `../` checkout.
- The bundled skill is designed to prefer an installed `wpl-check`, and otherwise fall back to a local checkout of this repository.
