---
name: creating-agents-md
description: >
  Creates or improves AGENTS.md by analyzing project structure, conventions, and tooling.
  Also creates CLAUDE.md with @AGENTS.md reference for unified context management.
  Trigger only when user explicitly says "creating agents md" or "/creating-agents-md".
disable-model-invocation: true
---

# Creating AGENTS.md

Create or improve AGENTS.md for a project, and optionally create CLAUDE.md that references it.

## Workflow

### Step 1: Load Best Practices

Fetch the latest guidelines from both sources:

- WebFetch `https://code.claude.com/docs/en/best-practices.md` for CLAUDE.md best practices
- WebFetch `https://developers.openai.com/codex/guides/agents-md/` for AGENTS.md best practices

If either source is unavailable, continue using the available source plus local repository evidence. Note which source was unavailable.

### Step 2: Detect Current State

Check what already exists:

- Does `AGENTS.md` exist in the project root? If yes, read its content.
- Does `CLAUDE.md` exist in the project root? If yes, read its content.
- Is this a monorepo or workspace? Check for `pnpm-workspace.yaml`, `nx.json`, `turbo.json`, `lerna.json`, or multiple `package.json` / `Cargo.toml` under subdirectories.

### Step 3: Handle CLAUDE.md

Normalize CLAUDE.md content first: strip blank lines and comments, then evaluate.

- **CLAUDE.md does not exist** → Note: create it in Step 6.
- **CLAUDE.md is empty or effectively contains only `@AGENTS.md`** → Skip; no action needed.
- **CLAUDE.md has substantive content** → Ask the user:

  > "CLAUDE.md has existing content. Would you like to merge it into AGENTS.md and replace CLAUDE.md with just `@AGENTS.md` for unified management? (yes/no)"

  - Yes → Incorporate the content into AGENTS.md (Step 5), then replace CLAUDE.md with `@AGENTS.md` only (Step 6).
  - No → Leave CLAUDE.md untouched.
  - **No response / unclear** → Do not modify CLAUDE.md; proceed with AGENTS.md only.

### Step 4: Analyze the Project

Gather information to populate AGENTS.md. Exclude `node_modules`, `.git`, `dist`, `build`, `vendor`, `.cache`, and other generated directories from scanning.

Prioritize authoritative config files first, then source structure:

- **Config files**: `package.json`, `Cargo.toml`, `pyproject.toml`, `go.mod`, `Makefile`, `.github/`, etc.
- **Directory structure**: Top-level layout, source directories, test directories.
- **CI/CD**: Workflows in `.github/workflows/`, `Jenkinsfile`, etc.
- **Lint/format tools**: ESLint, Prettier, Ruff, rustfmt, etc. and their configs.
- **Language and runtime**: Detected from config files.
- **Build tool**: npm, cargo, make, gradle, etc.
- **Test framework**: Jest, pytest, cargo test, go test, etc.
- **Key scripts**: Build, test, lint, format commands.
- **Monorepo structure**: If detected, note workspace root and list packages with their paths.

### Step 5: Generate or Update AGENTS.md

**New file**: Create AGENTS.md from analysis results using the sections below.

**Existing file**:
- Preserve hand-written notes and context that cannot be inferred from code.
- Replace any statement that conflicts with current config files (e.g., stale commands, renamed paths, removed tools).
- Add missing sections based on the current analysis.
- Do not preserve factually incorrect content.

For information that cannot be confirmed from the repository, ask the user rather than guessing.

Include only sections that have relevant content for the project.

### Step 6: Create CLAUDE.md (if needed)

If CLAUDE.md did not exist at Step 2, create it with only:

```
@AGENTS.md
```

### Step 7: Validate

Before finishing, verify:

- Sections appear in the order defined below.
- All commands are exact and runnable (not placeholders like `<command>`).
- File size is under 32 KiB.
- If CLAUDE.md was created or modified, it contains a valid `@AGENTS.md` reference.

---

## AGENTS.md Sections

Include only sections that apply. Use the order below.

### Project Overview

One paragraph: what the project does, primary language/runtime, and key technical decisions that affect day-to-day development.

### Architecture

High-level structure: major directories, how components relate, data flow if non-obvious. For monorepos, list packages with paths. Skip if a flat single-package project.

### Key Commands

Commands an agent needs to build, run, test, lint, and format the project. Use exact commands from config files. For monorepos, prefix with the package path.

```
Build:  <command>
Test:   <command>
Lint:   <command>
Format: <command>
```

### Coding Conventions

Rules not enforced by linters: naming patterns, file organization, preferred idioms, patterns to avoid. Include only conventions that would cause bugs or rejections if not followed — not style preferences already captured by linter config.

### Testing

Test file location convention, how to run a single test, how to run tests for a specific module, and any test environment setup requirements.

### Environment Setup

Prerequisites and bootstrap steps not covered by standard install/build commands: required environment variables, local service dependencies, secrets management, or non-obvious one-time setup.

### Development Workflow

Branch naming, commit message format, PR process if non-standard. Skip if standard GitHub flow.

### Scope & Boundaries

Paths or files agents must not modify (generated files, vendored code, locked configs), and the intended working boundary of the project.

### Notes for AI Agents

Constraints and pitfalls specific to AI-assisted development:

- Dependencies or APIs with non-obvious behavior
- Known gotchas that don't appear in the code

---

## Hard Rules

Apply these when deciding what to include:

1. **Size limit**: Keep AGENTS.md under 32 KiB.
2. **Necessity test**: For each piece of information, ask "Would an agent make a mistake without this?" If no, omit it.
3. **No redundant detail**: Avoid duplicating implementation details already obvious in the code; include only high-signal summaries that prevent real mistakes.
4. **No speculation**: If information cannot be confirmed from the repository or the user, do not include it. Ask the user rather than guessing.
5. **No secrets**: Never include API keys, tokens, passwords, or internal URLs in AGENTS.md.
6. **Be concrete**: Prefer exact commands and paths over vague descriptions.
