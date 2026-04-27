# Gemini CLI Examples

## Code Review

```bash
# Review staged changes
git diff --cached | gemini -p "$(cat <<'EOF'
TASK: Review the following code changes for quality, correctness, and potential issues.
CONTEXT: TypeScript Node.js project
FOCUS: Error handling, edge cases, performance
OUTPUT: List issues by severity (critical/major/minor) with file:line references.

CODE CHANGES:
$(cat)
EOF
)" --model pro --approval-mode plan
```

Simpler form when piping is not needed:

```bash
gemini -p "
TASK: Review src/auth/token.ts for security issues.
CONTEXT: Express.js REST API, JWT authentication
FOCUS: Token validation, expiry handling, injection risks
OUTPUT: Issues by severity with line references
" --model pro --approval-mode plan
```

## Architecture Analysis

```bash
gemini -p "
TASK: Analyze the overall architecture of this project and identify potential scalability concerns.
CONTEXT: Node.js microservice, PostgreSQL, Redis cache
FOCUS: Database connection patterns, caching strategy, bottlenecks
OUTPUT: Bullet-point findings grouped by concern area
" --model pro --approval-mode plan
```

## Quick Question

```bash
gemini -p "
TASK: Explain what this regex does: /^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/
OUTPUT: Plain English explanation with examples
" --model flash-lite --approval-mode plan
```

## Coding Task (with file edits)

```bash
# Requires user confirmation before running
gemini -p "
TASK: Refactor the fetchUser function in src/users/service.ts to use async/await instead of callbacks.
CONTEXT: Node.js 20, TypeScript 5
SPEC: Preserve existing error handling behavior; do not change the function signature
" --model pro --approval-mode yolo
```
