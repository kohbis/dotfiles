# Practical Examples

## Example 1: New Feature Implementation (API Endpoint)

**Task Type**: New feature implementation
**Selected Parameters**: `gpt-5.3-codex` + `high` + `workspace-write` + `--full-auto`

```bash
codex exec \
  --model gpt-5.3-codex \
  --config model_reasoning_effort="high" \
  --sandbox workspace-write \
  --full-auto \
  --skip-git-repo-check \
  -C . \
  "TASK: Implement POST /api/v1/users endpoint for user registration
CONTEXT: Go HTTP server using chi router, PostgreSQL via sqlx, existing handlers in internal/handler/
SPEC: Accept JSON body {email, password, name}, validate input, hash password with bcrypt, insert to users table, return 201 with user ID; return 400 on validation error, 409 on duplicate email
CONSTRAINTS: Follow existing handler patterns in internal/handler/user.go, use existing db.User model, do not modify migration files"
```

## Example 2: Bug Fix (with Reproduction Steps)

**Task Type**: Bug fix
**Selected Parameters**: `gpt-5.3-codex` + `xhigh` + `workspace-write` + `--full-auto`

```bash
codex exec \
  --model gpt-5.3-codex \
  --config model_reasoning_effort="xhigh" \
  --sandbox workspace-write \
  --full-auto \
  --skip-git-repo-check \
  -C . \
  "TASK: Fix race condition causing duplicate records in order processing
CONTEXT: Go service, PostgreSQL, order processing in pkg/order/processor.go
SPEC: Reproduce: send 2 concurrent POST /orders with same idempotency key → 2 records inserted. Expected: exactly 1 record, second request returns existing order. Fix using DB-level unique constraint + upsert or advisory lock.
CONSTRAINTS: Do not change the HTTP handler signature; fix must be in processor.go and/or migration; add a test reproducing the race condition"
```

## Example 3: Test Suite Generation

**Task Type**: Test generation
**Selected Parameters**: `gpt-5.3-codex` + `medium` + `workspace-write` + `--full-auto`

```bash
codex exec \
  --model gpt-5.3-codex \
  --config model_reasoning_effort="medium" \
  --sandbox workspace-write \
  --full-auto \
  --skip-git-repo-check \
  -C . \
  "TASK: Generate unit tests for pkg/pricing/ package
CONTEXT: Go project, testify for assertions, existing tests in *_test.go files alongside source
SPEC: Cover happy paths, boundary values, and error cases for all exported functions; mock external dependencies using interfaces already defined; aim for >80% coverage
CONSTRAINTS: Match existing test file naming (*_test.go), use table-driven tests where applicable, do not modify source files"
```

## Example 4: Refactoring (Adding Type Safety)

**Task Type**: New feature implementation (type safety refactor)
**Selected Parameters**: `gpt-5.3-codex` + `high` + `workspace-write` + `--full-auto`

```bash
codex exec \
  --model gpt-5.3-codex \
  --config model_reasoning_effort="high" \
  --sandbox workspace-write \
  --full-auto \
  --skip-git-repo-check \
  -C . \
  "TASK: Replace stringly-typed status fields with typed enums across the codebase
CONTEXT: TypeScript/Node.js project, status fields currently use plain strings like 'active', 'inactive', 'pending'
SPEC: Define Status enum in src/types/status.ts, update all usages in src/models/ and src/services/, add Zod validation schemas for API boundaries
CONSTRAINTS: Do not change DB schema or migration files; keep backward compatibility for JSON serialization (enum values must match existing string values)"
```

## Example 5: Session Continuation

```bash
echo "Also add integration tests for the new endpoint using testcontainers" | \
  codex exec --skip-git-repo-check resume --last
```
