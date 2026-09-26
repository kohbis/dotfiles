# Troubleshooting

## Output Formatting

When reporting Codex results to the user, use the structure for the mode.

Review:

```
## Key Findings
- [Most critical finding]
- [Second priority finding]
- [Third priority finding]

## Recommended Actions
1. [Immediate action with highest impact]
2. [Secondary action]
3. [Long-term improvement]

## Next Steps
- [Specific next action to take]
- [Follow-up investigation if needed]
```

Coding:

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

### IF unexpected files are modified (coding mode):
1. Report all changed files to user
2. Ask user to review with `git diff`
3. Offer to revert specific files if needed

## Troubleshooting Guide

| Issue | Solution |
|-------|----------|
| Command not found | Guide user to install Codex CLI |
| Timeout on large codebase | Narrow scope with `-C` or in the prompt |
| Permission denied | Check sandbox mode setting |
| Invalid model | Verify the model name against the Models table and `codex exec --help` |
| Final answer missing from output | The template already appends `2>/dev/null`; if the answer is still empty, re-run without it to surface the underlying error |
| Want to inspect progress/exec trace | Drop the `2>/dev/null` suffix to surface stderr |
| Need network access | Use `danger-full-access` with user confirmation |
| Session context lost | Use `resume --last` to continue |
| Too many files changed | Narrow scope in the CONSTRAINTS section of the prompt |

## Implementation Notes

1. **Always use Bash tool** to execute codex commands
2. **Summarize** results or changed files before presenting to user
3. **Preserve error messages** if execution fails (share with user verbatim)
4. **Maintain conversation context** when using resume
5. **Suggest `git diff`** after a coding run so the user can review changes
