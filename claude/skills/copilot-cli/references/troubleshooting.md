# Troubleshooting

## Output Formatting

When reporting Copilot CLI results to user, use this structure:

### For coding tasks:

```
## Changed Files
- [file path] — [brief description of change]

## Implementation Summary
[2-3 sentences describing what was implemented and how]

## Notes
- [Any caveats, assumptions made, or follow-up items]
- [Test commands to verify the change]
```

### For review/analysis tasks:

```
## Key Findings
- [Most critical finding]
- [Second priority finding]

## Recommended Actions
1. [Immediate action with highest impact]
2. [Secondary action]

## Next Steps
- [Specific next action to take]
```

## Pre-Execution Checklist

Before running a task, verify:

1. **Git status** — ask user if there are uncommitted changes that might conflict
2. **Change scope** — confirm which files/directories are in scope (for write tasks)
3. **Model selection** — choose appropriate model for task complexity
4. **Tool permissions** — use minimal necessary permissions
5. **`-p` flag** — include for programmatic mode unless interactive exploration is intended

## Error Handling

### IF execution fails:
1. Report error immediately to user
2. Look up the issue in the table below and suggest corrective action
3. Ask if user wants to retry with adjusted parameters

### IF user requests `--allow-all-tools`:
1. Explain implications (unrestricted tool access)
2. Suggest granular `--allow-tool` flags instead
3. IF user insists THEN proceed with confirmation
4. ELSE use specific `--allow-tool` flags

### IF unexpected files are modified:
1. Report all changed files to user
2. Ask user to review with `git diff`
3. Offer to revert specific files if needed

## Troubleshooting Guide

| Issue | Solution |
|-------|----------|
| Command not found | Install: `gh extension install github/gh-copilot` or check PATH |
| Authentication error | Run `gh auth login` to authenticate |
| Model not available | Verify model name with `copilot --help` |
| Permission denied on tool | Add appropriate `--allow-tool` flag |
| Timeout on large codebase | Narrow scope in prompt CONTEXT/CONSTRAINTS |
| Tool not recognized | Check tool name spelling; use `--allow-tool 'shell(*:*)'` for shell access |
| Output too verbose | Use `-p` mode and parse programmatic output |
| Want read-only analysis | Omit `--allow-tool write` flag |
| Need to trust directory | Add `--trust-dir .` for current directory |

## Implementation Notes

1. **Always use Bash tool** to execute copilot commands
2. **Summarize results** before presenting to user
3. **Preserve error messages** if execution fails (share with user verbatim)
4. **Suggest `git diff`** after write operations so user can review changes
5. **Validate tool permissions** before execution — use minimal necessary access
