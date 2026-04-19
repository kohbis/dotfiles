# Troubleshooting

## Output Formatting

When reporting Codex coding results to user, use this structure:

```
## Changed Files
- [file path] — [brief description of change]
- [file path] — [brief description of change]

## Implementation Summary
[2-3 sentences describing what was implemented and how]

## Notes
- [Any caveats, assumptions made, or follow-up items]
- [Test commands to verify the change]
```

## Pre-Execution Checklist

Before running a coding task, verify:

1. **Git status** — ask user if there are uncommitted changes that might conflict
2. **Change scope** — confirm which files/directories are in scope
3. **Sandbox** — always `workspace-write` for this skill
4. **`--full-auto`** — always included for this skill

## Error Handling

### IF execution fails:
1. Report error immediately to user
2. Look up the issue in the table below and suggest corrective action
3. Ask if user wants to retry with adjusted parameters

### IF user requests danger-full-access:
1. Explain implications (network access, system commands)
2. Ask explicit confirmation
3. IF confirmed THEN proceed
4. ELSE suggest safer alternative

### IF unexpected files are modified:
1. Report all changed files to user
2. Ask user to review with `git diff`
3. Offer to revert specific files if needed

## Troubleshooting Guide

| Issue | Solution |
|-------|----------|
| Command not found | Guide user to install Codex CLI |
| Timeout on large codebase | Add `--timeout` flag or narrow scope with `-C` |
| Permission denied | Verify `workspace-write` sandbox is set |
| Invalid model | Verify model name with `codex --help` |
| Want to hide reasoning | Add `2>/dev/null` at end |
| Need network access | Use `danger-full-access` with user confirmation |
| Session context lost | Use `resume --last` to continue |
| Too many files changed | Narrow scope in CONSTRAINTS section of prompt |

## Implementation Notes

1. **Always use Bash tool** to execute codex commands
2. **Summarize changed files** before presenting to user
3. **Preserve error messages** if execution fails (share with user verbatim)
4. **Maintain conversation context** when using resume
5. **Suggest `git diff`** after execution so user can review changes
