# Troubleshooting

## Output Formatting

When reporting Codex results to user, use this structure:

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

## Troubleshooting Guide

| Issue | Solution |
|-------|----------|
| Command not found | Guide user to install Codex CLI |
| Timeout on large codebase | Add `--timeout` flag or narrow scope |
| Permission denied | Check sandbox mode setting |
| Invalid model | Verify model name with `codex --help` |
| Want to hide reasoning | Add `2>/dev/null` at end |
| Need to edit files | Use the `codex-coding` skill instead |
| Need network access | Use `danger-full-access` with user confirmation |
| Session context lost | Use `resume --last` to continue |

## Implementation Notes

1. **Always use Bash tool** to execute codex commands
2. **Parse output** before presenting to user (summarize key points)
3. **Preserve important details** (error messages, specific recommendations)
4. **Maintain conversation context** when using resume
5. **Validate parameters** before execution using checklist
