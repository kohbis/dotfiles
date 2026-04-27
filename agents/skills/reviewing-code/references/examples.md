# Practical Examples

## Contents

- Example 1: Kubernetes Manifests Review (infrastructure)
- Example 2: API Performance Investigation (bug investigation)
- Example 3: Security-Focused Code Review
- Example 4: CI/CD Pipeline Analysis
- Example 5: Incremental Follow-up Review

## Example 1: Kubernetes Manifests Review

**Task Type**: Infrastructure analysis

**Prompt structure:**
```
TASK: Review Kubernetes manifests and Helm charts for production deployment
CONTEXT: Microservices architecture with 15+ services, multi-environment deployment
FOCUS: Resource limits, security policies, high availability configuration, secret management
OUTPUT: List issues by severity with specific remediation steps for each finding
```

**Expected output format:**
```
## Key Findings

### Critical
- No resource limits on api-service: Pod can consume unlimited memory (manifests/api-service.yaml:34)

### High
- Secrets stored as plaintext env vars: Use secretKeyRef instead (manifests/worker.yaml:22)

### Medium
- Missing readiness probe on db-service: May route traffic before ready (manifests/db-service.yaml:18)

## Recommended Actions
1. Add resource requests/limits to all Deployments
2. Migrate env vars to Secret references

## Next Steps
- Review network policies for inter-service communication
```

---

## Example 2: API Performance Investigation

**Task Type**: Complex bug investigation

**Prompt structure:**
```
TASK: Identify the cause of API response time degradation
CONTEXT: Go microservice with PostgreSQL, response time increased from 50ms to 2s under load
FOCUS: Database query patterns, connection pooling, caching layer, N+1 query problems
OUTPUT: Explain root cause, reproduction conditions, and optimization strategy step by step
```

**Key areas to examine:**
- ORM-generated queries (check for SELECT N+1 patterns)
- Connection pool configuration (`max_open_conns`, `max_idle_conns`)
- Missing indexes on frequently queried columns
- Unbounded result sets without pagination

---

## Example 3: Security-Focused Code Review

**Task Type**: Code review

**Prompt structure:**
```
TASK: Security review of authentication and authorization implementation
CONTEXT: Node.js/Express REST API, JWT-based auth, PostgreSQL user store
FOCUS: src/auth/, src/middleware/auth.ts, SQL queries in src/repositories/
OUTPUT: Security findings with CVE references where applicable and concrete fixes
```

**Common findings to look for:**
- JWT secret hardcoded or in source (should be env var)
- Missing token expiry validation
- SQL queries using string concatenation instead of parameterized queries
- Missing rate limiting on auth endpoints
- Insufficient logging for auth failures

---

## Example 4: CI/CD Pipeline Analysis

**Task Type**: CI/CD optimization

**Prompt structure:**
```
TASK: Analyze CI/CD pipeline configuration and identify optimization opportunities
CONTEXT: GitHub Actions workflow for multi-service deployment, build time is 25+ minutes
FOCUS: .github/workflows/ directory, Docker build process, test execution strategy
OUTPUT: Identify bottlenecks and suggest specific optimization techniques with expected time savings
```

**Common optimizations:**
- Split test jobs to run in parallel
- Cache `node_modules` / Go modules between runs
- Use Docker layer caching with `cache-from`
- Run lint/type-check before heavier test suites (fail fast)
- Skip unchanged services using path filters

---

## Example 5: Incremental Follow-up Review

After an initial review, continue the analysis by asking:

```
Based on the findings, can you also:
- Check if the same N+1 pattern exists in src/repositories/orders.ts
- Review the migration files for missing indexes
- Estimate the impact of adding a Redis cache layer
```
