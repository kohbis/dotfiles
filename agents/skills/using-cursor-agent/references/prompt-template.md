# Prompt template

Fill in the braces and drop any section that has nothing to say.

```markdown
{One-line task}, in this repository ({language / tool}). Read AGENTS.md / CLAUDE.md first and follow its conventions. Do NOT commit, push, or create branches; leave changes in the working tree.

## Behavior

- {User-visible behavior, flags, outputs}
- {Edge cases and how each one is reported}
- {What stays unchanged (exit status, existing output)}

## Implementation constraints

- {Where the logic lives; the module or type to extend}
- {Interfaces and modules that must NOT change}
- {Output, JSON, and help-text conventions to match, with the file to imitate}
- {Docs to update minimally, or "stop and report if X" for risky assumptions}

## Tests

- {Cases to add, with the file and existing helpers to reuse}
- {Test-stability notes, if any (e.g. timing-dependent code paths)}

## Verify before finishing

{Environment quirks that would otherwise derail it.}
Run and make pass: `{build}`, `{test}`, and `{lint}`. Report the results and a short summary of changed files.
```

## Example (adding a `--fail-fast` flag to a CLI)

```markdown
Implement `--fail-fast` for the `exec` subcommand in this repository. Read AGENTS.md / CLAUDE.md first and follow its conventions. Do NOT commit, push, or create branches; leave changes in the working tree.

## Behavior

- New boolean flag `--fail-fast` on `exec`: after the command fails in one repository, do not start it in any repository that has not started yet.
- Repositories already running (with `--jobs` > 1) are allowed to finish; never kill processes.
- A repository missing from the workspace is not a failure and must not trigger the stop.
- Repositories not started because of the stop are reported as "cancelled", distinct from "missing".

## Implementation constraints

- Logic lives in the runner module, not the CLI layer. Add the option to the runner's existing options type.
- Do NOT change the parallel-execution module. Inside its per-item callback, check a shared thread-safe flag before running; set it when a run fails.
- JSON: status `"cancelled"`, no `exit_code` metric, summary key `"cancelled"`.

## Tests

- Sequential stop; no fail-fast; missing before failure; `--jobs` > 1 with count invariants only.

## Verify before finishing

Run and make pass the build, test, and lint commands listed in AGENTS.md. Report the results and a short summary of changed files.
```
