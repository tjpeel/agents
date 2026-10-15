# Select a bounded task

Choose the responsibility and permitted paths first, then choose a reasoning
band from current evidence. A quick inventory or clear local edit starts at low;
interacting cases can justify medium. Consequential review or material security,
data-loss, migration or concurrency risks can justify high. Use xhigh for
selected difficult synthesis and max for sustained difficult investigation.
These bands are workload choices, not measured equivalence across providers.

State a short reason for higher effort in the handoff. Do not add an approval
step, mandatory failed attempt, repair-cycle limit or extra reviewer merely to
change bands. Reuse an existing owner when its permissions and settings fit.
Keep role, evidence, owned paths and expected output separate from model,
effort and speed. No profile authorises work beyond the user's requested scope.

## Choose model separately from effort

The calling skill makes the work classification; this offline script resolves
an explicit choice and generates definitions. It does not read a task prompt,
spawn agents, install profiles or change a running lead. Installed skills carry
the decision guide and do not need Python or this checkout at runtime.

Use Sonnet for ordinary Claude tasks, including high-effort work with a clear
approach. Choose Opus when difficult ambiguity, competing architectural choices,
cross-cutting constraints or synthesis justify a stronger model. Effort measures
how much reasoning the selected model should apply; high effort does not require
Opus, and choosing Opus does not require high effort. These are starting points
for judgement, not measured capability guarantees.

The standard Claude installation includes both models at every band:

| Model | Read profile | Write profile |
| --- | --- | --- |
| Sonnet 5.5 | `read_<band>` | `write_<band>` |
| Opus 5.5 | `read_opus_<band>` | `write_opus_<band>` |

Codex retains Sol 6.1 and `read_<band>` / `write_<band>`; no second Codex model
is configured. Do not invent an unsupported model route.

```sh
scripts/model-policy select --runtime claude --access write --band high --model sonnet
scripts/model-policy select --runtime claude --access write --band medium --model opus
scripts/model-policy render
scripts/model-policy check
```

The first selection resolves to `write_high`; the second to
`write_opus_medium`. Omitting `--model` preserves the default Sonnet or Sol
choice. Default rendering produces 12 Codex and 22 Claude definitions, including
legacy names. The normal installer installs all definitions for its runtime.
Filtered rendering with `--runtime claude --model opus --output /tmp/model-profiles`
is still available for inspection; a separate output is required when filtering
by model so canonical definitions cannot be overwritten by a partial catalogue.

When new evidence warrants Opus, hand off the unresolved problem and relevant
artifacts to the selected Opus profile. A delegate can recommend this change;
the coordinator owns reassignment. Stop the existing writer before transferring
its paths. Once the difficult decision is settled, give remaining mechanical
work or observation to Sonnet at the least sufficient effort. Apply this in
both directions regardless of the lead's model. Reuse an owner only when its
model, effort and permissions still fit; never describe a pinned Opus owner as
Sonnet merely by changing its prompt.

A spawning API that supports explicit model and effort overrides may apply the
same choices to an equivalent access boundary. Otherwise use installed declared
names. Respect explicit user model restrictions. If a selected profile is
unavailable or rejected, report that fact and the actual fallback settings;
do not silently claim a model switch. Readable files do not prove live access,
spawning or enforced permissions.

## Speed intent

Standard is the default policy intent. The generated profiles do not assert an
unsupported speed field or a measured live service tier. Official Codex config
supports `service_tier`, but the effective tier in a running app may be unknown;
check the active client's documented capability and exposed settings before
claiming a tier. Do not infer speed from reasoning effort or model name.

Claude Fast mode supports selected Opus models and uses paid usage credits.
Sonnet Fast must not silently switch to Opus. If Fast is requested with Sonnet,
report the incompatible choice and retain the selected model until the user
chooses a supported route. Configure speed only through the official client's
supported controls; do not invent agent frontmatter fields. Model access, client
support and observed speed remain live-test questions.

## Compatibility and testing

Keep all six previous declared names. Refresh with the existing installer:
unchanged owned copies and exact legacy symlinks migrate; local edits and foreign
files remain conflicts. New band profiles are additions, so no uninstall or
rename migration is required. Installed filenames carry a catalogue prefix,
but declared runtime names do not. Do not install duplicate declared names in
one active scope.

Before live testing, run `tests/test-model-policy`, `tests/test-install-agents`,
`tests/test-check-public-content`, `git diff --check` and
`scripts/check-public-content`. The policy suite exercises selection, all native
boundaries, invalid inputs, explicit overrides, alias compatibility, generation
drift and absence of Python before writes. Installation tests run without Python
or ripgrep on PATH and cover copied files, safe refresh, migration and removal.

For tomorrow's test, use disposable explicit targets for installation first.
Inspect the resulting declared names, model and effort, and verify `--check`
after `--refresh`. Review active user and project overrides before an authorised
live refresh, reload the official client, and run one bounded read task and one
scoped local writer task at low. Check a justified higher-band task separately;
confirm Sonnet stays selected unless Opus was explicitly requested. Record the
settings the client exposes, permissions actually observed, token/cache/context
measurements when available, and unknown values without guessing. Keep live
logs and account material outside this public source package.

No live installation, account connection, provider request or speed measurement
is part of the offline policy checks.

## Offline selection walkthrough

An independent instruction simulation exercised these representative cases:

| Input | Selection and handoff |
| --- | --- |
| Sonnet lead, ambiguous migration and competing designs | Opus high read-only decision packet; implementation stays with one writer afterward. |
| Opus max lead, settled design and routine edits/status | Sonnet low writer and factual observer; raise effort only for interacting cases. |
| Established implementation approach with interacting cases | Sonnet medium, or high when consequential judgement warrants it. |
| Writer discovers contradictory invariants | Return evidence to coordinator; stop the old writer before reassignment; downshift after resolution. |
| Required profile rejected by runtime | Disclose rejection and actual fallback; preserve user model restrictions and return a blocker when necessary. |

The walkthrough checked classification, read/write authority, expected outputs,
model changes in both directions, ownership transfer and fallback. It did not
spawn a provider model or verify live access, performance, settings or enforced
permissions. Automated checks separately cover all model/effort definitions,
blank installation, ownership-safe refresh and removal.
