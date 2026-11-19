---
name: delegating-to-subagents
description: "Playbook for delegating work to subagents — what to hand off, how to pack context into the prompt, which effort to set, fanning out in parallel, and auditing results. Trigger only when user explicitly says \"delegating to subagents\" or \"/delegating-to-subagents\"; implementing-with-subagents reads it as a file."
disable-model-invocation: true
---

# Delegating to Subagents

The main session acts as architect and controller. Push context-heavy and mechanical work to fresh subagents; keep design, audit, and review in the parent.

## Boundaries

- Subagents cannot ask the user questions — resolve all ambiguity before delegating.
- Outward-facing or irreversible actions (push, PR creation, publish, delete) stay in the main session where the user can confirm. Don't delegate them.
- A background subagent's permission prompts surface in the main session and wait for the user, so background work that needs permissions stalls until someone answers. Keep background subagents to work that needs none.

## When to delegate

**Delegate:**
- Broad search or read-only exploration across many files.
- Independent units of work that can run in parallel.
- Context-heavy reading you won't need to reference in detail again.
- Mechanical multi-file edits with a fully specified, unambiguous spec.

**Keep in the main session:**
- Tightly-coupled work that requires shared state across steps.
- Anything that needs user clarification mid-task.
- Trivial quick edits where coordination overhead exceeds the benefit.
- Anything you can finish yourself in a handful of tool calls.
- Verifying or double-checking your own output — do that inline, not by spawning an agent.
- The hard architectural core of a problem.
- Final audit and integration of results.

When a more specific sibling skill fits, prefer it over this general guide: `using-codex` to hand review or coding work to Codex. `implementing-with-subagents` drives a written plan task-by-task, but only the user can start it — suggest it when that is the job.

## Workflow

1. **Resolve ambiguity first.** Subagents can't ask the user — if requirements are unclear, clarify them before writing a single delegation prompt.
2. **Pack the context.** The prompt is the only input channel; no conversation history is passed. Include file paths, the spec, constraints, and the expected return format.
3. **Set effort per task.** See Model and effort.
4. **Fan out.**

   > Spawn independent subagents in the same turn so they run in parallel. Sequence only when one task genuinely depends on another's output.

5. **Collect structured results.** Only the final message returns. Keep the parent lean — the main session audits, integrates, and reviews.
6. **Handle outcomes.** Branch on the reported status (see Result protocol). Re-dispatch fixes with updated context; when an agent is stuck, change the approach rather than blindly retrying.

## Model and effort

Do not set a model on subagents. Claude Code then picks it (the parent's model, or the configured default subagent model), so new releases are picked up without editing this skill. Set a model only when the user names one.

Effort is the lever for cost and latency:

| Task | Effort | Notes |
|------|--------|-------|
| Read-only broad exploration / search | `low` | Use the read-only **Explore** agent type |
| Standard implementation / multi-file edits with a clear spec | `medium` | Workhorse for standard work |
| Hard implementation, design, final audit/review | `high`–`xhigh` | Or keep the especially hard parts in the main session |

Raise effort for demanding agentic work; don't carry over defaults from a previous model without re-checking them against your own tasks. The Codex equivalent is `model_reasoning_effort` (see `using-codex`).

Agent type and effort are independent axes: the **Explore** agent type is read-only and ideal for search, while effort follows task difficulty. Pushing bulk work to subagents keeps the parent's context window from filling with output that never needs to return in detail.

## Result protocol

This is the single definition of the status protocol; `implementing-with-subagents` and the templates in both skills use it.

Require each subagent to end its final message with a status line followed by the artifact (changed file paths or a short summary). Statuses and how to respond:

- `COMPLETE` — finished and self-checked. Verify the result before relying on it.
- `COMPLETE_WITH_CAVEATS` — finished, but flagging a correctness risk or deviation. Weigh it, then verify.
- `MISSING_INPUT` — lacked something it needed. A subagent can't ask mid-task, so this is how the gap surfaces: supply what's missing and re-dispatch.
- `STUCK` — couldn't proceed. Diagnose before retrying: missing context → add it; task too large → split it; out of depth → raise the effort or keep it in main; the plan itself is wrong → bring it back to the user. Never re-run an unchanged prompt and hope.

## Rules

- Don't delegate while requirements are ambiguous — the agent can't ask, so it misfires.
- Don't delegate outward-facing or irreversible actions; confirm them in the parent.
- Prefer the smallest fan-out that covers the work — one agent if one suffices. Delegation multiplies cost and wall-clock, so it pays off on genuinely independent, sizeable tracks, not on small tasks.
- Parallel sibling agents are mutually invisible with no shared state — never have two agents edit the same file at once.
- Returns are summaries only; if details are needed later, have the agent persist them to a file as an artifact.
- Subagents can delegate further, but each layer returns only a summary to the one above — keep nesting shallow so the parent can still audit the work.
- Never blindly retry a stuck task — change the approach first.

## References

Read `references/examples.md` for worked delegation examples: parallel fan-out, an implement→review loop, and a context-packing prompt template.
