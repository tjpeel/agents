# Personal agents repository conventions

## Validation and functional coverage

Before staging or committing any change, including documentation, run these
checks from the repository root:

```sh
tests/test-install-agents
tests/test-check-public-content
git diff --check
scripts/check-public-content
```

All required checks must pass before staging or committing. Resolve failures;
if a check cannot run, report the blocker and leave the affected changes
uncommitted.

Check Bash syntax with `bash -n` separately for each shell script and sourced
library in `scripts/` and `tests/`. Passing several filenames to one
`bash -n` invocation checks only the first script.

- Keep meaningful automated coverage for every executable entry point, shared
  library and documented mode. When adding, changing or removing functionality,
  identify the tests that cover its observable behaviour and update them with
  the implementation. Exercise libraries through their callers where possible.
- For a functional fix, add a regression case that fails before the fix and
  passes afterward. Assert output, exit status and filesystem effects; a
  successful exit alone is insufficient. Cover both runtimes and relevant
  invalid input, malformed definitions or ownership metadata, conflicts,
  local-edit preservation, refresh, removal and failed writes.
- Run portable tooling tests with a restricted `PATH` containing only
  documented baseline dependencies. Optional developer tools such as `rg`
  must be absent. Document any new required command and test its absence and
  relevant failure modes. Missing dependencies must produce a clear error
  before dependent writes.
- Preserve failures across pipelines, command substitution and process
  substitution. Test failed discovery, scans and partial output where relevant.
  An incomplete operation must not report success or describe an environment
  failure as invalid content. Test optional fallbacks as well as required
  commands.
- Keep tests in temporary directories with explicit targets. Do not use the
  user's live agent directories, credentials, network services or external
  writes. Build synthetic sensitive-content fixtures at runtime rather than
  storing credential-shaped strings in the repository.
- Validate changed definitions' syntax, required fields, declared names, model
  and effort settings, and read/write boundaries separately from copying.
  Installation tests do not prove live discovery, spawning, model access or
  enforced runtime permissions. Record the evidence for any live check and
  identify what remains unverified.
- Do not add tests that merely match documentation wording or mirror an
  implementation. Keep the required command list current as suites are added.
  Report any required check that cannot run; do not call it a pass.

## Commit identity

Use the `tjpeel` GitHub identity and a signing key registered to that account.
Before committing, check the effective author email, signing configuration
and key ownership, then verify the resulting signature. Do not disable signing
or use another account's key when the required key is unavailable. Keep any
repository-specific Git configuration local to this checkout.

## Public-release gate

This repository may become public. Treat the absence of sensitive information
as a hard release gate for every changed or added file, including Codex TOML
definitions, Claude Markdown definitions, scripts, documentation, examples,
and assets.

- Never add credentials, tokens, private keys, connection strings, personal
  data, private URLs or hostnames, internal repository names or paths, customer
  information, screenshots containing private data, or non-public ticket and
  incident details.
- Before staging or committing, inspect every changed file and run
  `scripts/check-public-content`. Treat any finding as a blocker until the
  content is removed or replaced with a generic placeholder.
- The automated check is a backstop, not proof that content is safe to publish;
  perform the manual review even when it passes.

- Treat changes to this repository as version-controlled deliverables.
- After modifying an agent definition or its supporting files, validate the
  change, inspect `git diff` and `git status`, run the public-release gate,
  stage only files relevant to the requested work, and create a focused commit
  unless the user says not to.
- Never commit secrets, generated caches, or unrelated pre-existing changes.
