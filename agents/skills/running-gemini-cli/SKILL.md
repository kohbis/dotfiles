---
name: running-gemini-cli
description: Runs coding, review, and analysis tasks using Gemini CLI in non-interactive (headless) mode. Trigger only when user explicitly says "running gemini cli" or "/running-gemini-cli".
disable-model-invocation: true
---

# Running Gemini CLI

## Command Template

```bash
gemini -p "{PROMPT}" \
  --model {MODEL} \
  --approval-mode {MODE}
```

## Parameter Selection

| Task Type | Model | approval-mode |
|-----------|-------|--------------|
| Complex code review / debugging | pro | plan |
| Standard review / analysis | flash | plan |
| Coding (file edits allowed) | pro | yolo |
| Quick question | flash-lite | plan |

Parameter notes:
- `-p` enables non-interactive (headless) mode — always use for automation
- `--approval-mode plan` = read-only mode (no file modifications); use for all review/analysis tasks
- `--approval-mode yolo` = auto-approve all actions; use for coding tasks only
- `-y` is shorthand for `--approval-mode yolo`
- `--model` defaults to the account's default model if omitted; always specify explicitly
- Prefer Gemini CLI aliases over pinned preview model names: `pro` for deeper reasoning, `flash` for balanced speed, `flash-lite` for simple tasks
- `auto` is the recommended interactive default when you want Gemini CLI to route between Gemini 3 models automatically

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
- [reviewing-code skill](../reviewing-code/SKILL.md) - Tool-agnostic alternative when Gemini CLI is unavailable
