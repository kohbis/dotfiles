---
name: using-codex
description: Runs Codex CLI for code review, analysis, and technical research (read-only) or for coding tasks — implementing features, fixing bugs, generating tests, scaffolding (workspace-write). Trigger only when user explicitly says "using codex" or "/using-codex".
disable-model-invocation: true
---

# Using Codex

Two modes, chosen by what the task does to the files:

- **Review** — review, analysis, investigation, research. Sandbox `read-only`; Codex changes nothing.
- **Coding** — implementation, bug fixes, tests, scaffolding. Sandbox `workspace-write`: Codex can write inside `-C {WORKING_DIR}` and nowhere else.

## Boundaries — deliver the review, don't publish it

Unless the user gives an explicit instruction to do so, review mode produces a review for the user to read and does not publish anything to GitHub. Posting a comment or approval is an outward-facing action with real consequences — it notifies people, can gate a merge, and is awkward to retract — so absent a clear instruction that call belongs to the user, not the reviewer. Without such an instruction, do not run write operations such as:

- `gh pr review` / `gh pr review --approve` — approving or requesting changes on a PR
- `gh pr comment` / `gh pr review --comment` — posting review comments
- `gh issue comment` — commenting on an issue
- `gh api ...` calls that do the equivalent

Deliver the findings in the conversation. If the user wants them on GitHub, they post them — or they explicitly ask you to, in which case confirm the exact PR/target first.

In coding mode, **confirm the change scope with the user before execution** (which files/directories are in scope), and check `git status` first when the user has uncommitted changes.

## Command Template

```bash
codex exec \
  --model {MODEL} \
  --config model_reasoning_effort="{LEVEL}" \
  --sandbox {SANDBOX_MODE} \
  --skip-git-repo-check \
  -C {WORKING_DIR} \
  "{PROMPT}" \
  2>/dev/null
```

`{SANDBOX_MODE}` is `read-only` for review and `workspace-write` for coding.

Codex writes the final assistant message to stdout and routes the progress UI, exec trace, and `tokens used` block to stderr. When the calling shell combines stdout and stderr into a single bounded capture buffer, the verbose stderr can crowd out or truncate the final stdout line, so the template suppresses stderr by default to keep the answer reliably extractable. Re-run without `2>/dev/null` when codex exits non-zero so the error is visible.

## Models

Codex model IDs live only in this table; everything else refers to the tier.

| Tier | Model ID |
|------|----------|
| frontier | `gpt-5.6-sol` |
| balanced | `gpt-5.6-terra` |
| fast | `gpt-5.6-luna` |

## Parameter Selection

| Mode | Task Type | Tier | Reasoning |
|------|-----------|------|-----------|
| Review | Complex bug investigation | frontier | xhigh |
| Review | Standard code review | frontier | high |
| Review | Infrastructure analysis | frontier | high |
| Review | CI/CD optimization | balanced | medium |
| Review | Quick code question | fast | medium |
| Coding | New feature implementation | frontier | high |
| Coding | Bug fix | frontier | xhigh |
| Coding | Test generation | balanced | medium |
| Coding | Scaffolding | balanced | medium |
| Coding | Small changes | fast | medium |

Parameter notes:
- frontier is the default; raise `model_reasoning_effort` to `xhigh` for deep investigations, cross-cutting analysis, debugging, or changes that need broad codebase context
- balanced is the tier for everyday `medium`-effort work such as CI/CD review, test generation, and scaffolding
- Use fast for quick, low-risk questions or localized changes where latency matters more than depth
- `danger-full-access` (network access) requires explicit user confirmation

## Prompt Format

Review:

```
TASK: {clear, specific action}
CONTEXT: {tech stack, environment, constraints}
FOCUS: {specific areas to examine}
OUTPUT: {desired format and detail level}
```

Coding:

```
TASK: {clear, specific action to implement}
CONTEXT: {tech stack, relevant files/dirs, environment}
SPEC: {expected behavior, acceptance criteria, edge cases}
CONSTRAINTS: {style conventions, patterns to follow, what NOT to change}
```

## Rules

- Always include `--skip-git-repo-check`, `--model`, `--config model_reasoning_effort`, `--sandbox`
- Never use `danger-full-access` without user confirmation
- Never add `--approve-for-me`: it cannot be combined with `--sandbox`, and it auto-approves writes outside the working directory

## Session Continuation

Resume previous session (inherits model and sandbox settings):

```bash
codex exec --skip-git-repo-check resume --last
# Or with additional instructions:
echo "{instructions}" | codex exec --skip-git-repo-check resume --last
```

## References

- [examples](references/examples.md) - Review and coding examples
- [troubleshooting](references/troubleshooting.md) - Error handling and output formatting
- [reviewing-code skill](../reviewing-code/SKILL.md) - Tool-agnostic review: use this when Codex CLI is not available
