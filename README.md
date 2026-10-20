# Personal execution profiles

This repository separates task responsibility, access, reasoning effort and
provider model choice. The handoff defines the role and owned paths. A native
profile provides the read or write boundary and the selected reasoning band.

[model-policy.json](model-policy.json) is the canonical policy. Generated Codex
TOML, Claude Code Markdown and OpenCode Markdown are committed so installation needs only Bash and
standard utilities. Ordinary tasks default to **low** effort, **standard** speed,
`gpt-6.1-sol` in Codex and `claude-sonnet-5-5` in Claude Code. Increasing effort
does not automatically change the provider model.

## Bands and names

| Band | Task evidence |
| --- | --- |
| `low` | Clear local change, inventory, mapping or status observation. |
| `medium` | Bounded analysis or implementation with interacting cases. |
| `high` | Consequential judgement, substantive review or material failure risks. |
| `xhigh` | Difficult synthesis of a small, complete evidence packet. |
| `max` | Difficult investigation or complete-diff review requiring sustained reasoning. |

Each band has `read_<band>` and `write_<band>` profiles: Sol in Codex,
Sonnet in Claude. Claude also installs `read_opus_<band>` and
`write_opus_<band>` at every band. Model capability and reasoning effort are
independent choices: Sonnet high and Opus low are both available. `read_deep`
remains an alias for `read_max`; `read_exceptional` remains an alias for
`read_xhigh`. Existing declared names remain available.

The invoking skill classifies the bounded task, selects read or write access,
then chooses model and effort separately. Sonnet is the ordinary Claude choice;
Opus is available for difficult ambiguity, architecture tradeoffs or synthesis
that warrants its capability. A Sonnet lead can delegate to Opus; an Opus lead
should return routine work to Sonnet at suitable effort. Access and ownership
stay unchanged across model switches. The lead's own settings are unchanged.
See [selection and provider capabilities](docs/model-policy.md).

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

## Maintain the policy

Generation and selection require Python 3.11 or newer; installation and removal
do not require Python. Edit the canonical policy and regenerate its definitions:

```sh
scripts/model-policy render
scripts/model-policy check
scripts/model-policy select --runtime codex --access write
scripts/model-policy select --runtime claude --access read --band high
```

`select` resolves an already graded task; it does not infer complexity from prose
or verify a live client's effective settings. Keep provider-specific configuration
in the renderer and model adapter, rather than adding unsupported native fields.

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
the source changes. Another prefix, such as `tjpeel-sample-*`, is left alone.
Missing definitions are harmless during removal; `--check` still reports them
with a non-zero status.

Run the uninstaller before renaming or removing a profile folder, since it uses
the current folders to determine its exact removal targets. It does not remove
legacy `personal--*` links; inspect and remove those manually if they are no
longer wanted.

## Validate a change

Run `tests/test-model-policy`, `tests/test-install-agents`, `tests/test-check-public-content`,
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

OpenCode with Synthetic is also supported:

```sh
scripts/install-agents --runtime opencode --prefix tjpeel
```

The default model is `synthetic/hf:moonshotai/Kimi-K3`. Read and write workload
profiles use native OpenCode permissions and do not invent effort controls.
See [the model policy](docs/model-policy.md#opencode-with-synthetic) for discovery,
refresh, removal and the permission boundary.

## Measure source context material

`scripts/context-inventory` is an optional offline development command requiring
Python 3.9 or later. It prints deterministic JSON with relative paths, byte
lengths, SHA-256 hashes and a catalogue fingerprint. Redirect it to a file outside
the repository to retain a comparison baseline. `--root PATH` selects a disposable
source catalogue for checks. It does not install, edit or invoke definitions.

The report measures available source files, including internal linked resources.
It does not establish which instructions were loaded, token counts, context
occupancy or behavioural equivalence. Compare the fingerprint alongside native
usage, completion, repairs and independently adjudicated findings when tuning.
External resource links fail without emitting a partial inventory.

Run `tests/test-context-inventory` with the ordinary repository checks. Python is
required only for this optional report and its tests, not native installation.
