# Practical Examples

## Example 1: New Feature Implementation (Programmatic Mode)

**Task Type**: New feature / coding
**Selected Parameters**: `claude-sonnet-4-6` + shell/write tools

```bash
copilot -p "TASK: Implement POST /api/v1/users endpoint for user registration
CONTEXT: Go HTTP server using chi router, PostgreSQL via sqlx, existing handlers in internal/handler/
SPEC: Accept JSON body {email, password, name}, validate input, hash password with bcrypt, insert to users table, return 201 with user ID; return 400 on validation error, 409 on duplicate email
CONSTRAINTS: Follow existing handler patterns in internal/handler/user.go, use existing db.User model, do not modify migration files" \
  --model claude-sonnet-4-6 \
  --allow-tool 'shell(*:*)' --allow-tool write
```

## Example 2: Code Review (Read-Only)

**Task Type**: Code review / analysis
**Selected Parameters**: `gpt-5.3-codex` + no write tools

```bash
copilot -p "TASK: Review the authentication middleware for security issues
CONTEXT: Node.js/Express app with JWT-based auth, middleware in src/middleware/auth.ts
FOCUS: Token validation, expiry handling, error responses, header parsing
OUTPUT: List issues by severity with specific remediation steps" \
  --model gpt-5.3-codex
```

## Example 3: Bug Fix (Complex Debugging)

**Task Type**: Complex architecture / debugging
**Selected Parameters**: `claude-opus-4-6` + shell/write tools

```bash
copilot -p "TASK: Fix race condition causing duplicate records in order processing
CONTEXT: Go service, PostgreSQL, order processing in pkg/order/processor.go
SPEC: Reproduce: send 2 concurrent POST /orders with same idempotency key results in 2 records. Expected: exactly 1 record. Fix using DB-level unique constraint + upsert or advisory lock.
CONSTRAINTS: Do not change the HTTP handler signature; fix must be in processor.go and/or migration; add a test reproducing the race condition" \
  --model claude-opus-4-6 \
  --allow-tool 'shell(*:*)' --allow-tool write
```

## Example 4: GitHub Operations (PR Creation)

**Task Type**: New feature / coding
**Selected Parameters**: `claude-sonnet-4-6` + shell tools

```bash
copilot -p "TASK: Create a pull request for the current branch
CONTEXT: Feature branch 'feat/user-auth' with 3 commits implementing user authentication
SPEC: Generate a descriptive PR title and body summarizing all changes, add appropriate labels
CONSTRAINTS: Target the main branch, use conventional commit style for the title" \
  --model claude-sonnet-4-6 \
  --allow-tool 'shell(*:*)'
```

## Example 5: Plan-First Implementation

**Task Type**: Complex architecture
**Selected Parameters**: `claude-opus-4-6` + shell/write tools

```bash
copilot -p "TASK: Refactor the monolithic user service into separate auth and profile services
CONTEXT: TypeScript/Node.js monorepo, current user service in packages/user-service/
SPEC: Split into packages/auth-service/ and packages/profile-service/, maintain API compatibility, share types via packages/shared-types/
CONSTRAINTS: Keep existing API routes unchanged, add integration tests for service boundaries" \
  --model claude-opus-4-6 \
  --allow-tool 'shell(*:*)' --allow-tool write
```

## Example 6: Quick Question (Minimal Tools)

**Task Type**: Quick question
**Selected Parameters**: `claude-sonnet-4-6` + no tools

```bash
copilot -p "Explain the difference between useEffect and useLayoutEffect in React, with examples of when to use each" \
  --model claude-sonnet-4-6
```
