# Multi-Model Review Examples

## Review Uncommitted Changes (Default: codex + copilot)

```bash
DIFF=$(git diff HEAD)

PROMPT="
TASK: Review the following code changes for quality, correctness, and potential issues.
CONTEXT: TypeScript Node.js REST API
FOCUS: General review — correctness, error handling, security, performance
OUTPUT: Issues by severity (critical/major/minor) with file:line references.

CODE CHANGES:
$DIFF
"

# Run in parallel (spawn both subagents in the same turn)
codex exec --model gpt-5.3-codex --config model_reasoning_effort="high" \
  --sandbox read-only --skip-git-repo-check -C . "$PROMPT"

copilot -p "$PROMPT" --model claude-opus-4.6 --allow-tool 'shell(read:*)'
```

## Review a PR (All Reviewers)

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

# Run all four in parallel
codex exec --model gpt-5.3-codex --config model_reasoning_effort="high" \
  --sandbox read-only --skip-git-repo-check -C . "$PROMPT"

copilot -p "$PROMPT" --model claude-opus-4.6 --allow-tool 'shell(read:*)'

gemini -p "$PROMPT" --model gemini-2.5-pro --approval-mode plan

claude -p "$PROMPT" --model claude-opus-4-6 --allowedTools "Bash(git:*),Read,Glob,Grep"
```

## Targeted Security Review (codex + gemini)

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

**Reviewers:** codex, copilot
**Target:** git diff HEAD (4 files, +120/-30 lines)

### Common Findings (2+ reviewers)
- [critical] Missing null check before accessing `user.profile` in `src/users/service.ts:42` — can throw at runtime if user has no profile
- [major] `fetchOrders` does not handle database timeout errors in `src/orders/repository.ts:88`

### Codex Unique Findings
- [minor] Loop in `src/utils/transform.ts:15` could be replaced with `Array.flatMap` for clarity

### Copilot Unique Findings
- [major] JWT secret falls back to a hardcoded string in `src/auth/config.ts:7` if env var is unset — potential security issue in misconfigured deployments

### Overall Assessment
The changes are mostly sound but have two critical/major issues that should be addressed before merging: the null dereference on user.profile and the missing JWT secret validation.
```
