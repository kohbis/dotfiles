# Troubleshooting

## Contents

- Output Formatting (per task type: coding / review / GitHub ops / no-op)
- Pre-Execution Checklist
- Error Handling (failure paths and `--allow-all-tools` guard)
- Troubleshooting Guide (issue → solution table)
- Implementation Notes

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

### For GitHub operations:

```
## GitHub Operation Result
- Action: [PR created / issue opened / label applied]
- URL: [link]

## Summary
[1-2 sentences describing what was done]
```

### For no-op results (nothing changed):

```
## Result: No Changes Needed
[1-2 sentences explaining why no changes were made]

## Notes
- [Any follow-up suggestions if applicable]
```

## Pre-Execution Checklist

Before running a task, verify:

0. **Install & auth** — confirm `copilot --version` succeeds and `gh auth status` shows authenticated
1. **Git status** — ask user if there are uncommitted changes that might conflict
2. **Change scope** — confirm which files/directories are in scope (for write tasks)
3. **Model selection** — choose appropriate model for task complexity
4. **Tool permissions** — use minimal necessary permissions
5. **`-p` flag** — include for programmatic mode unless interactive exploration is intended

## Error Handling

### IF execution fails:
1. Report error immediately to user
2. Look up the issue in the table below and suggest corrective action
3. If not in the table: report the raw error verbatim, suggest checking `copilot --help`, and offer to retry with a narrowed scope
4. Ask if user wants to retry with adjusted parameters

### IF user requests `--allow-all-tools`:
1. Explain implications (unrestricted tool access)
2. Suggest granular `--allow-tool` flags instead
3. IF user insists THEN proceed with confirmation
4. ELSE use specific `--allow-tool` flags

### IF unexpected files are modified:
1. Report all changed files to user
2. Ask user to review with `git diff`
3. Offer to revert specific files if needed

### IF partial success (some files wrong or incomplete):
1. Run `git diff` to identify all changed files
2. Report what succeeded and what didn't
3. Offer to continue from where it stopped with a narrowed prompt

## Troubleshooting Guide

| Issue | Solution |
|-------|----------|
| Command not found | Install: `gh extension install github/gh-copilot` or check PATH |
| Authentication error | Run `gh auth login` to authenticate |
| Model not available | Verify model name with `copilot --help`; use dot notation (e.g., `claude-sonnet-4.6`) |
| Permission denied on tool | Add appropriate `--allow-tool` flag |
| Timeout on large codebase | Narrow scope in prompt CONTEXT/CONSTRAINTS |
| Tool not recognized | Check tool name spelling; use `--allow-tool 'shell(*:*)'` for shell access |
| Output too verbose | Use `-p` mode and parse programmatic output |
| Want read-only analysis | Use `--allow-tool 'shell(read:*)'` instead of full shell access |
| Need to trust directory | Add `--trust-dir .` for current directory |
| Rate limit / quota exceeded | Wait and retry; reduce prompt complexity if hitting token limits |
| Prompt exceeds context window | Split task into smaller steps; narrow CONTEXT to specific files/dirs |
| Model temporarily unavailable | Wait and retry; fall back to an alternative model of similar capability |
| gh extension version too old | Run `gh extension upgrade gh-copilot` |
| Output truncated mid-response | Re-run with narrower scope; split into multiple focused tasks |

## Implementation Notes

1. **Always use Bash tool** to execute copilot commands
2. **Summarize results** before presenting to user
3. **Preserve error messages** if execution fails (share with user verbatim)
4. **Suggest `git diff`** after write operations so user can review changes
5. **Validate tool permissions** before execution — use minimal necessary access
