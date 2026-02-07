---
name: codex-cli
description: Execute code review, analysis, and technical research using Codex CLI. Trigger when user says "codex" or "/codex", or requests deep code review, codebase-wide analysis, bug investigation, refactoring proposals, infrastructure/K8s/Terraform review, CI/CD pipeline analysis, or technical research that goes beyond simple grep/read operations.
---

# Codex CLI

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
  {SUPPRESS_FLAG}
```

## Parameter Selection

| Task Type | Model | Reasoning | Sandbox | --full-auto |
|-----------|-------|-----------|---------|-------------|
| Complex bug investigation | gpt-5.3-codex | xhigh | read-only | NO |
| Large-scale refactoring | gpt-5.3-codex | high | workspace-write | YES |
| Standard code review | gpt-5.3-codex | high | read-only | NO |
| Infrastructure analysis | gpt-5.3-codex | high | read-only | NO |
| CI/CD optimization | gpt-5.2 | medium | read-only | NO |
| Quick code question | gpt-5.2 | medium | read-only | NO |

Parameter notes:
- `gpt-5.3-codex` for code tasks, `gpt-5.2` for general/infra tasks
- Default sandbox to `read-only`; use `workspace-write` only when editing files
- `danger-full-access` (network access) requires explicit user confirmation
- Add `--full-auto` only with `workspace-write`
- Append `2>/dev/null` only if user requests hidden output

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
