# Practical Examples

`{MODEL}` is the model ID for the selected tier — see the Models table in SKILL.md.

## Example 1: Kubernetes Manifests Review

**Mode**: Review — infrastructure analysis
**Selected Parameters**: frontier tier + `high` + `read-only`

```bash
codex exec \
  --model {MODEL} \
  --config model_reasoning_effort="high" \
  --sandbox read-only \
  --skip-git-repo-check \
  -C . \
  "TASK: Review Kubernetes manifests and Helm charts for production deployment
CONTEXT: Microservices architecture with 15+ services, multi-environment deployment
FOCUS: Resource limits, security policies, high availability configuration, secret management
OUTPUT: List issues by severity with specific remediation steps for each finding" \
  2>/dev/null
```

## Example 2: API Performance Investigation

**Mode**: Review — complex bug investigation
**Selected Parameters**: frontier tier + `xhigh` + `read-only`

```bash
codex exec \
  --model {MODEL} \
  --config model_reasoning_effort="xhigh" \
  --sandbox read-only \
  --skip-git-repo-check \
  -C . \
  "TASK: Identify the cause of API response time degradation
CONTEXT: Go microservice with PostgreSQL, response time increased from 50ms to 2s under load
FOCUS: Database query patterns, connection pooling, caching layer, N+1 query problems
OUTPUT: Explain root cause, reproduction conditions, and optimization strategy step by step" \
  2>/dev/null
```

## Example 3: New Feature Implementation (API Endpoint)

**Mode**: Coding — new feature implementation
**Selected Parameters**: frontier tier + `high` + `workspace-write` + `--approve-for-me`

```bash
codex exec \
  --model {MODEL} \
  --config model_reasoning_effort="high" \
  --sandbox workspace-write \
  --approve-for-me \
  --skip-git-repo-check \
  -C . \
  "TASK: Implement POST /api/v1/users endpoint for user registration
CONTEXT: Go HTTP server using chi router, PostgreSQL via sqlx, existing handlers in internal/handler/
SPEC: Accept JSON body {email, password, name}, validate input, hash password with bcrypt, insert to users table, return 201 with user ID; return 400 on validation error, 409 on duplicate email
CONSTRAINTS: Follow existing handler patterns in internal/handler/user.go, use existing db.User model, do not modify migration files" \
  2>/dev/null
```

## Example 4: Test Suite Generation

**Mode**: Coding — test generation
**Selected Parameters**: balanced tier + `medium` + `workspace-write` + `--approve-for-me`

```bash
codex exec \
  --model {MODEL} \
  --config model_reasoning_effort="medium" \
  --sandbox workspace-write \
  --approve-for-me \
  --skip-git-repo-check \
  -C . \
  "TASK: Generate unit tests for pkg/pricing/ package
CONTEXT: Go project, testify for assertions, existing tests in *_test.go files alongside source
SPEC: Cover happy paths, boundary values, and error cases for all exported functions; mock external dependencies using interfaces already defined; aim for >80% coverage
CONSTRAINTS: Match existing test file naming (*_test.go), use table-driven tests where applicable, do not modify source files" \
  2>/dev/null
```

## Example 5: Session Continuation

```bash
echo "Also add integration tests for the new endpoint using testcontainers" | \
  codex exec --skip-git-repo-check resume --last
```
