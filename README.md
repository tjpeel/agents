# Personal Codex agents

This repository is the version-controlled source of personal Codex and Claude
custom-agent definitions. Each top-level agent folder can contain one or both
runtime-specific definitions:

```text
my-agent/
  codex/
    agent.toml
  claude/
    agent.md
```

`codex/agent.toml` must define `name`, `description`, and
`developer_instructions`. `claude/agent.md` uses YAML frontmatter followed by
its system-prompt body.

## Public-release gate

This repository may be made public. No sensitive or internal information may be
committed: credentials, tokens, private keys, connection strings, personal or
customer data, private URLs or hostnames, internal repositories or paths,
non-public tickets or incidents, or screenshots containing private data.

Before every commit, review the complete diff and run:

```zsh
scripts/check-public-content
```

The check detects common secret formats; it does not replace a deliberate
human review of every changed agent definition, supporting file, and example.

## Add an agent

Create `my-agent/codex/agent.toml`:

```toml
name = "my_agent"
description = "One sentence explaining when this agent should be used."
developer_instructions = """
Perform this focused task. Do not expose sensitive information.
"""
```

Create `my-agent/claude/agent.md` when the agent should also be available to
Claude Code:

```md
---
name: my-agent
description: One sentence explaining when this agent should be used.
---

Perform this focused task. Do not expose sensitive information.
```

## Install or refresh

```zsh
./scripts/install-agents --runtime codex --prefix personal --sync ~/.codex/agents
./scripts/install-agents --runtime claude --prefix personal --sync ~/.claude/agents
```

`--runtime` selects which configuration to install. `--prefix` is required and
must be unique per agent repository. The target defaults to the current user's
runtime-specific directory, so these shorter commands are equivalent:

```zsh
./scripts/install-agents --runtime codex --prefix personal --sync
./scripts/install-agents --runtime claude --prefix personal --sync
```

The installer creates links named `personal--my-agent.toml` or
`personal--my-agent.md`. Codex identifies a custom agent by the TOML `name`
field; Claude uses the Markdown frontmatter. The installed filename is safely
namespaced without changing the agent's declared name.

## Check current state

```zsh
./scripts/install-agents --runtime codex --prefix personal --check ~/.codex/agents
./scripts/install-agents --runtime claude --prefix personal --check ~/.claude/agents
```

`--check` exits non-zero for missing, stale, or conflicting links. `--install`
adds only missing links and refuses to overwrite anything. `--sync` removes
only symlinks whose name starts with this repository's prefix for the selected
runtime, then recreates the links. It never removes a real file or directory.
