---
name: create-command
description: Interactively create Claude Code custom slash commands (~/.claude/commands/*.md). Trigger when user says "create command", "new command", "make a command", "add a slash command", or requests creating a new custom command for Claude Code.
---

# Create Command

Interactively create a new Claude Code custom slash command.

## Command Format

Commands are single Markdown files in `~/.claude/commands/`:

```markdown
---
description: "Short description shown in command list."
---

# Command Title

Prompt body that Claude executes when the command is invoked.
Use $ARGUMENTS to accept user input (e.g., `/command-name some args`).
```

## Workflow

1. Ask the user what the command should do.
   - Purpose and use case
   - Example invocation (e.g., `/my-command` or `/my-command some-arg`)
   - Whether it needs `$ARGUMENTS`

2. Choose a command name:
   - Use kebab-case (e.g., `review-code`, `generate-docs`)
   - Keep it short and descriptive
   - Verify no conflict with existing commands in `~/.claude/commands/`

3. Draft the command content:
   - Write a clear `description` in frontmatter
   - Write the prompt body following these principles:
     - Use imperative form ("Analyze...", "Generate...", "Review...")
     - Be specific about the workflow and expected output
     - Include constraints and hard rules where needed
     - Reference existing command patterns for style consistency

4. Review with the user:
   - Show the full command file content
   - Confirm the file name and location
   - Apply any requested changes

5. Write the file to `~/.claude/commands/<command-name>.md`.

## Quality Checklist

- Description is concise and explains when to use the command
- Prompt body is clear enough for Claude to follow without ambiguity
- `$ARGUMENTS` is used if the command accepts input
- No overlap with existing commands
- File name matches the command's purpose

## Reference: Existing Commands

Check `~/.claude/commands/` for existing commands to avoid duplication and maintain consistent style.
