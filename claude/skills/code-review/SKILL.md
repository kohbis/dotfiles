---
name: code-review
description: Perform code review, bug investigation, infrastructure analysis, and CI/CD optimization. Trigger when user says "code review" or "/code-review", or when reviewing code changes.
---

# Code Review

## Review Types

| Task Type | Focus Areas | Output Style |
|-----------|-------------|--------------|
| Code review | Quality, security, maintainability | Findings by severity |
| Bug investigation | Root cause, reproduction path | Step-by-step analysis |
| Infrastructure analysis | Resource config, security policies, HA | Issues with remediation |
| CI/CD optimization | Build time, test strategy, bottlenecks | Optimization suggestions |

## Workflow

### 1. Gather Context

Ask the user for:
- Target files or directories to review
- Tech stack and environment
- Specific concerns or focus areas
- Desired output format

### 2. Analyze

Read relevant files and examine:

**Code Review Checklist:**
- Security: input validation, injection risks, secrets exposure, auth/authz
- Performance: algorithmic complexity, N+1 queries, caching opportunities, memory leaks
- Maintainability: naming clarity, function size, duplication, test coverage
- Error handling: failure modes, logging, graceful degradation
- API contracts: interface consistency, backward compatibility, documentation

**Infrastructure Checklist:**
- Resource limits (CPU/memory requests and limits)
- Security policies (RBAC, network policies, pod security)
- High availability (replicas, PDB, health checks)
- Secret management (no hardcoded credentials, proper secret references)

**CI/CD Checklist:**
- Parallelization opportunities
- Cache utilization (dependencies, Docker layers)
- Test execution strategy (fast feedback first)
- Unnecessary steps or redundant jobs

### 3. Report Findings

Use the following output format:

```
## Key Findings

### Critical
- [issue]: [explanation] (file:line)

### High
- [issue]: [explanation] (file:line)

### Medium
- [issue]: [explanation] (file:line)

### Low / Suggestions
- [issue]: [explanation] (file:line)

## Recommended Actions

1. [action] — [rationale]
2. [action] — [rationale]

## Next Steps

- [follow-up task or investigation]
```

## Prompt Format

When the user provides a review request, structure it internally as:

```
TASK: {clear, specific action}
CONTEXT: {tech stack, environment, constraints}
FOCUS: {specific files, directories, or concerns}
OUTPUT: {desired format and detail level}
```

## References

- [examples](references/examples.md) - Practical usage patterns by review type
