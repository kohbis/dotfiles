---
name: clean-deadcode
description: Safely identify and remove dead code with test verification. Trigger only when user explicitly says "clean deadcode", "/clean-deadcode", or directly requests removing/deleting unused exports, functions, files, or dependencies — not on casual mentions of "dead code" in discussion.
disable-model-invocation: true
---

# Clean Deadcode

## Workflow

1. Determine the dead code analysis tool to use:
   - Check project config files (AGENTS.md, CLAUDE.md, README, Makefile, etc.) for tooling conventions
   - If not found, ask the user which tool to use

2. Run the tool and collect results.

3. Categorize findings by severity:
   - **SAFE**: Unused utilities, helpers, test files
   - **CAUTION**: API routes, components (may have external consumers)
   - **DANGER**: Config files, main entry points (never delete)

4. Generate a report at `.reports/dead-code-analysis.md` with all findings and their categories.

5. Delete SAFE items only. For each deletion:
   - Apply the change
   - Run the test suite
   - Roll back if tests fail

6. Summarize cleaned items and any CAUTION items for user review.

## Hard Rule

Never delete code without running tests after each change.
