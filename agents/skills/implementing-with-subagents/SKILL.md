---
name: implementing-with-subagents
description: "Drives a written implementation plan to completion one task at a time, each in a fresh subagent that is verified before the next begins. Trigger only when the user explicitly says \"implementing with subagents\" or \"/implementing-with-subagents\"."
disable-model-invocation: true
---

# Implementing with Subagents

Turn an approved plan into shipped code by running its tasks through fresh subagents, one at a time, verifying each before moving on. This main session stays the controller: it scopes each task, dispatches it, checks the result, and keeps the working tree coherent. It builds on `delegating-to-subagents` for the dispatch mechanics — context-packing, status returns, model choice.

## Boundaries

The internal loop — implement, verify, fix, repeat — runs without asking for confirmation at each step. Outward-facing and irreversible actions never run autonomously; they stay with the user, per the boundary `delegating-to-subagents` defines. Hand the ship step — push, PR, merge, finishing a branch — to `/shipping-with-git`, which already gates them. Never begin work on `main` or `master` without explicit consent.

## When to use

Reach for this when you already have a plan whose tasks are largely independent and the work will stay in this session. It executes a plan; it does not write one — the plan comes from plan mode or a written file. For the general question of *what* to delegate, see `delegating-to-subagents`; this skill is the execution loop on top of it.

Run one implementer at a time. Two subagents editing the same working tree share no state and will clobber each other.

## The loop

Record the current HEAD before each task so you can scope its review later. Then, per task:

1. Dispatch a fresh implementer subagent with the task pasted in full (never a pointer to the plan file — the prompt is its only input). See `references/templates.md`. It implements the task, tests it (`writing-tests`), commits a checkpoint, and reports a status.
2. Read the status and respond — see Status handling.
3. Verify in two passes, in this order:
   - **Requirements** — does the change actually do what the task asked, nothing missing and nothing extra? Confirm by reading the code, not by trusting the report.
   - **Craftsmanship** — is it well-built? Dispatch a reviewer over the task's `BASE..HEAD` applying the `reviewing-code` lenses.

   Fix and re-verify after every change. Don't start the craftsmanship pass until requirements are satisfied — reviewing the quality of code that solves the wrong problem is wasted effort.
4. When both passes are clean, mark the task done and move on.

After the last task, review the whole change once for integration, then ship via `/shipping-with-git`. The per-task commits are working checkpoints; the final history is shaped to the project's commit convention at ship time.

## Status handling

Ask each subagent to end with one status and the supporting detail (files changed, what was tested):

- `COMPLETE` — finished and self-checked. Proceed to verification.
- `COMPLETE_WITH_CAVEATS` — finished, but the agent flagged a risk or deviation. Weigh it, then verify.
- `MISSING_INPUT` — it lacked something it needed. A subagent can't ask you mid-task, so this is how the gap surfaces: supply what's missing and re-dispatch.
- `STUCK` — it couldn't proceed. Diagnose before retrying: missing context → add it; task too large → split it; model out of depth → raise the tier; the plan itself is wrong → bring it back to the user. Never re-run an unchanged prompt and hope.

## Model selection

Match the model to each task's difficulty — see the table in `delegating-to-subagents`, the canonical model-selection guidance and alias policy. For this loop: mechanical tasks go to `sonnet` (or `haiku`); architecturally tricky tasks and the craftsmanship review pass want `opus`, or keep them in this session.

## Rules

- Verify every task before starting the next — unverified work compounds.
- Check requirements before craftsmanship, and re-verify after every fix.
- Confirm findings by reading the code; a subagent's report is a claim, not proof.
- One implementer per working tree at a time.
- Paste the task text into the prompt; subagents don't read the plan file.
- Don't start on `main`/`master` without consent, and leave outward actions to the user.

## References

- `references/templates.md` — the implementer dispatch skeleton and the two verification passes
- `delegating-to-subagents` — dispatch mechanics this skill builds on
- `writing-tests`, `reviewing-code` — how the implementer tests and how the craftsmanship pass reviews
- `managing-git-worktrees` — give a task its own checkout when isolation helps
- `shipping-with-git` — the gated ship step once all tasks pass
