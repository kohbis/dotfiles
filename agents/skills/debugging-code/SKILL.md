---
name: debugging-code
description: "Structured debugging workflow — reproduce, narrow, root-cause, fix, verify. Use when the user reports a bug, error, unexpected behavior, test failure, or asks to investigate/diagnose/troubleshoot an issue. Also use when the user pastes an error message or stack trace, says something 'doesn't work' or 'stopped working', asks 'why does this return X instead of Y', or describes any symptom without a known cause — even if they don't explicitly say 'debug'. Trigger when user says \"debugging code\", \"/debugging-code\", \"debug this\", \"why is this broken\", \"investigate\", \"troubleshoot\", or describes unexpected behavior."
---

# Debugging Code

Systematic approach to finding and fixing bugs. The goal is to shrink the search space fast — random guess-and-check wastes time because it doesn't eliminate possibilities.

## 1. Reproduce — confirm you can see the failure

- Obtain the exact error message, stack trace, or unexpected output from the user.
- Run the failing command, test, or request locally to reproduce the issue.
- If reproduction fails, say so explicitly — debugging without reproduction is speculation, and any fix you propose is a guess.
- State the **expected** vs. **actual** behavior in one sentence each so the gap is clear.

## 2. Narrow — shrink the search space

Pick the technique that fits the situation; don't run all of them mechanically.

- **Check recent changes** via `git log --oneline -20` or `git diff HEAD~5`. Most bugs come from recent commits, so start here because it's cheap and often decisive.
- **Run `git bisect`** when the user says "it worked before" but the breaking commit is unknown. Automate with a test script (`git bisect run <test-cmd>`) to avoid manual stepping.
- **Read the stack trace bottom-up** — the lowest frame is closest to the actual failure site. Grep for the error string to jump straight to the throw site.
- **Add targeted log output** at the boundary between "works" and "broken." Scatter-shot logging creates noise; placing a single print between two suspected layers tells you which side is wrong.
- **Binary-search through code** by commenting out halves of a suspicious section. This converges in O(log n) steps, much faster than reading every line.
- **Minimize the input** to the smallest case that still reproduces. A smaller reproduction makes every subsequent step faster and reveals which part of the input matters.

## 3. Root-cause — explain WHY, not just WHERE

- Trace from the symptom location to the underlying cause. The crash site is often just where the damage surfaces; the real mistake lives one layer above or below.
- Classify the bug: logic error, wrong assumption about input shape, race condition, stale state, or environment mismatch. Naming the category guides the fix.
- Read surrounding code and callers before concluding — context often reveals the actual invariant that was violated.
- If the root cause remains unclear after narrowing, state the best hypothesis and what specific evidence would confirm or refute it.

## 4. Fix — change the minimum necessary

- Fix the root cause, not the symptom. A symptom-level patch masks the real problem and invites recurrence.
- Keep the diff small — no drive-by refactors alongside a bug fix. Mixing concerns makes the fix harder to review and revert.
- Add a comment only if the fix touches a tricky invariant that would surprise a future reader.

## 5. Verify — prove the fix works

- Run the original reproduction case and confirm it now passes.
- Run the broader test suite to check for regressions the fix might introduce.
- If no automated test covers this bug, write one before reporting done — an unguarded fix can silently break again.

## Escalation

- If narrowing stalls after 3 rounds of hypothesis → evidence, pause and summarize what you know and what you don't. Ask the user for additional context rather than grinding — they often have domain knowledge that dramatically narrows the search space.
- For cross-service or infrastructure issues, suggest targeted tools: network traces, database query logs, container logs, metrics dashboards.

## Hard Rule

Never propose a fix without first reproducing the bug or explicitly stating that reproduction was not possible and why.
