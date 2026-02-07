---
name: clean-deadcode
description: Safely identify and remove dead code with test verification and a structured report of findings and deletions.
---

# Clean Deadcode

Safely identify and remove dead code with test verification.

## Workflow

1. Run dead code analysis tools appropriate for the project's language:
   - Find unused exports, functions, and files
   - Find unused dependencies
   - Identify unreachable code paths

2. Generate a report at `.reports/dead-code-analysis.md` with findings.

3. Categorize findings by severity:
   - SAFE: Test files, unused utilities
   - CAUTION: API routes, components
   - DANGER: Config files, main entry points

4. Propose SAFE deletions only.

5. For each deletion:
   - Run the full test suite
   - Verify tests pass
   - Apply the change
   - Re-run tests
   - Roll back the change if tests fail

6. Summarize cleaned items and any follow-up recommendations.

## Hard Rule

Never delete code without running tests first.
