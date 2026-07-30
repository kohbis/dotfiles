---
name: reviewing-code
description: Structured code review with severity-based findings, multi-lens analysis (security, correctness, performance, infra, CI/CD), and scope inference from git state. Hub for the review skill family — escalates to /reviewing-with-codex or /reviewing-with-multi-models when depth or consensus is needed. Use over /code-review (effort-level based, supports --comment/--fix) and /review (PR-oriented) when you want a thorough inline review with structured output. Trigger when user says "reviewing code", "/reviewing-code", "code review", "review this", or when reviewing code changes.
---

# Reviewing Code

Tool-agnostic review that runs anywhere — no external CLI required. This is the default for an inline review you can deliver right now.

## Boundaries — deliver the review, don't publish it

Unless the user gives an explicit instruction to do so, this skill produces a review for the user to read and does not publish anything to GitHub. Posting a comment or approval is an outward-facing action with real consequences — it notifies people, can gate a merge, and is awkward to retract — so absent a clear instruction that call belongs to the user, not the reviewer. Without such an instruction, do not run write operations such as:

- `gh pr review` / `gh pr review --approve` — approving or requesting changes on a PR
- `gh pr comment` / `gh pr review --comment` — posting review comments
- `gh issue comment` — commenting on an issue
- `gh api ...` calls that do the equivalent

Deliver the findings in the conversation. If the user wants them on GitHub, they post them — or they explicitly ask you to, in which case confirm the exact PR/target first. Read-only commands (`git diff`, `gh pr diff`, `gh pr view`) are how you gather what to review and stay allowed.

## When to use this skill vs. siblings

| Want | Use |
|------|-----|
| An immediate review, here, no dependencies | **this skill** |
| Deeper reasoning on a gnarly/cross-cutting bug, delegated to Codex | `reviewing-with-codex` |
| Consensus across several models on a high-stakes change | `reviewing-with-multi-models` |

If a review starts to feel too deep or too important for a single inline pass, say so and suggest escalating — don't grind.

## 1. Establish scope — infer first, ask only when blocked

Front-loading questions stalls a review that could already be moving, so figure out what to review from context instead of interrogating the user:

- **Default scope is the current change set.** Run `git status` and `git diff` to see uncommitted work; for a branch or PR, use `git diff <base>...HEAD`. Review what changed and the code it touches, not the whole repo.
- **Detect the stack yourself** from file extensions and manifests (`package.json`, `go.mod`, `Cargo.toml`, `pyproject.toml`, k8s YAML, `.github/workflows/`). The tech is usually obvious from the files.
- **Ask only when genuinely stuck** — e.g. no VCS changes and no path given, or signals conflict. Then ask one targeted question, not a checklist.

## 2. Analyze — apply the right lenses

Read enough surrounding code to judge each finding in context. Pick the lenses that fit what changed rather than running every list mechanically.

**Code:**
- Security: input validation, injection risks, secrets exposure, auth/authz
- Correctness: edge cases, off-by-one, nil/undefined, concurrency races
- Performance: algorithmic complexity, N+1 queries, caching, memory growth
- Maintainability: naming, function size, duplication, test coverage
- Error handling: failure modes, logging, graceful degradation
- API contracts: interface consistency, backward compatibility, docs

**Infrastructure:** resource requests/limits, RBAC and network/pod-security policies, HA (replicas, PDB, health/readiness probes), secret management (references, not hardcoded credentials).

**CI/CD:** parallelization, dependency and Docker-layer caching, fast-feedback ordering (lint/type-check before heavy suites), redundant or skippable steps via path filters.

## 3. Collect, then filter — two passes, not one

Run these as two separate steps. Merging them makes you suppress findings while you're still looking, which loses real issues.

**Collect.** Note everything the lenses surface. Don't filter for severity or second-guess whether something is worth mentioning yet — that's the next step's job.

**Filter.** Then work the list down, because a review that's 90% nits trains the reader to ignore the 10% that matters:

- **Confirm each finding before it ships.** Read the call site — the case may already be guarded elsewhere. Anything you couldn't confirm is dropped or marked with `~`, never stated as fact.
- **Prioritize by impact × likelihood**, not by how easy something was to spot.
- **Don't inflate nits.** Style preferences are Low at most; never Critical/High.
- **Mark confidence.** Separate "this is a bug" from "worth a second look" so the reader knows where to look hard.

## 4. Report

Lead with the verdict so the reader gets the gist before the list. Use `~` to flag a finding you're not fully sure of.

```
## Verdict
[1-2 sentences: overall state + the single most important thing to address]

## Findings

### Critical
- [what]: [why it matters] — [suggested fix] (file:line)

### High
- [what]: [why it matters] — [suggested fix] (file:line)

### Medium
- ...

### Low / Suggestions
- ...

## Next Steps
- [follow-up worth doing, if any]
```

Drop empty severity sections rather than printing "none". If there's nothing material to flag, say so plainly instead of manufacturing findings.

## References

- [examples](references/examples.md) — worked findings by review type (security, infra, CI/CD, bug investigation)
