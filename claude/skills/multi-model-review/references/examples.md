# Multi-Model Review Examples

## Review Uncommitted Changes (All Reviewers)

```bash
# 1. Get the diff
DIFF=$(git diff HEAD)

# 2. Build the prompt
PROMPT="
TASK: Review the following code changes for quality, correctness, and potential issues.
CONTEXT: TypeScript Node.js REST API
FOCUS: General review — correctness, error handling, security, performance
OUTPUT: Issues by severity (critical/major/minor) with file:line references.

CODE CHANGES:
$DIFF
"

# 3. Run each reviewer
codex exec --model gpt-5.3-codex --config model_reasoning_effort="high" \
  --sandbox read-only --skip-git-repo-check -C . "$PROMPT"

gemini -p "$PROMPT" --model gemini-2.5-pro --approval-mode plan

copilot -p "$PROMPT" --model gpt-5.3-codex
```

## Review a PR

```bash
DIFF=$(gh pr diff 42)

PROMPT="
TASK: Review the following pull request changes.
CONTEXT: Go microservice, PostgreSQL backend
FOCUS: Correctness, data safety, migration risks
OUTPUT: Issues by severity with file:line references.

CODE CHANGES:
$DIFF
"
# Then run reviewers as above
```

## Targeted Security Review (Codex + Gemini only)

```bash
PROMPT="
TASK: Review src/auth/ for security vulnerabilities.
CONTEXT: Express.js, JWT authentication, user-facing API
FOCUS: Input validation, token handling, privilege escalation risks
OUTPUT: Security findings by severity with remediation suggestions.
"

codex exec --model gpt-5.3-codex --config model_reasoning_effort="xhigh" \
  --sandbox read-only --skip-git-repo-check -C . "$PROMPT"

gemini -p "$PROMPT" --model gemini-2.5-pro --approval-mode plan
```

## Example Synthesized Output

```markdown
## Multi-Model Review Summary

**Reviewers:** codex, gemini, copilot
**Target:** git diff HEAD (4 files, +120/-30 lines)

### Common Findings (2+ reviewers)
- [critical] Missing null check before accessing `user.profile` in `src/users/service.ts:42` — can throw at runtime if user has no profile
- [major] `fetchOrders` does not handle database timeout errors in `src/orders/repository.ts:88`

### Codex Unique Findings
- [minor] Loop in `src/utils/transform.ts:15` could be replaced with `Array.flatMap` for clarity

### Gemini Unique Findings
- [major] JWT secret falls back to a hardcoded string in `src/auth/config.ts:7` if env var is unset — potential security issue in misconfigured deployments

### Copilot Unique Findings
- [minor] Missing test coverage for the error branch in `src/orders/service.ts:55`

### Overall Assessment
The changes are mostly sound but have two critical/major issues that should be addressed before merging: the null dereference on user.profile and the missing JWT secret validation. Gemini uniquely identified a security risk worth verifying independently.
```
