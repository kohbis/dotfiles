---
name: codex-cli
description: Execute code review, analysis, and technical research using Codex CLI. Use cases: (1) Code review, (2) Codebase-wide analysis, (3) Answering technical questions, (4) Bug investigation, (5) Refactoring proposals, (6) Deep technical research. Triggers: "codex", "/codex"
---

# Codex

Execute deep technical analysis, code review, and research using Codex CLI.

## Trigger Conditions

Activate this skill when:
- User says: "codex", "/codex"
- User requests: code review, bug investigation, refactoring, infrastructure analysis
- Task requires: deep technical analysis beyond simple grep/read operations

## Command Template

```bash
codex exec \
  --model {MODEL} \
  --config model_reasoning_effort="{LEVEL}" \
  --sandbox {SANDBOX_MODE} \
  {AUTO_FLAG} \
  --skip-git-repo-check \
  -C {WORKING_DIR} \
  "{PROMPT}" \
  {SUPPRESS_FLAG}
```

## Decision Flow

```
START
  ↓
1. Clarify task requirements
  ↓
2. Select parameters using Parameter Selection Matrix
  ↓
3. Construct structured prompt (TASK/CONTEXT/FOCUS/OUTPUT)
  ↓
4. Run Pre-execution Checklist
  ↓
5. Execute command via Bash tool
  ↓
6. Report results (Key findings → Recommendations → Next steps)
  ↓
END
```

## Parameter Selection Matrix

| Task Type | Model | Reasoning Level | Sandbox Mode | --full-auto | Use Case |
|-----------|-------|----------------|--------------|-------------|----------|
| Complex bug investigation | gpt-5.3-codex | xhigh | read-only | NO | Deep root cause analysis |
| Large-scale refactoring | gpt-5.3-codex | high | workspace-write | YES | Modify multiple files |
| Standard code review | gpt-5.3-codex | high | read-only | NO | Security/performance review |
| Infrastructure analysis | gpt-5.3-codex | high | read-only | NO | K8s/Terraform review |
| CI/CD optimization | gpt-5.2 | medium | read-only | NO | Pipeline analysis |
| Quick code question | gpt-5.2 | medium | read-only | NO | Simple inquiries |

## Parameter Definitions

### {MODEL}
- `gpt-5.3-codex`: Code-specialized model (prefer for code analysis)
- `gpt-5.2`: General-purpose model (use for CI/CD, infrastructure config)

### {LEVEL}
- `xhigh`: Deepest analysis (complex bugs, critical refactoring)
- `high`: Standard deep analysis (code review, design analysis)
- `medium`: Balanced analysis (CI/CD, quick review)
- `low`: Lightweight analysis (simple questions)

### {SANDBOX_MODE}
- `read-only`: Analysis without file modifications (DEFAULT for review/investigation)
- `workspace-write`: Allow file editing (refactoring, code generation)
- `danger-full-access`: Network access enabled (requires user confirmation)

### {AUTO_FLAG}
- IF `{SANDBOX_MODE}` == `workspace-write` THEN `--full-auto`
- ELSE empty string

### {WORKING_DIR}
- DEFAULT: `.` (current directory)
- OR: Specific project directory path

### {SUPPRESS_FLAG}
- DEFAULT: empty string (show reasoning process)
- IF user says "hide process" OR "concise output" THEN `2>/dev/null`

## Pre-execution Checklist

Run through this checklist before executing:

- [ ] Task type identified
- [ ] Model selected: `gpt-5.3-codex` OR `gpt-5.2`
- [ ] Reasoning level determined: `xhigh`/`high`/`medium`/`low`
- [ ] Sandbox mode chosen: `read-only`/`workspace-write`/`danger-full-access`
- [ ] IF `workspace-write` THEN confirm `--full-auto` is added
- [ ] IF `danger-full-access` THEN user confirmation obtained
- [ ] Confirm `--skip-git-repo-check` is included
- [ ] IF user wants hidden output THEN confirm `2>/dev/null` is added
- [ ] Structured prompt prepared (TASK/CONTEXT/FOCUS/OUTPUT)

