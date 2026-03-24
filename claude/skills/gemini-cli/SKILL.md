---
name: gemini-cli
description: Execute coding, review, and analysis tasks using Gemini CLI in non-interactive (headless) mode. Trigger only when user explicitly says "gemini cli" or "/gemini-cli".
---

# Gemini CLI

## Command Template

```bash
gemini -p "{PROMPT}" \
  --model {MODEL} \
  --approval-mode {MODE}
```

## Parameter Selection

| Task Type | Model | approval-mode |
|-----------|-------|--------------|
| Complex code review / debugging | gemini-2.5-pro | plan |
| Standard review / analysis | gemini-2.5-flash | plan |
| Coding (file edits allowed) | gemini-2.5-pro | yolo |
| Quick question | gemini-2.0-flash | plan |

Parameter notes:
- `-p` enables non-interactive (headless) mode — always use for automation
- `--approval-mode plan` = read-only mode (no file modifications); use for all review/analysis tasks
- `--approval-mode yolo` = auto-approve all actions; use for coding tasks only
- `-y` is shorthand for `--approval-mode yolo`
- `--model` defaults to the account's default model if omitted; always specify explicitly

## Prompt Format

```
TASK: {clear, specific action}
CONTEXT: {tech stack, environment, constraints}
FOCUS: {specific areas to examine}
OUTPUT: {desired format and detail level}
```

## Rules

- Always include `--model` and `--approval-mode`
- Never use `--approval-mode yolo` (or `-y`) for review/analysis tasks
- Never use `--approval-mode yolo` without explicit user confirmation for coding tasks

## Session Continuation

Resume a previous session:

```bash
# Most recent session
gemini --resume latest -p "{additional instructions}"

# By index (use --list-sessions to find index)
gemini --list-sessions
gemini --resume {index} -p "{additional instructions}"
```

## References

- [examples](references/examples.md) - Practical usage patterns
- [troubleshooting](references/troubleshooting.md) - Error handling and output formatting
- [code-review skill](../code-review/SKILL.md) - Tool-agnostic alternative when Gemini CLI is unavailable
