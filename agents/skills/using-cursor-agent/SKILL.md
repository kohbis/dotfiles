---
name: using-cursor-agent
description: Use when the user asks to hand implementation to Cursor (cursor-agent, Cursor CLI), for example because it is cheaper. Claude writes the spec and reviews; cursor-agent edits files in a dedicated git worktree; Claude verifies, commits, and opens the PR. Not for review-only passes — those go to reviewing-code or using-codex.
---

# Using Cursor Agent

Split the work by cost:

- **Claude**: read the code, decide the design, write the prompt, review the diff, re-run the checks, commit, push, open the PR.
- **cursor-agent**: the edits themselves, plus running the project's build, test, and lint until they pass.

## Before running

1. `cursor-agent status`. If it prints "Not logged in", ask the user to run `! cursor-agent login` (it needs the browser), then continue.
2. Create one worktree per PR (managing-git-worktrees layout: `<repo>.worktrees/<branch>`) from an up-to-date `origin/<main>`. `--force` lets cursor-agent run any command, so the worktree is its boundary — never point it at the main checkout or at a tree with the user's uncommitted work.
3. Read enough code to write the spec yourself. Settle design decisions and ask the user about policy questions before running cursor-agent. It cannot ask questions in `-p` mode.

## Command template

Write the prompt to a file in the scratchpad, then run cursor-agent in the background from the worktree:

```bash
cd {WORKTREE} && cursor-agent -p --force --output-format text \
  "$(cat {SCRATCHPAD}/cursor-{topic}.md)" \
  > {SCRATCHPAD}/cursor-{topic}.log 2>&1
```

- `-p` (`--print`) runs non-interactively and exits. The final report goes to stdout.
- `--force` lets it run commands such as the formatter, tests, and linter without approval.
- `--output-format text` keeps the log readable; pin it so the format doesn't depend on the CLI default.
- Add `--model {model}` only when the user asks for a specific model. Without it, cursor-agent uses the account default.

Run it with `run_in_background` and wait for the completion notification. Don't poll.

## Prompt format

See [prompt template](references/prompt-template.md). Always include:

- "Read AGENTS.md / CLAUDE.md first and follow its conventions."
- "Do NOT commit, push, or create branches; leave changes in the working tree."
- **Behavior**: the spec, including edge cases and what must not change.
- **Implementation constraints**: which module owns the logic, which interfaces stay fixed, and the doc files to touch (minimal).
- **Tests**: the cases to cover.
- **Verify before finishing**: the exact build, test, and lint commands, and "report results and changed files".
- Known environment quirks that would otherwise derail it (for example, a toolchain variable that points at the wrong version).

## After it finishes

1. Read the tail of the log, then `git status --short` and `git diff`, and read every untracked file `git status` lists (new tests usually land there).
2. Review the diff against the spec. Check the edge cases yourself and read the call sites the change depends on.
3. Re-run the full checks yourself, plus a quick manual check where the change is user-visible. Don't trust its "all passed".
4. Fix small issues directly. Send larger rework back to cursor-agent with a focused follow-up prompt.
5. Commit, push, and open the PR yourself (writing-pr-descriptions), following the repo's commit conventions. Never let cursor-agent do outward-facing steps.
6. Tell the user which parts cursor-agent wrote, what you verified, and any review notes you left unfixed.

## Troubleshooting

- **Toolchain version mismatch errors**: the shell may export a variable from another toolchain (`GOROOT`, `JAVA_HOME`, and so on). Unset it for the command (`env -u VAR ...`), and say so in the prompt.
- **Empty or tiny log**: run the same command in the foreground once to see the error. This is usually authentication.
- **Conflicts after a sibling PR merges**: rebase the worktree branch on `origin/<main>`, resolve the conflict, re-run the checks, and `git push --force-with-lease`. This is an exception to shipping-with-git's no-force-push rule, so confirm with the user before pushing.
