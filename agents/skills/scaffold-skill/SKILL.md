---
name: scaffold-skill
description: Interactively scaffold a new Claude Code skill (SKILL.md). Lightweight alternative to /skill-creator — focused on quick creation without evals or benchmarking. Trigger when user says "create command", "new command", "make a command", "add a slash command", "create skill", "new skill", "scaffold skill", or requests creating a new custom skill for Claude Code.
---

# Scaffold Skill

Interactively scaffold a new Claude Code skill.

This is a lightweight scaffolding tool. For test/eval-driven skill development with benchmarking, use `/skill-creator` instead.

## Skill Format

A skill is a directory with `SKILL.md` as the entrypoint:

```
<skill-name>/
├── SKILL.md           # Main instructions (required)
├── template.md        # Template for Claude to fill in (optional)
├── examples/          # Example outputs (optional)
└── scripts/           # Scripts Claude can execute (optional)
```

`SKILL.md` uses YAML frontmatter + Markdown content:

```markdown
---
name: my-skill
description: "What this skill does and when to use it."
---

# Skill Title

Prompt body that Claude follows when the skill is invoked.
Use $ARGUMENTS to accept user input (e.g., `/my-skill some args`).
```

## Frontmatter Options

| Field | Description |
|---|---|
| `name` | Slash command name. Defaults to directory name. Kebab-case, max 64 chars. |
| `description` | When to use this skill. Front-load key use case, max 250 chars recommended. |
| `disable-model-invocation` | `true` = manual `/name` only. Use for skills with side effects (deploy, push, etc). |
| `user-invocable` | `false` = Claude-only. Use for background knowledge, not actionable as a command. |
| `context` | `fork` = run in isolated subagent. Use for self-contained tasks. |
| `agent` | Subagent type when `context: fork` (`Explore`, `Plan`, `general-purpose`, or custom). |
| `allowed-tools` | Tools allowed without approval. Space-separated or YAML list. |
| `model` | Model override. |
| `effort` | Effort level: `low`, `medium`, `high`, `max`. |
| `argument-hint` | Autocomplete hint (e.g., `[issue-number]`). |
| `paths` | Glob patterns limiting when this skill auto-activates. |

## String Substitutions

| Variable | Description |
|---|---|
| `$ARGUMENTS` | All arguments passed when invoking. |
| `$ARGUMENTS[N]` / `$N` | Specific argument by 0-based index. |
| `${CLAUDE_SKILL_DIR}` | Directory containing this SKILL.md. |
| `${CLAUDE_SESSION_ID}` | Current session ID. |
| `` !`command` `` | Shell command output injected at load time. |

## Workflow

1. **Ask the user** what the skill should do.
   - Purpose and use case
   - Example invocation (e.g., `/my-skill` or `/my-skill some-arg`)
   - Whether it needs `$ARGUMENTS`
   - Who should invoke it: user only, Claude only, or both

2. **Choose a skill name:**
   - Use kebab-case (e.g., `review-code`, `generate-docs`)
   - Keep it short and descriptive
   - Verify no conflict with existing skills in `~/.claude/skills/`

3. **Determine the scope:**
   - Personal (`~/.claude/skills/`) → all projects
   - Project (`.claude/skills/`) → this project only
   - Default to personal unless the user specifies otherwise

4. **Decide frontmatter:**
   - If the skill has side effects (git push, deploy, file creation) → `disable-model-invocation: true`
   - If the skill is background knowledge → `user-invocable: false`
   - If the skill is a self-contained task → consider `context: fork`
   - If the skill needs restricted tools → set `allowed-tools`

5. **Draft the skill content:**
   - Write a clear, specific `description` (front-load the key use case)
   - Write the prompt body following these principles:
     - Use imperative form ("Analyze...", "Generate...", "Review...")
     - Be specific about the workflow and expected output
     - Include constraints and hard rules where needed
     - Keep SKILL.md under 500 lines; move reference material to supporting files
   - If supporting files are needed (templates, scripts, examples), plan the directory structure

6. **Review with the user:**
   - Show the full SKILL.md content
   - Show the directory structure if supporting files are included
   - Confirm the skill name, location (personal vs project), and frontmatter settings
   - Apply any requested changes

7. **Write the files** to the chosen location.

## Quality Checklist

- Description is concise, specific, and front-loads the key use case
- `disable-model-invocation: true` is set for skills with side effects
- Prompt body is clear enough for Claude to follow without ambiguity
- `$ARGUMENTS` is used if the skill accepts input
- No overlap with existing skills
- SKILL.md stays under 500 lines
- Supporting files are referenced from SKILL.md

## Reference

Check `~/.claude/skills/` for existing skills to avoid duplication and maintain consistent style.
