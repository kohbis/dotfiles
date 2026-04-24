---
name: codex-coding
description: Execute coding tasks — implementing features, fixing bugs, generating tests, scaffolding — using Codex CLI with workspace-write access. Trigger only when user explicitly says "codex coding" or "/codex-coding".
disable-model-invocation: true
---

# Codex Coding

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

## Parameter Selection

| Task Type | Model | Reasoning | Sandbox | --full-auto |
|-----------|-------|-----------|---------|-------------|
| New feature implementation | gpt-5.4 | high | workspace-write | YES |
| Bug fix | gpt-5.5 | xhigh | workspace-write | YES |
| Test generation | gpt-5.4 | medium | workspace-write | YES |
| Scaffolding | gpt-5.4 | medium | workspace-write | YES |
| Small changes | gpt-5.4-mini | medium | workspace-write | YES |

Parameter notes:
- `gpt-5.4` is the default for everyday coding tasks
- Use `gpt-5.5` when the implementation requires deeper reasoning, debugging, or broader codebase context
- Use `gpt-5.4-mini` for simple or localized changes where speed matters more than depth
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
