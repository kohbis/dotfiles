---
name: coding-with-codex
description: Executes coding tasks — implementing features, fixing bugs, generating tests, scaffolding — using Codex CLI with workspace-write access. Trigger only when user explicitly says "coding with codex" or "/coding-with-codex".
disable-model-invocation: true
---

# Coding with Codex

## Command Template

```bash
codex exec \
  --model {MODEL} \
  --config model_reasoning_effort="{LEVEL}" \
  --sandbox workspace-write \
  --full-auto \
  --skip-git-repo-check \
  -C {WORKING_DIR} \
  "{PROMPT}" \
  {SUPPRESS_FLAG}
```

## Models

Model IDs live only in this table; everything else in this skill refers to the tier.

| Tier | Model ID |
|------|----------|
| frontier | `gpt-5.6-sol` |
| balanced | `gpt-5.6-terra` |
| fast | `gpt-5.6-luna` |

## Parameter Selection

| Task Type | Tier | Reasoning | Sandbox | --full-auto |
|-----------|-------|-----------|---------|-------------|
| New feature implementation | frontier | high | workspace-write | YES |
| Bug fix | frontier | xhigh | workspace-write | YES |
| Test generation | balanced | medium | workspace-write | YES |
| Scaffolding | balanced | medium | workspace-write | YES |
| Small changes | fast | medium | workspace-write | YES |

Parameter notes:
- frontier is the default; raise `model_reasoning_effort` to `xhigh` when the implementation requires deeper reasoning, debugging, or broader codebase context
- balanced is the tier for everyday `medium`-effort work such as test generation and scaffolding
- Use fast for simple or localized changes where speed matters more than depth
- Always use `workspace-write` + `--full-auto` — this skill is for executing changes
- `danger-full-access` (network access) requires explicit user confirmation
- Append `2>/dev/null` only if user requests hidden output

## Prompt Format

```
TASK: {clear, specific action to implement}
CONTEXT: {tech stack, relevant files/dirs, environment}
SPEC: {expected behavior, acceptance criteria, edge cases}
CONSTRAINTS: {style conventions, patterns to follow, what NOT to change}
```

## Rules

- Always include `--skip-git-repo-check`, `--model`, `--config model_reasoning_effort`, `--sandbox`
- Always use `workspace-write` + `--full-auto` (this skill writes files by default)
- **Confirm change scope with the user before execution** — ask which files/directories are in scope
- Never use `danger-full-access` without user confirmation
- Check git status before execution when the user has uncommitted changes

## Session Continuation

Resume previous session (inherits model and sandbox settings):

```bash
codex exec --skip-git-repo-check resume --last
# Or with additional instructions:
echo "{instructions}" | codex exec --skip-git-repo-check resume --last
```

## References

- [examples](references/examples.md) - Practical coding task examples
- [troubleshooting](references/troubleshooting.md) - Error handling and output formatting
