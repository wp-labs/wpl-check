# wpl-check

[English README](./README.md)

`wpl-check` 是一个独立 CLI，也是面向 agent 的打包入口，用于校验 WPL 源码，并用单条样本数据对 rule、package 或 expression 进行解析验证。

本仓库包含：

- `wpl-check` CLI
- 位于 `examples/wpl-check/` 的可复用示例
- 位于 `tools/skills/wpl-rule-check/` 的 `wpl-rule-check` agent skill

`wpl-check` 依赖启用了 `check` feature 的 `wp-lang`。

## 提供能力

- `wpl-check syntax`：只校验源码语法
- `wpl-check sample`：用一条样本数据对 WPL 进行解析验证
- 位于 `examples/wpl-check/core/` 和 `examples/wpl-check/library/wp-rule/` 的内置示例
- 位于 `tools/skills/wpl-rule-check/` 的 `wpl-rule-check` agent skill

## 安装

```bash
curl -sSf https://get.warpparse.ai/inst-x.sh | bash -s -- wpl-check
```

这个方式会安装最新版本的 `wpl-check` 二进制，不要求本地有 Rust toolchain。

## 使用

在 `wpl-check` 仓库根目录下：

```bash
wpl-check syntax examples/wpl-check/core/csv_demo/rule.wpl
wpl-check sample --rule examples/wpl-check/core/csv_demo/rule.wpl examples/wpl-check/core/csv_demo/sample.txt
wpl-check sample --package --rule-name nginx examples/wpl-check/library/wp-rule/raw/nginx
```

## 从源码开发

只有在开发 `wpl-check` 本身时才建议走这条路径。普通用户优先使用上面的安装脚本。

在源码仓库中开发时：

```bash
cargo run -- syntax examples/wpl-check/core/csv_demo/rule.wpl
cargo run -- sample --rule examples/wpl-check/core/csv_demo/rule.wpl examples/wpl-check/core/csv_demo/sample.txt
cargo run -- sample --package --rule-name nginx examples/wpl-check/library/wp-rule/fluent-bit/nginx
```

## 示例结构

- `examples/wpl-check/core/` 放小而清晰的教学型示例，便于快速改写。
- `examples/wpl-check/library/wp-rule/` 放从 `wp-rule` 镜像过来的精选真实样例。
- `examples/wpl-check/library/wp-rule/README.md` 说明哪些上游样例值得镜像，以及如何刷新它们。

从本地 `wp-rule` checkout 刷新镜像样例：

```bash
bash scripts/sync-wp-rule-examples.sh ../wp-rule
```

## 安装 Skill

直接从 GitHub 安装，无需先 clone 本仓库：

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/wp-labs/wpl-check/main/install-skill.sh) wpl-rule-check
```

如果你想安装指定分支或 tag，而不是 `main`，先设置 `WPL_CHECK_REF=<branch-or-tag>`。

在 `wpl-check` 仓库根目录下：

```bash
bash install-skill.sh wpl-rule-check
```

为其他 agent host 安装到通用 skill 目录：

```bash
bash install-skill.sh wpl-rule-check --agent anthropic
bash install-skill.sh wpl-rule-check --agent gemini --target-dir ./dist/skills/wpl-rule-check
bash install-skill.sh wpl-rule-check --list-agents
```

## 说明

- 这个 skill bundle 会优先使用已安装的 `wpl-check`，否则会为仓库维护者回退到本地源码 checkout。
- 这个 skill bundle 现在在 `tools/skills/wpl-rule-check/agents/` 下包含 `openai`、`anthropic`、`gemini`、`cursor`、`cline`、`continue`、`generic` 的 host metadata。
- 从源码构建需要 Rust；通过 `https://get.warpparse.ai/inst-x.sh` 安装不需要。
- 通过 GitHub 脚本安装 skill 需要 `bash`、`curl` 和 `tar`，但不需要 Rust。
