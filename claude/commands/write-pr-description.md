---
description: "Draft a pull request description from git diff and repository PR template."
---

# Write PR Description

Create a pull request description that follows the repository template.
Prioritize explaining value and intent over listing implementation details.

## Workflow

1. Detect current branch and target branch (default: `main`).
2. Collect change context:
   - `git diff --name-status {target}...HEAD`
   - `git diff --stat {target}...HEAD`
   - Key code changes and tests added/updated
3. Find PR template in this order:
   - `.github/pull_request_template.md`
   - `.github/PULL_REQUEST_TEMPLATE.md`
   - `.github/PULL_REQUEST_TEMPLATE/*.md` (pick the most relevant one)
4. Draft PR body by filling template sections with concrete, verifiable details.
   - Lead with problem, intent, and user/business impact
   - Explain why this approach was chosen and what trade-offs were accepted
   - Keep low-level implementation detail to the minimum needed for review
5. If no template exists, use this fallback structure:
   - Why this change
   - Expected impact
   - Key decisions and trade-offs
   - What changed (brief)
   - Testing
   - Risks
   - Checklist
6. Validate quality before finalizing:
   - No vague statements
   - Include test commands actually run
   - Include impact/risk and rollback note when relevant
   - Ensure each section answers "so what?" for reviewers

## Output Rules

- Output in Markdown only.
- Keep it concise and reviewer-focused.
- Do not invent results; mark unknown facts as `TODO`.
- Prefer outcome-oriented language over implementation-oriented language.