## Structured Prompt Template

```
TASK: {clear, specific action}
CONTEXT: {tech stack, environment, constraints}
FOCUS: {specific areas to examine}
OUTPUT: {desired format and detail level}
```

### Prompt Design Rules

MUST:
- Be specific and focused
- Include relevant technical context
- Define clear output expectations

SHOULD:
- Limit scope to avoid overwhelm
- Specify priority areas

MUST NOT:
- Use vague language ("check everything", "make it better")
- Include unnecessary background information

## Rules and Constraints

### MUST (Required)

1. **Always include** `--skip-git-repo-check`
2. **Always specify** `--model`
3. **Always specify** `--config model_reasoning_effort`
4. **Always specify** `--sandbox`
5. **Add** `--full-auto` when using `workspace-write`

### SHOULD (Recommended)

1. Use `gpt-5.3-codex` for code analysis tasks
2. Use structured prompt format (TASK/CONTEXT/FOCUS/OUTPUT)
3. Default to showing reasoning process (no `2>/dev/null`)
4. Start with `read-only` unless editing is required

### MAY (Optional)

1. Add `2>/dev/null` if user explicitly requests hidden output
2. Add `--timeout` for large projects
3. Adjust reasoning level based on task complexity

### MUST NOT (Prohibited)

1. Use `danger-full-access` without user confirmation
2. Omit `--skip-git-repo-check` flag
3. Use `--full-auto` with `read-only` (unnecessary)
4. Execute vague or unfocused prompts

## Session Continuation

To resume previous Codex session:

```bash
echo "{additional instructions}" | codex exec --skip-git-repo-check resume --last
```

OR simply continue without additional input:

```bash
codex exec --skip-git-repo-check resume --last
```

Notes:
- Previous model and sandbox settings are automatically inherited
- Use when building on previous analysis

## Practical Examples

### Example 1: Kubernetes Manifests Review

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

### Example 2: API Performance Investigation

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

### Example 3: Database Layer Refactoring

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

### Example 4: CI/CD Pipeline Analysis

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

### Example 5: Session Continuation

```bash
echo "Also check for security vulnerabilities in the pipeline configuration" | \
  codex exec --skip-git-repo-check resume --last
```

## Output Formatting

When reporting Codex results to user, use this structure:

```
## Key Findings
- [Most critical finding]
- [Second priority finding]
- [Third priority finding]

## Recommended Actions
1. [Immediate action with highest impact]
2. [Secondary action]
3. [Long-term improvement]

## Next Steps
- [Specific next action to take]
- [Follow-up investigation if needed]
```

## Error Handling

### IF execution fails:
1. Report error immediately to user
2. Identify error type:
   - Command not found → Guide installation
   - Timeout → Suggest narrower scope or --timeout flag
   - Permission denied → Check sandbox mode
   - Invalid model → Verify model name
3. Suggest corrective action
4. Ask if user wants to retry with adjusted parameters

### IF user requests danger-full-access:
1. Explain implications (network access, system commands)
2. Ask explicit confirmation
3. IF confirmed THEN proceed
4. ELSE suggest safer alternative

## Troubleshooting Guide

| Issue | Solution |
|-------|----------|
| Command not found | Guide user to install Codex CLI |
| Timeout on large codebase | Add `--timeout` flag or narrow scope |
| Want to hide reasoning | Add `2>/dev/null` at end |
| Need to edit files | Use `workspace-write` + `--full-auto` |
| Need network access | Use `danger-full-access` with user confirmation |
| Session context lost | Use `resume --last` to continue |

## Implementation Notes

1. **Always use Bash tool** to execute codex commands
2. **Parse output** before presenting to user (summarize key points)
3. **Preserve important details** (error messages, specific recommendations)
4. **Maintain conversation context** when using resume
5. **Validate parameters** before execution using checklist
