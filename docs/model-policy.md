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

## Provider adapters

The default adapter keeps Sol 6.1 or Sonnet 5.5 at all bands. Opus is an explicit
Claude model override, separate from the effort band:

```sh
scripts/model-policy select --runtime claude --access read --band high --model opus
scripts/model-policy render --runtime claude --model opus --output /tmp/model-profiles
scripts/model-policy check --runtime claude --model opus --output /tmp/model-profiles
```

Override rendering creates distinct `read_opus_<band>` and `write_opus_<band>`
native definitions in the explicit output directory. It does not change defaults
or install them. Do not render over the canonical source checkout. Prepare and
review a separate catalogue before installing optional definitions with the
ownership-aware installer; retain a unique catalogue identity for that package.
Do not bypass installed-copy ownership by copying files over local edits.

A spawning API that explicitly supports model and effort overrides can apply a
selected policy to a bounded role when that role's access boundary is equivalent.
This app requires fresh context for such overrides. Native clients may instead
require named definitions and a reload. Use the declared name, inspect active
configuration and report runtime rejection separately from missing files.
A readable definition is not evidence of model access or enforced permissions.

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
