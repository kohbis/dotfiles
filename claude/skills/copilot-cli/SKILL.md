---
name: copilot-cli
description: Execute coding, review, and GitHub operations using GitHub Copilot CLI in programmatic mode. Trigger only when user explicitly says "copilot cli" or "/copilot-cli".
---

# Copilot CLI

## Command Template

### Programmatic Mode (non-interactive, for automation)

```bash
copilot -p "{PROMPT}" \
  --model {MODEL} \
  {TOOL_FLAGS}
```

### Interactive Mode (for exploratory tasks)

```bash
copilot \
  --model {MODEL} \
  {TOOL_FLAGS}
```

## Parameter Selection

| Task Type | Model | Tool Permissions |
|-----------|-------|-----------------|
| New feature / coding | claude-sonnet-4-6 | `--allow-tool 'shell(*:*)' --allow-tool write` |
| Complex architecture / debugging | claude-opus-4-6 | `--allow-tool 'shell(*:*)' --allow-tool write` |
| Code review / analysis | gpt-5.3-codex | read-only (no `--allow-tool write`) |
| Quick question | claude-sonnet-4-6 | minimal (no tool flags) |

Parameter notes:
- `-p` flag enables programmatic (non-interactive) mode — use this for automation
- `--model` selects the underlying model; default to `claude-sonnet-4-6` for most tasks
- `--allow-tool` grants specific tool access; omit for read-only analysis
- **Never use `--allow-all-tools`** without explicit user confirmation — prefer granular `--allow-tool` flags
- Use `--trust-dir .` to trust the current working directory when needed

## Prompt Format

```
TASK: {clear, specific action to perform}
CONTEXT: {tech stack, relevant files/dirs, environment}
SPEC: {expected behavior, acceptance criteria, edge cases}
CONSTRAINTS: {style conventions, patterns to follow, what NOT to change}
```

For review/analysis tasks:

```
TASK: {clear, specific action}
CONTEXT: {tech stack, environment, constraints}
FOCUS: {specific areas to examine}
OUTPUT: {desired format and detail level}
```

## Rules

- Always include `--model` to ensure consistent behavior
- Use `-p` for programmatic execution; omit for interactive exploration
- **Confirm change scope with the user before execution** when using write tools
- Never use `--allow-all-tools` without explicit user confirmation
- Prefer granular `--allow-tool` over broad permissions
- Check git status before execution when the user has uncommitted changes

## Slash Commands (Interactive Mode)

| Command | Use Case |
|---------|----------|
| `/plan` | Create an implementation plan before coding |
| `/review` | Review code changes or PR diffs |
| `/delegate` | Delegate a subtask to a background agent |
| `/fleet` | Run multiple agents in parallel |

## References

- [examples](references/examples.md) - Practical usage patterns
- [troubleshooting](references/troubleshooting.md) - Error handling and output formatting
