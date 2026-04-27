---
name: copilot-cli
description: Execute coding, review, and GitHub operations using GitHub Copilot CLI in programmatic mode. Trigger only when user explicitly says "copilot cli" or "/copilot-cli".
disable-model-invocation: true
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
| New feature / coding | claude-sonnet-4.6 | `--allow-tool 'shell(*:*)' --allow-tool 'write(*:*)'` |
| Test generation | claude-sonnet-4.6 | `--allow-tool 'shell(*:*)' --allow-tool 'write(*:*)'` |
| Documentation writing | claude-sonnet-4.6 | `--allow-tool 'write(*:*)'` |
| Complex architecture / debugging | claude-opus-4.7 | `--allow-tool 'shell(*:*)' --allow-tool 'write(*:*)'` |
| Code review / analysis | gpt-5.4 | `--allow-tool 'shell(read:*)'` (no write) |
| GitHub operations | claude-sonnet-4.6 | `--allow-tool 'shell(*:*)'` (no write) |
| Quick question | claude-sonnet-4.6 | minimal (no tool flags) |

Parameter notes:
- `-p` flag enables programmatic (non-interactive) mode — use this for automation
- `--model` selects the underlying model; this skill pins `claude-sonnet-4.6` for everyday tasks rather than relying on GitHub's evolving default
- Use `claude-opus-4.7` when the task needs deeper reasoning across multiple files or systems
- Model IDs use **dot notation** in the CLI: `claude-sonnet-4.6`, `claude-opus-4.7` (not hyphens)
- For Copilot CLI, prefer explicit versioned model names over aliases; do not assume bare aliases like `sonnet`, `opus`, or `haiku` are accepted
- `--allow-tool 'write(*:*)'` grants write access to files; `--allow-tool 'shell(*:*)'` grants shell command execution
- **Never use `--allow-all-tools`** without explicit user confirmation — prefer granular `--allow-tool` flags
- `--trust-dir .` is required when copilot needs to read/write files in the current directory that are outside its default trust scope. Typically needed when working outside `$HOME` or in unusual mount paths.
- **Sonnet → Opus escalation**: Use Opus when the task spans >3 files, involves architectural decisions, or requires understanding complex interdependencies across the codebase.

## Prompt Format

For coding tasks:

```
TASK: {clear, specific action to perform}
CONTEXT: {tech stack, relevant files/dirs, environment — list specific paths, not entire repos}
SPEC: {expected behavior, acceptance criteria, edge cases}
CONSTRAINTS: {style conventions, patterns to follow}
SCOPE: {what NOT to change or touch}
```

For review/analysis tasks:

```
TASK: {clear, specific action}
CONTEXT: {tech stack, environment, constraints}
FOCUS: {specific areas to examine}
OUTPUT: {desired format and detail level}
```

For GitHub operations:

```
TASK: {GitHub action to perform}
CONTEXT: {repo state, branch, relevant history}
SPEC: {expected output format, labels, target branch}
```

> **Note:** For simple quick questions, the structured format is optional — plain natural language is sufficient.

## Rules

- Always include `--model` to ensure consistent behavior
- Use `-p` for programmatic execution; omit for interactive exploration
- Keep Copilot model names version-pinned unless GitHub documents alias support explicitly
- **Confirm change scope with the user before execution** when using write tools
- Never use `--allow-all-tools` without explicit user confirmation
- Prefer granular `--allow-tool` over broad permissions
- Check git status before execution when the user has uncommitted changes

## Slash Commands (Interactive Mode)

| Command | Use Case |
|---------|----------|
| `/plan` | Create an implementation plan before coding — use first for complex or multi-file tasks |
| `/review` | Review code changes or PR diffs — use after implementing to catch issues |
| `/delegate` | Delegate a subtask to a background agent — use when a sub-problem can be solved independently |
| `/fleet` | Run multiple agents in parallel — use when the task decomposes into independent subtasks (e.g., generate tests for 5 modules simultaneously) |

## Session Continuation

GitHub Copilot CLI does not natively support session resumption. If a task is interrupted or needs continuation:
- Re-run with the original prompt plus additional instructions appended
- Use `git diff` to identify what was already completed and scope the continuation prompt accordingly

## When to Use This Skill vs. Alternatives

- For pure coding tasks without GitHub operations → consider `codex-coding`
- For pure code review without write needs → consider `codex-review`
- For GitHub-specific operations (PR, issues) → this skill is preferred

## References

- [examples](references/examples.md) - Practical usage patterns
- [troubleshooting](references/troubleshooting.md) - Error handling and output formatting
