---
name: writing-pr-descriptions
description: "Drafts a pull request description from git diff and repository PR template. Trigger only when user explicitly says \"writing pr descriptions\" or \"/writing-pr-descriptions\", or when invoked from another skill (e.g. shipping-with-git)."
disable-model-invocation: true
---

# Writing PR Descriptions

Write a PR description that tells reviewers what they cannot learn from the diff alone.

Reviewers will read the diff — they can see every line added, removed, or moved. A PR description that restates the diff is noise. The description exists to carry the context that lives in the author's head but not in the code: the motivation, the rejected alternatives, the non-obvious risks, and the things the reviewer should pay extra attention to.

## Workflow

1. Detect current branch and target branch (default: `main`).
2. Collect change context:
   - `git diff --name-status {target}...HEAD`
   - `git diff --stat {target}...HEAD`
   - `git log --oneline {target}...HEAD`
   - Read key changed files to understand intent (not to summarize them)
   - Use commit messages, issue refs, branch names, and user-provided context to fill in motivation and decisions. When context is unavailable, write `TODO` rather than inferring
3. Find PR template in this order:
   - `.github/pull_request_template.md`
   - `.github/PULL_REQUEST_TEMPLATE.md`
   - `.github/PULL_REQUEST_TEMPLATE/*.md` (pick the most relevant one)
4. Draft the PR body following the template (or fallback structure below).
5. Before finalizing, review every sentence against the filter: "Could a reviewer learn this from the diff in under 30 seconds?" If yes, cut it or rewrite it to explain why it matters — unless the sentence is needed to satisfy a template section or to anchor risk, test scope, or review guidance.

## Ticket ID prefix (PR title & branch name)

When the user supplies a ticket ID in `XXX-123` format (letters, hyphen, digits — e.g. Jira-style), it identifies the change for tracking, so both the PR title and the branch name must carry it:

- **PR title** — prefix with `[XXX-123]`, e.g. `[XXX-123] Fix null pointer in session handler`.
- **Branch name** — prefix with the ID lowercased and the hyphen removed, plus a trailing hyphen, e.g. `xxx123-fix-session-null-pointer`.

If the user gives no ticket ID, skip both prefixes rather than inventing one.

## What belongs in a PR description

When a PR template exists, follow its structure. Preserve all headings and checklists unless clearly optional. Remove instructional comments (e.g. `<!-- describe your changes -->`). Use `N/A` or `TODO` for required sections that lack evidence. Fill each section with the kind of content listed below, adapted to what the template asks for. If a template section asks for "changes" or "summary," describe outcomes and review intent rather than listing file-by-file edits.

When no template exists, weave these elements into the fallback structure:

- **Why** this change exists — the problem, the trigger, the user/business need
- **Why this approach** over alternatives — rejected options, trade-offs accepted
- **What's not obvious from the diff** — subtle interactions, ordering dependencies, migration concerns, performance implications
- **Where to look first** — guide the reviewer's attention to the parts that matter most
- **Risks and rollback** — what could go wrong, how to revert safely
- **Testing done** — commands actually run and their results. If no test evidence is available, write `TODO` rather than guessing

## What does NOT belong

These are things the diff already shows. Writing them adds length without adding understanding.

- Lists of files changed or added
- "Added function X", "Updated class Y", "Renamed Z to W"
- Restating what the code does line by line
- Describing type signatures, imports, or structural changes
- "Refactored X to use Y" when the diff makes it obvious

**Example — bad:**
> - Added `validateInput()` function to `utils.ts`
> - Updated `handler.ts` to call `validateInput()` before processing
> - Added tests for `validateInput()` in `utils.test.ts`

**Example — good:**
> Input validation was missing from the handler, allowing malformed payloads to reach the database layer. Validation is done at the handler boundary rather than the DB layer because we want to return user-friendly 400 errors, not 500s.

## Fallback structure (when no template exists)

- **Why** — Problem and motivation
- **Approach** — Key decisions and trade-offs
- **Reviewer guidance** — Where to focus, non-obvious things
- **Testing** — What was tested and how
- **Risks** — What could break, rollback plan

## Output rules

- Markdown only.
- Concise — every sentence should earn its place.
- Do not invent facts, issue links, or test results; mark unknowns as `TODO`.
- Use authorial context and active phrasing; avoid detached narration like "This PR adds…".
