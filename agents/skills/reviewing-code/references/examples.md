# Worked Examples

Concrete findings by review type. These show the *shape* of a good finding (what → why → fix → location) and the things worth looking for in each domain — not a script to follow verbatim.

## Contents

- Example 1: Security-focused code review
- Example 2: Kubernetes manifest review (infrastructure)
- Example 3: CI/CD pipeline optimization
- Example 4: Performance bug investigation
- Example 5: Incremental follow-up

## Example 1: Security-focused code review

Node.js/Express REST API, JWT auth, PostgreSQL user store. Scope inferred from `git diff` touching `src/auth/` and `src/repositories/`.

Worth looking for:
- JWT secret hardcoded or committed (should come from env)
- Missing token-expiry validation
- SQL built by string concatenation instead of parameterized queries
- No rate limiting on auth endpoints
- Auth failures not logged

Sample findings:
```
## Verdict
Auth logic is sound, but one SQL injection in the login path needs fixing before merge.

## Findings

### Critical
- SQL injection in login lookup: user-supplied `email` is concatenated into the query, allowing auth bypass — use a parameterized query ($1) (src/repositories/users.ts:42)

### High
- JWT secret read from a hardcoded fallback when env is unset: leaks a forgeable signing key — fail fast if `JWT_SECRET` is missing (src/auth/jwt.ts:11)

### Medium
- ~ No rate limiting on `/login`: enables credential stuffing — add express-rate-limit (src/routes/auth.ts:18)
```

## Example 2: Kubernetes manifest review

Microservices, multi-environment deployment. Scope = changed manifests under `manifests/`.

Worth looking for: resource requests/limits, secret references vs plaintext env, readiness/liveness probes, replica count + PDB, network policies.

```
## Verdict
Deployments are functional but two production-readiness gaps (no memory limit, plaintext secret) should be closed.

## Findings

### Critical
- No resource limits on api-service: a leak can starve the node — add requests/limits (manifests/api-service.yaml:34)

### High
- DB password as plaintext env var: exposed in `kubectl describe` — use secretKeyRef (manifests/worker.yaml:22)

### Medium
- Missing readiness probe on db-service: traffic may route before ready — add a readiness probe (manifests/db-service.yaml:18)
```

## Example 3: CI/CD pipeline optimization

GitHub Actions, multi-service, ~25 min builds. Scope = `.github/workflows/`.

Common optimizations and the *why*:
- Run lint/type-check before heavy tests — fail fast, save minutes on broken PRs
- Cache `node_modules` / Go modules between runs — avoids repeated installs
- Docker layer caching with `cache-from` — skips unchanged image layers
- Split test jobs to run in parallel — wall-clock reduction
- Path filters to skip unchanged services — don't rebuild what didn't change

Frame each as a finding with the expected time saved where you can estimate it, e.g.:
```
### High
- Tests run before lint, so a lint-only failure still pays the full 18-min test cost — reorder to lint → test (fail fast) (.github/workflows/ci.yml:30)
```

## Example 4: Performance bug investigation

Go + PostgreSQL service; p95 latency rose 50ms → 2s under load. This is investigation, not a checklist — trace the path and report root cause.

Examine: ORM-generated queries (SELECT N+1), connection pool config (`max_open_conns`, `max_idle_conns`), missing indexes on hot columns, unbounded result sets without pagination.

Report the root cause, how to reproduce it, and the fix — confidence-marked if you couldn't confirm under load:
```
## Verdict
Latency regression is an N+1 introduced in the orders list endpoint; confirmed by query count, fix is an eager join.

### Critical
- N+1 in `ListOrders`: one query per order to fetch its customer (100 orders = 101 queries) — preload customers with a join (src/repositories/orders.go:88)
```

## Example 5: Incremental follow-up

After an initial review, the user often narrows in. Continue in the same format, reusing established context:

```
Based on the findings, can you also:
- Check the same N+1 pattern in src/repositories/orders.go
- Review the migration files for missing indexes
- Estimate the impact of a Redis cache layer
```
