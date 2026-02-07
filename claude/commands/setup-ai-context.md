---
description: "Setup AI Context Management System for sharing project guidelines across Claude Code, GitHub Copilot, and Cursor."
---

# AI Context Management System Setup

This command sets up a system to manage and synchronize project context (rules and guidelines) across multiple AI coding assistance tools (Claude Code, GitHub Copilot, Cursor).

## System Overview

### Design Philosophy

- **Centralized Common Rules**: Manage all-tool-common context in `.ai-context/base.md`
- **Tool-Specific Extensions**: Manage tool-specific additional rules in `.ai-context/overrides/*.md`
- **Script-Based Synchronization**: Automatic generation via Node.js (ES Modules)
- **Manual Execution**: Sync when needed with `npm run ai-context:sync` command

### Generated File Structure

```
Project Root/
  .ai-context/
    base.md                        # Common context
    config.json                    # Sync configuration
    overrides/
      claude.md                    # Claude Code specific
      copilot.md                   # GitHub Copilot specific
      cursor.md                    # Cursor specific
    backups/                       # Auto-backups (.gitignore recommended)
  scripts/
    sync-ai-context.js             # Sync script
  CLAUDE.md                        # Auto-generated
  AGENTS.md                        # Auto-generated
  .github/
    copilot-instructions.md        # Auto-generated
  .cursor/
    rules/
      instructions.mdc             # Auto-generated
```

## Setup Instructions

All template files are located at `~/.claude/templates/ai-context/`.

### 1. Create Directory Structure

```bash
mkdir -p .ai-context/overrides scripts
```

### 2. Copy Template Files

```bash
# Configuration
cp ~/.claude/templates/ai-context/config.json .ai-context/

# Base context
cp ~/.claude/templates/ai-context/base.md .ai-context/

# Override files
cp ~/.claude/templates/ai-context/override-claude.md .ai-context/overrides/claude.md
cp ~/.claude/templates/ai-context/override-copilot.md .ai-context/overrides/copilot.md
cp ~/.claude/templates/ai-context/override-cursor.md .ai-context/overrides/cursor.md

# Sync script
cp ~/.claude/templates/ai-context/sync-ai-context.js scripts/
chmod +x scripts/sync-ai-context.js
```

### 3. Customize Files

- Edit `.ai-context/base.md` with project-common rules (overview, conventions, workflows)
- Edit `.ai-context/overrides/*.md` with tool-specific rules
- Edit `.ai-context/config.json` if output paths or headers need adjustment

### 4. Configure Sync Command

#### Option A: Node.js Projects (with package.json)

Add to `package.json`:

```json
{
  "scripts": {
    "ai-context:sync": "node scripts/sync-ai-context.js"
  }
}
```

#### Option B: Non-Node.js Projects

Run directly:

```bash
node scripts/sync-ai-context.js
```

### 5. Update .gitignore

```
.ai-context/backups/
```

### 6. Run Initial Sync

```bash
npm run ai-context:sync  # or: node scripts/sync-ai-context.js
```

Verify generated files: `CLAUDE.md`, `AGENTS.md`, `.github/copilot-instructions.md`, `.cursor/rules/instructions.mdc`

## Operational Flow

### Update Common Rules

1. Edit `.ai-context/base.md` -> Run sync -> Review -> Commit

### Update Tool-Specific Rules

1. Edit `.ai-context/overrides/[tool].md` -> Run sync -> Review -> Commit

### Add New Tool

1. Create `.ai-context/overrides/[new-tool].md`
2. Add config to `tools` section in `.ai-context/config.json`
3. Run sync -> Review -> Commit

## Troubleshooting

| Error | Solution |
|-------|----------|
| config.json not found | Verify `.ai-context/config.json` exists and run from project root |
| base.md not found | `cp ~/.claude/templates/ai-context/base.md .ai-context/` |
| overrides/*.md not found | Warning only; sync continues with base.md only |
