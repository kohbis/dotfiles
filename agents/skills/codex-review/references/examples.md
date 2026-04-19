# Practical Examples

## Example 1: Kubernetes Manifests Review

**Task Type**: Infrastructure analysis
**Selected Parameters**: `gpt-5.3-codex` + `high` + `read-only`

```bash
codex exec \
  --model gpt-5.3-codex \
  --config model_reasoning_effort="high" \
  --sandbox read-only \
  --skip-git-repo-check \
  -C . \
  "TASK: Review Kubernetes manifests and Helm charts for production deployment
CONTEXT: Microservices architecture with 15+ services, multi-environment deployment
FOCUS: Resource limits, security policies, high availability configuration, secret management
OUTPUT: List issues by severity with specific remediation steps for each finding"
```

## Example 2: API Performance Investigation

**Task Type**: Complex bug investigation
**Selected Parameters**: `gpt-5.3-codex` + `xhigh` + `read-only`

```bash
codex exec \
  --model gpt-5.3-codex \
  --config model_reasoning_effort="xhigh" \
  --sandbox read-only \
  --skip-git-repo-check \
  -C . \
  "TASK: Identify the cause of API response time degradation
CONTEXT: Go microservice with PostgreSQL, response time increased from 50ms to 2s under load
FOCUS: Database query patterns, connection pooling, caching layer, N+1 query problems
OUTPUT: Explain root cause, reproduction conditions, and optimization strategy step by step"
```

## Example 3: Database Layer Refactoring

**Task Type**: Large-scale refactoring
**Selected Parameters**: `gpt-5.3-codex` + `high` + `workspace-write` + `--full-auto`

```bash
codex exec \
  --model gpt-5.3-codex \
  --config model_reasoning_effort="high" \
  --sandbox workspace-write \
  --full-auto \
  --skip-git-repo-check \
  -C . \
  "TASK: Refactor database access layer to implement repository pattern
CONTEXT: Direct database queries scattered across service layer causing tight coupling and testing difficulties
FOCUS: pkg/repository/ and pkg/service/ directories
OUTPUT: Implement repository pattern, add proper error handling, and explain architectural improvements"
```

## Example 4: CI/CD Pipeline Analysis

**Task Type**: CI/CD optimization
**Selected Parameters**: `gpt-5.2` + `medium` + `read-only`

```bash
codex exec \
  --model gpt-5.2 \
  --config model_reasoning_effort="medium" \
  --sandbox read-only \
  --skip-git-repo-check \
  -C . \
  "TASK: Analyze CI/CD pipeline configuration and identify optimization opportunities
CONTEXT: GitHub Actions workflow for multi-service deployment, build time is 25+ minutes
FOCUS: .github/workflows/ directory, Docker build process, test execution strategy
OUTPUT: Identify bottlenecks and suggest specific optimization techniques with expected time savings"
```

## Example 5: Session Continuation

```bash
echo "Also check for security vulnerabilities in the pipeline configuration" | \
  codex exec --skip-git-repo-check resume --last
```
