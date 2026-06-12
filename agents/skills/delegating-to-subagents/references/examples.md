# Delegating to Subagents — Examples

## Example 1 — Parallel exploration fan-out

When you need to survey several independent areas, spawn all the Explore/research subagents in a single turn so they run concurrently. Each gets a focused prompt with its own scope; each returns only a final summary — you don't need the raw file contents back.

```
# Subagent A — dispatched in the same turn as B
Explore agent, haiku model.
Search /src/api for all route definitions. List each route, its HTTP method,
and the handler file. Return a plain table.
End with: COMPLETE <table> or STUCK <reason>.

# Subagent B — dispatched in the same turn as A
Explore agent, haiku model.
Search /src/middleware for any authentication or authorization middleware.
Summarize what each does and where it is applied.
End with: COMPLETE <summary> or STUCK <reason>.
```

Because A and B are independent, they run in parallel. The main session receives both summaries and proceeds with a full picture — without ever pulling all those files into the parent context.

## Example 2 — Implement → review loop

A sequential pattern for work where correctness matters enough to warrant an independent review pass.

1. Dispatch a `sonnet` subagent with a fully packed spec (see Example 3). It implements and returns `COMPLETE` or `COMPLETE_WITH_CAVEATS` with the changed file paths.
2. Dispatch an `opus` subagent (or review in main) with those file paths and the original spec. Ask it to audit for correctness, edge cases, and spec compliance.
3. If the reviewer returns findings or `COMPLETE_WITH_CAVEATS`, re-dispatch the implementer with the specific concerns listed — not a blanket "fix it."
4. If the implementer returns `STUCK`, diagnose: wrong model, underspecified task, or wrong plan. Change the approach; never retry unchanged.
5. When the reviewer comes back clean, integrate and move on.

## Example 3 — Context-packing prompt template

The prompt is the only input channel. Use this skeleton for any non-trivial delegation:

```
## Task
<One or two sentences describing exactly what to do and what done looks like.>

## Context
- Relevant files: <list absolute paths>
- Key facts: <anything the agent must know that isn't in the files — API contracts,
  constraints discovered earlier, related work already done>
- Do NOT read or modify: <paths that are off-limits>

## Constraints
- <Hard constraint, e.g. "Do not change the public API surface.">
- <Hard constraint, e.g. "All new functions must have unit tests.">

## Expected return format
End your final message with one of these status lines followed by the artifact:

  COMPLETE <changed file paths or short summary>
  COMPLETE_WITH_CAVEATS <changed file paths> — <list of concerns>
  MISSING_INPUT <what is missing>
  STUCK <root cause>
```

Fill in every section before dispatching. An underfilled prompt is the most common cause of stuck or misfired results.
