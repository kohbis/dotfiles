---
name: delegating-to-subagents
description: "Orchestrates work across subagents to save the main session's context and tokens — deciding what to delegate, packing full context into each prompt, picking the right model per task, fanning out independent work in parallel, and auditing the results. Use whenever you're about to spawn subagents, run agents in parallel, or want the main session to stay on design and review while cheaper models do the legwork. This is the general delegation playbook; when a more specific skill fits — implementing-with-subagents to drive a plan task-by-task, reviewing-with-multi-models to review across models, coding-with-codex to hand work to Codex — prefer that one."
---

# Delegating to Subagents

The main session acts as architect and controller. Push context-heavy and mechanical work to fresh subagents on cheaper models; keep design, audit, and review in the parent.

## Boundaries

- Subagents cannot ask the user questions — resolve all ambiguity before delegating.
- Outward-facing or irreversible actions (push, PR creation, publish, delete) stay in the main session where the user can confirm. Don't delegate them.
- Background subagents auto-deny permission prompts, so never hand them side-effectful work.

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
- The hard architectural core of a problem.
- Final audit and integration of results.

When a more specific sibling skill fits, prefer it over this general guide: `implementing-with-subagents` to drive a plan task-by-task, `reviewing-with-multi-models` to review across models, `coding-with-codex` to hand work to Codex.

## Workflow

1. **Resolve ambiguity first.** Subagents can't ask the user — if requirements are unclear, clarify them before writing a single delegation prompt.
2. **Pack the context.** The prompt is the only input channel; no conversation history is passed. Include file paths, the spec, constraints, and the expected return format.
3. **Pick a model per task.** See Model selection.
4. **Fan out.**

   > Spawn independent subagents in the same turn so they run in parallel. Sequence only when one task genuinely depends on another's output.

5. **Collect structured results.** Only the final message returns. Keep the parent lean — the main session audits, integrates, and reviews.
6. **Handle outcomes.** Branch on the reported status (see Result protocol). Re-dispatch fixes with updated context; when an agent is stuck, change the approach rather than blindly retrying.

## Model selection

| Task | Model | Notes |
|------|-------|-------|
| Read-only broad exploration / search | `haiku` | Use the read-only **Explore** agent type |
| Standard implementation / multi-file edits with a clear spec | `sonnet` | Workhorse for standard work |
| Hard implementation, design, final audit/review | `opus`, or do it yourself in the main session | Keep the especially hard parts in main |

Agent type and model are independent axes: the **Explore** agent type is read-only and ideal for search, while the model is chosen separately by task difficulty. Claude Code uses family aliases (`opus`/`sonnet`/`haiku`/`fable`); routing mechanical work to cheaper models keeps the parent's context window from filling with bulk output that never needs to return in detail.

## Result protocol

Require each subagent to end its final message with a status line followed by the artifact (changed file paths or a short summary). Statuses:

- `COMPLETE` — finished and self-checked.
- `COMPLETE_WITH_CAVEATS` — finished but flagging correctness risks to address.
- `MISSING_INPUT` — lacked something it needed; supply it and re-dispatch.
- `STUCK` — couldn't proceed; diagnose the cause and change approach (switch model, decompose the task, or revise the plan) — never just retry unchanged.

## Rules

- Don't delegate while requirements are ambiguous — the agent can't ask, so it misfires.
- Don't delegate outward-facing or irreversible actions; confirm them in the parent.
- Parallel sibling agents are mutually invisible with no shared state — never have two agents edit the same file at once.
- Returns are summaries only; if details are needed later, have the agent persist them to a file as an artifact.
- Subagents can't spawn subagents (no nesting) — don't design a plan that assumes they can.
- Never blindly retry a stuck task — change the approach first.

## References

Read `references/examples.md` for worked delegation examples: parallel fan-out, an implement→review loop, and a context-packing prompt template.
