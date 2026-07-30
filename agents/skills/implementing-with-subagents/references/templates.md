# Templates

Fill these in and paste them into the subagent prompt. Everything the agent needs must be in the prompt — it has no view of this session.

## Implementer dispatch

```
## Task
<the full task text, pasted — not a link to the plan>

## What you can rely on
- Files in play: <paths>
- Already in place: <prior tasks' results, interfaces, constraints from the plan>
- Off-limits: <paths or areas not to touch>

## If something you need is missing
Stop and return MISSING_INPUT naming exactly what you need. You can't ask once
you're running, so don't fill gaps with guesses.

## Do
1. Implement exactly the task — no more.
2. Add tests per the writing-tests skill.
3. Run them; make them pass.
4. Commit a checkpoint.
5. Before reporting, confirm your diff covers every requirement in the task and
   nothing beyond it. One pass — fix what it surfaces, then report.

## Stay in scope
Follow the plan's file layout and the surrounding code's patterns. If a file
starts outgrowing the plan's intent, stop and report COMPLETE_WITH_CAVEATS
rather than restructuring on your own — that's the controller's call.

## End your report with one of
- COMPLETE — what you built, what you tested, files changed
- COMPLETE_WITH_CAVEATS — the above, plus the risk or deviation you want weighed
- MISSING_INPUT — exactly what's missing and why you can't proceed
- STUCK — what stopped you, what you tried, what you'd suggest
```

## Verification passes

Run these against the task's `BASE..HEAD`, requirements first.

**Requirements.** Paste the task and the implementer's report, then have the reviewer compare the actual code to what was asked — line by line, trusting the code over the report. It should call out anything missing, anything extra that wasn't requested, and anywhere the task was misread. Pass only on a genuine match, not "close enough."

**Craftsmanship.** Only after requirements pass. Have the reviewer apply the `reviewing-code` lenses over the same range, and additionally check that each file holds one clear responsibility, that units can be tested in isolation, that the change follows the plan's layout, and that this change didn't bloat a file (judge only what the change added, not pre-existing size).
