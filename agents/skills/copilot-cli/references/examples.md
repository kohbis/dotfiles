# Practical Examples

## Example 1: New Feature Implementation (Programmatic Mode)

**Task Type**: New feature / coding
**Selected Parameters**: `claude-sonnet-4.6` + shell/write tools

```bash
copilot -p "TASK: Implement POST /api/v1/users endpoint for user registration
CONTEXT: Go HTTP server using chi router, PostgreSQL via sqlx, existing handlers in internal/handler/
SPEC: Accept JSON body {email, password, name}, validate input, hash password with bcrypt, insert to users table, return 201 with user ID; return 400 on validation error, 409 on duplicate email
CONSTRAINTS: Follow existing handler patterns in internal/handler/user.go, use existing db.User model
SCOPE: Do not modify migration files" \
  --model claude-sonnet-4.6 \
  --allow-tool 'shell(*:*)' --allow-tool 'write(*:*)'
```

## Example 2: Code Review (Read-Only Shell)

**Task Type**: Code review / analysis
**Selected Parameters**: `gpt-5.4` + read-only shell (no write)

```bash
copilot -p "TASK: Review the authentication middleware for security issues
CONTEXT: Node.js/Express app with JWT-based auth, middleware in src/middleware/auth.ts
FOCUS: Token validation, expiry handling, error responses, header parsing
OUTPUT: List issues by severity with specific remediation steps" \
  --model gpt-5.4 \
  --allow-tool 'shell(read:*)'
```

## Example 3: Bug Fix (Complex Debugging)

**Task Type**: Complex architecture / debugging
**Selected Parameters**: `claude-opus-4.7` + shell/write tools

```bash
copilot -p "TASK: Fix race condition causing duplicate records in order processing
CONTEXT: Go service, PostgreSQL, order processing in pkg/order/processor.go
SPEC: Reproduce: send 2 concurrent POST /orders with same idempotency key results in 2 records. Expected: exactly 1 record. Fix using DB-level unique constraint + upsert or advisory lock.
CONSTRAINTS: Do not change the HTTP handler signature
SCOPE: Fix must be in processor.go and/or migration only; add a test reproducing the race condition" \
  --model claude-opus-4.7 \
  --allow-tool 'shell(*:*)' --allow-tool 'write(*:*)'
```

## Example 4: GitHub Operations (PR Creation)

**Task Type**: GitHub operations
**Selected Parameters**: `claude-sonnet-4.6` + shell tools (no write)

```bash
copilot -p "TASK: Create a pull request for the current branch
CONTEXT: Feature branch 'feat/user-auth' with 3 commits implementing user authentication
SPEC: Generate a descriptive PR title and body summarizing all changes, add appropriate labels, target the main branch
CONSTRAINTS: Use conventional commit style for the title" \
  --model claude-sonnet-4.6 \
  --allow-tool 'shell(*:*)'
```

## Example 5: Complex Refactoring (Large Scope)

**Task Type**: Complex architecture
**Selected Parameters**: `claude-opus-4.7` + shell/write tools

> **Tip:** For large-scope refactors, consider using interactive mode with `/plan` first to align on the approach before executing.

```bash
copilot -p "TASK: Refactor the monolithic user service into separate auth and profile services
CONTEXT: TypeScript/Node.js monorepo, current user service in packages/user-service/
SPEC: Split into packages/auth-service/ and packages/profile-service/, maintain API compatibility, share types via packages/shared-types/
CONSTRAINTS: Keep existing API routes unchanged
SCOPE: Add integration tests for service boundaries; do not touch packages outside user-service/, auth-service/, profile-service/, shared-types/" \
  --model claude-opus-4.7 \
  --allow-tool 'shell(*:*)' --allow-tool 'write(*:*)'
```

## Example 6: Quick Question (Minimal Tools)

**Task Type**: Quick question
**Selected Parameters**: `claude-sonnet-4.6` + no tools

> **Note:** For simple questions, the structured TASK/CONTEXT/SPEC format is optional — plain natural language works fine.

```bash
copilot -p "Explain the difference between useEffect and useLayoutEffect in React, with examples of when to use each" \
  --model claude-sonnet-4.6
```

## Example 7: Test Generation

**Task Type**: Test generation
**Selected Parameters**: `claude-sonnet-4.6` + shell/write tools

```bash
copilot -p "TASK: Generate unit tests for the user service package
CONTEXT: Go project, user service in internal/service/user.go, existing tests in internal/service/user_test.go
SPEC: Cover all exported functions; test happy path, validation errors, and DB errors; aim for >80% coverage
CONSTRAINTS: Use existing testify patterns from user_test.go, use table-driven tests
SCOPE: Only add tests to user_test.go; do not modify production code" \
  --model claude-sonnet-4.6 \
  --allow-tool 'shell(*:*)' --allow-tool 'write(*:*)'
```

## Example 8: Interactive Mode with /plan

**Task Type**: Complex feature (interactive exploration)
**Selected Parameters**: `claude-opus-4.7` + shell/write tools

```bash
# Start interactive session, then use /plan before implementing
copilot \
  --model claude-opus-4.7 \
  --allow-tool 'shell(*:*)' --allow-tool 'write(*:*)'
```

Inside the session:
1. Describe the task and use `/plan` to generate an implementation plan
2. Review and confirm the plan
3. Use `/delegate` or proceed directly to implement

## Example 9: Working Outside $HOME (with --trust-dir)

**Task Type**: New feature / coding
**Selected Parameters**: `claude-sonnet-4.6` + shell/write tools + `--trust-dir`

```bash
# Required when working in mounted paths or directories outside $HOME
copilot -p "TASK: Add logging middleware to the API server
CONTEXT: Go server in /mnt/projects/api/cmd/server/main.go
SPEC: Log request method, path, status code, and latency using zerolog
CONSTRAINTS: Follow existing middleware patterns in /mnt/projects/api/internal/middleware/" \
  --model claude-sonnet-4.6 \
  --allow-tool 'shell(*:*)' --allow-tool 'write(*:*)' \
  --trust-dir .
```
