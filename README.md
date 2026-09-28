# Personal execution profiles

This repository is the version-controlled source of reusable execution
profiles for Codex and Claude Code. A profile sets the required effort and
write boundary; the calling skill supplies the task-specific role, scope, and
required output.

Each top-level profile folder contains one or both runtime-specific
definitions:

```text
my-agent/
  codex/
    agent.toml
  claude/
    agent.md
```

`codex/agent.toml` defines the profile name, model, reasoning effort, sandbox,
and shared instructions. `claude/agent.md` carries the equivalent behavioural
contract in YAML frontmatter and a prompt body. Claude users select their
model and permission settings separately.

## Profiles

| Profile | Purpose | Codex settings |
| --- | --- | --- |
| `read_low` | Bounded inventories, mapping, and quick evidence checks | Luna / low / read-only |
| `read_medium` | Analysis, drafting, and evidence or acceptance audits | Terra / medium / read-only |
| `read_high` | Material risk analysis, complex planning, and independent review | Sol / high / read-only |
| `read_exceptional` | Small, evidence-complete synthesis where higher-cost judgment is justified | Astra / high / read-only |
| `write_medium` | One scoped implementation or local artifact change | Terra / medium / workspace-write |

Select the least sufficient profile. Do not create task-specific agent personas:
put the task, constraints, source material, and output shape in the handoff.

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

## Add a profile

Create `my-profile/codex/agent.toml`:

```toml
name = "my_profile"
description = "One sentence explaining this effort and access profile."
developer_instructions = """
Perform the bounded task in the handoff without exceeding this profile's access boundary.
"""
```

Create `my-profile/claude/agent.md` when the profile should also be available to
Claude Code:

```md
---
name: my_profile
description: One sentence explaining this effort and access profile.
---

Perform the bounded task in the handoff without exceeding this profile's access boundary.
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

The installer creates links named `personal--my-profile.toml` or
`personal--my-profile.md`. Codex identifies a custom agent by the TOML `name`
field; Claude uses the Markdown frontmatter. The installed filename is safely
namespaced without changing the profile's declared name.

## Migrate legacy roles safely

The old task-role definitions are deliberately not removed by `--sync`: it
only manages this repository's prefixed symlinks. Archive explicitly named
legacy installed definitions before installing the profiles. For Codex:

```zsh
./scripts/install-agents --runtime codex --prefix personal --sync \
  --archive-name adr_synthesizer --archive-name code_mapper \
  --archive-name decision_evidence_analyst --archive-name history_indexer \
  --archive-name implementer --archive-name pr_reviewer \
  --archive-name risk_adjudicator --archive-name ticket_editor \
  --archive-name ticket_planner --archive-name validation_auditor
```

Use the same command with `--runtime claude` to archive matching Claude
definitions. The installer moves only explicitly named, non-symlink files into
an archive beneath the target directory and reports every move.

## Check current state

```zsh
./scripts/install-agents --runtime codex --prefix personal --check ~/.codex/agents
./scripts/install-agents --runtime claude --prefix personal --check ~/.claude/agents
```

`--check` exits non-zero for missing, stale, or conflicting links. `--install`
adds only missing links and refuses to overwrite anything. `--sync` removes
only symlinks whose name starts with this repository's prefix for the selected
runtime, then recreates the links. It never removes a real file or directory.
