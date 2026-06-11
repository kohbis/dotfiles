---
name: reviewing-with-codex
description: Executes code review, analysis, and technical research using Codex CLI. Trigger only when user explicitly says "reviewing with codex" or "/reviewing-with-codex".
disable-model-invocation: true
---

# Reviewing with Codex

## Boundaries — deliver the review, don't publish it

Unless the user gives an explicit instruction to do so, this skill produces a review for the user to read and does not publish anything to GitHub. Posting a comment or approval is an outward-facing action with real consequences — it notifies people, can gate a merge, and is awkward to retract — so absent a clear instruction that call belongs to the user, not the reviewer. Keep Codex in `read-only` (see below) and, without such an instruction, do not run write operations such as:

- `gh pr review` / `gh pr review --approve` — approving or requesting changes on a PR
- `gh pr comment` / `gh pr review --comment` — posting review comments
- `gh issue comment` — commenting on an issue
- `gh api ...` calls that do the equivalent

Deliver the findings in the conversation. If the user wants them on GitHub, they post them — or they explicitly ask you to, in which case confirm the exact PR/target first.

## Command Template

```bash
codex exec \
  --model {MODEL} \
  --config model_reasoning_effort="{LEVEL}" \
  --sandbox {SANDBOX_MODE} \
  {AUTO_FLAG} \
  --skip-git-repo-check \
  -C {WORKING_DIR} \
  "{PROMPT}" \
  2>/dev/null
```

Codex writes the final assistant message to stdout and routes the progress UI, exec trace, and `tokens used` block to stderr. When the calling shell combines stdout and stderr into a single bounded capture buffer, the verbose stderr can crowd out or truncate the final stdout line, so the template suppresses stderr by default to keep the answer reliably extractable. Re-run without `2>/dev/null` when codex exits non-zero so the error is visible.

## Parameter Selection

| Task Type | Model | Reasoning | Sandbox | --full-auto |
|-----------|-------|-----------|---------|-------------|
| Complex bug investigation | gpt-5.5 | xhigh | read-only | NO |
| Standard code review | gpt-5.5 | high | read-only | NO |
| Infrastructure analysis | gpt-5.5 | high | read-only | NO |
| CI/CD optimization | gpt-5.5 | medium | read-only | NO |
| Quick code question | gpt-5.4-mini | medium | read-only | NO |

Parameter notes:
- `gpt-5.5` is the default; raise `model_reasoning_effort` to `xhigh` for deep investigations, cross-cutting infrastructure analysis, and research-heavy review
- Use `gpt-5.4-mini` for quick, low-risk questions where latency matters
- Default sandbox to `read-only`; for file editing tasks use the `coding-with-codex` skill instead
- `danger-full-access` (network access) requires explicit user confirmation
- Add `--full-auto` only with `workspace-write`
- Keep `2>/dev/null` on by default; drop it only when investigating a non-zero exit from codex

## Prompt Format

```
TASK: {clear, specific action}
CONTEXT: {tech stack, environment, constraints}
FOCUS: {specific areas to examine}
OUTPUT: {desired format and detail level}
```

## Rules

- Always include `--skip-git-repo-check`, `--model`, `--config model_reasoning_effort`, `--sandbox`
- Never use `danger-full-access` without user confirmation
- Never use `--full-auto` with `read-only`

## Session Continuation

Resume previous session (inherits model and sandbox settings):

```bash
codex exec --skip-git-repo-check resume --last
# Or with additional instructions:
echo "{instructions}" | codex exec --skip-git-repo-check resume --last
```

## References

- [examples](references/examples.md) - Practical usage patterns
- [troubleshooting](references/troubleshooting.md) - Error handling and output formatting
- [reviewing-code skill](../reviewing-code/SKILL.md) - Tool-agnostic alternative: use this when Codex CLI is not available
