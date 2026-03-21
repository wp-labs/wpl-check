# wpl-check Examples

Each example lives in its own directory so the WPL source and sample payload stay together.

## Layout

- `core/` contains small teaching examples for fast drafting and debugging.
- `library/wp-rule/` contains curated examples mirrored from the `wp-rule` repository.

Selection and refresh policy for mirrored examples:

- `examples/wpl-check/library/wp-rule/README.md`

Refresh the mirrored library set:

```bash
bash scripts/sync-wp-rule-examples.sh ../wp-rule
```

## Core Examples

## `core/csv_demo`

Syntax check:

```bash
wpl-check syntax examples/wpl-check/core/csv_demo/rule.wpl
wpl-check syntax examples/wpl-check/core/csv_demo
```

Run one sample payload against a single rule:

```bash
wpl-check sample --rule examples/wpl-check/core/csv_demo/rule.wpl examples/wpl-check/core/csv_demo/sample.txt
wpl-check sample --rule examples/wpl-check/core/csv_demo
```

## `core/package_demo`

Run one sample payload against a package rule:

```bash
wpl-check sample --package --rule-name csv_user examples/wpl-check/core/package_demo
```

## `core/log_line`

Log parsing example:

```bash
wpl-check sample --rule examples/wpl-check/core/log_line/rule.wpl examples/wpl-check/core/log_line/sample.txt
```

## `core/nginx_access_clf`

Nginx access log with CLF time in `[]`:

```bash
wpl-check sample --rule examples/wpl-check/core/nginx_access_clf
```

## `core/nginx_access_brace_time`

Nginx-style line with time wrapped by `{}`:

```bash
wpl-check sample --rule examples/wpl-check/core/nginx_access_brace_time
```

## Library Examples

These directories mirror selected `wp-rule` examples after converting:

- `parse.wpl` -> `rule.wpl`
- `sample.dat` -> `sample.txt`

Use explicit package mode for these examples.

## `library/wp-rule/learn/kvarr`

KV array example:

```bash
wpl-check sample --package --rule-name kvarr_1 examples/wpl-check/library/wp-rule/learn/kvarr
```

## `library/wp-rule/learn/json`

JSON field extraction example:

```bash
wpl-check sample --package --rule-name json_1 examples/wpl-check/library/wp-rule/learn/json
```

## `library/wp-rule/raw/nginx`

Production-style nginx access log:

```bash
wpl-check sample --package --rule-name nginx examples/wpl-check/library/wp-rule/raw/nginx
```

## `library/wp-rule/raw/aws`

AWS load balancer log:

```bash
wpl-check sample --package --rule-name aws examples/wpl-check/library/wp-rule/raw/aws
```

## `library/wp-rule/raw/sysmon`

Sysmon prefix plus JSON payload:

```bash
wpl-check sample --package --rule-name sysmon examples/wpl-check/library/wp-rule/raw/sysmon
```

## `library/wp-rule/fluent-bit/nginx`

Fluent Bit JSON envelope carrying nginx access logs:

```bash
wpl-check sample --package --rule-name nginx examples/wpl-check/library/wp-rule/fluent-bit/nginx
```
