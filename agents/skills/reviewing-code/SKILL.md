---
name: reviewing-code
description: Structured inline code review with severity-based findings across security, correctness, performance, infra, and CI/CD lenses, scoped from git state. Hub for the review skill family. Use when the user asks to review code or changes ("code review", "review this", "/reviewing-code").
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
| Deeper reasoning on a gnarly/cross-cutting bug, delegated to Codex | `using-codex` (review mode) |
| A second opinion from another model family on a high-stakes change | this skill + Codex — see *Second opinion* below |

If a review starts to feel too deep or too important for a single inline pass, say so and suggest escalating — don't grind.

## 1. Establish scope — infer first, ask only when blocked

Front-loading questions stalls a review that could already be moving, so figure out what to review from context instead of interrogating the user:

- **Default scope is the current change set.** Run `git status` and `git diff` to see uncommitted work; for a branch or PR, use `git diff <base>...HEAD`. Review what changed and the code it touches, not the whole repo.
- **Detect the stack yourself** from file extensions and manifests (`package.json`, `go.mod`, `Cargo.toml`, `pyproject.toml`, k8s YAML, `.github/workflows/`). The tech is usually obvious from the files.
- **Ask only when genuinely stuck** — e.g. no VCS changes and no path given, or signals conflict. Then ask one targeted question, not a checklist.

## 2. Analyze — apply the right lenses

Read enough surrounding code to judge each finding in context. Pick the lenses that fit what changed rather than running every one mechanically: for code — security, correctness, performance, maintainability (including test coverage), error handling, and API contracts; for infrastructure — resource limits, access policies, availability, and secret handling; for CI/CD — caching, parallelism, and fail-fast ordering.

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

## Second opinion

For a high-stakes change, add an independent pass from a different model family: run `using-codex` in review mode on the same target and scope, in parallel with your own review. The diff goes to an external CLI, so warn the user first if it may contain secrets or PII.

Then merge the two into one report in the format above:

- Map Codex's severities onto Critical / High / Medium / Low.
- Treat findings as the same when they share a root cause in the same file or function, even if worded differently.
- Lead with findings both reviewers raised — independent agreement is the strongest signal. Keep single-reviewer findings and note which reviewer raised them.
- Confirm every `file:line` against the actual diff; drop any that don't exist in the reviewed changes.
- If Codex fails or times out, say so and report your own review.
