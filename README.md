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
contract in YAML frontmatter and a prompt body. Claude definitions pin an
appropriate model and tool boundary: read profiles can only inspect files,
while the write profile uses Claude's standard permission prompts for local
changes. Profiles set Claude subagent effort explicitly; session permissions and
approvals still apply. Model availability depends on the account and provider.

## Profiles

| Profile | Purpose | Codex | Claude Code |
| --- | --- | --- | --- |
| `read_low` | Bounded inventories, mapping and quick evidence checks | Sol 6.1 / low | Sonnet 5.5 / low |
| `read_medium` | Analysis, drafting and evidence or acceptance audits | Sol 6.1 / medium | Sonnet 5.5 / medium |
| `read_high` | Material risk analysis, complex planning and independent review | Sol 6.1 / high | Opus 5.5 / high |
| `read_deep` | Selected difficult investigations and complete-diff reviews | Sol 6.1 / max | Opus 5.5 / max |
| `read_exceptional` | Small synthesis from complete evidence | Sol 6.1 / xhigh | Opus 5.5 / xhigh |
| `write_medium` | One scoped implementation or local artifact change | Sol 6.1 / medium | Sonnet 5.5 / medium |

Codex definitions pin `gpt-6.1-sol`; Claude definitions pin
`claude-sonnet-5-5` or `claude-opus-5-5`. All read profiles keep read-only access;
`write_medium` retains its scoped local write boundary. Explicit effort settings
prevent a parent running at Ultra or max from raising every delegate's effort.
These are workload-based starting points, not a claim of equal performance
between providers. Compare actual task quality before changing a level.

Use low for locating facts and medium for a bounded analysis or implementation.
Use `read_high` as the default for independent review and when judgement or
consequential failure paths need scrutiny. Opt into `read_deep` at max only for
a selected difficult investigation or complete-diff review whose evidence or
insufficient lower-effort result justifies it. Keep its source, callers and
tests bounded in the handoff. Use `read_exceptional` at xhigh only with a small,
completed evidence packet that still needs difficult synthesis.

A coordinator running at Ultra does not raise delegate effort. Client Ultra
orchestration and the profiles' explicit reasoning effort are distinct settings;
choose each delegate's profile for its assigned task. These choices make no
claim of measured savings or equivalent quality between effort levels.

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
model = "gpt-6.1-sol"
model_reasoning_effort = "low"
sandbox_mode = "read-only"
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
tools: Read, Glob, Grep
model: claude-sonnet-5-5
effort: low
---

Perform the bounded task in the handoff without exceeding this profile's access boundary.
```

## Install missing profiles

The installer uses Bash and standard command-line utilities; ripgrep (`rg`) is
not required.

```zsh
./scripts/install-agents --runtime codex --prefix tjpeel ~/.codex/agents
./scripts/install-agents --runtime claude --prefix tjpeel ~/.claude/agents
```

`--runtime` selects which configuration to install. `--prefix` is required and
must be unique per agent repository. The target defaults to the current user's
runtime-specific directory, so these shorter commands are equivalent:

```zsh
./scripts/install-agents --runtime codex --prefix tjpeel
./scripts/install-agents --runtime claude --prefix tjpeel
```

The installer creates regular files named `tjpeel-my-profile.toml` or
`tjpeel-my-profile.md`. Codex identifies a custom agent by the TOML `name`
field; Claude uses the Markdown frontmatter. The copied definition keeps its
stable internal name so existing skill handoffs continue to work. Ownership
comments record the catalogue identifier, relative source and a content
checksum; they contain no local repository path. Claude frontmatter remains at
the start of the file.
The copy does not require this checkout to remain available.

`catalogue-id` is a stable public UUID identifying this catalogue across its
checkouts. Keep it unchanged when cloning or moving this repository. When
copying this structure to create a separate catalogue, generate a new UUID
before installing any definitions. Refresh and removal require that identifier
as well as the profile path and checksum, so matching filenames in another
catalogue are insufficient to establish ownership.

For Codex, the default respects `CODEX_HOME` when set. Prefixes distinguish
installed filenames, not runtime agent names; avoid installing two definitions
with the same declared name in one scope.

## Check current state

```zsh
./scripts/install-agents --runtime codex --prefix tjpeel --check ~/.codex/agents
./scripts/install-agents --runtime claude --prefix tjpeel --check ~/.claude/agents
```

`--check` exits non-zero for missing, stale, legacy or conflicting definitions.
The default `--install` mode adds only missing files and leaves existing paths
untouched. It reports old repository symlinks as `legacy` and unchanged copies
whose source has changed as `stale`; use `--refresh` for those cases.

Definitions are now regular files, so file inventories such as `rg --files`
can find them without following symlinks. For an older installation, inspect
symlinked definitions too. Use the declared `name` with the live spawning tool;
a readable file or advertised profile alone does not prove the current session
can spawn it. If the tool rejects it, report that response separately from a
missing definition. Check project-scoped overrides and reload the client when
it still uses an old definition. Do not guess prefixed filename aliases.

## Refresh or remove this repository's profiles

Refresh owned definitions and migrate this repository's exact legacy links:

```zsh
./scripts/install-agents --runtime codex --prefix tjpeel --refresh
./scripts/install-agents --runtime claude --prefix tjpeel --refresh
```

Refresh atomically replaces an unchanged owned copy or an exact symlink to this
repository. It leaves unowned files, foreign links and locally edited copies
untouched and reports a conflict. The checksum detects local edits; it is an
ownership safeguard against accidental replacement, not an authentication
mechanism. Review a conflict before choosing how to reconcile it.

To remove profiles, use the separate uninstaller:

```zsh
./scripts/uninstall-agents --runtime codex --prefix tjpeel ~/.codex/agents
./scripts/uninstall-agents --runtime claude --prefix tjpeel ~/.claude/agents
```

It removes only this repository's unchanged owned copies or exact legacy links
for the current profile names. An unchanged older copy remains removable after
the source changes. Another prefix, such as `tjpeel-ee-*`, is left alone.

Run the uninstaller before renaming or removing a profile folder, since it uses
the current folders to determine its exact removal targets. It does not remove
legacy `personal--*` links; inspect and remove those manually if they are no
longer wanted.

## Validate a change

Run `tests/test-install-agents`, `tests/test-check-public-content`,
`git diff --check` and `scripts/check-public-content`. Both test suites use
temporary directories and run without ripgrep on `PATH`. The installer suite
checks regular-file discovery, stable names, legacy migration, source refresh,
foreign-catalogue and local-edit protection, and exact removal. It does not prove
that a running Codex or Claude session can spawn a profile or access a pinned
model.

The public-content suite checks credential detection, hidden and binary files,
exclusions, and failure when file traversal or scanning cannot complete.

## References

Profile configuration and effort choices draw on OpenAI's
[custom agent documentation](https://learn.chatgpt.com/docs/agent-configuration/subagents)
and [Sol 6.1 model documentation](https://developers.openai.com/api/docs/models/gpt-6.1-sol),
and Anthropic's [subagent configuration](https://code.claude.com/docs/en/sub-agents),
[model overview](https://platform.claude.com/docs/en/models/overview) and
[effort guidance](https://platform.claude.com/docs/en/build-with-claude/effort).
