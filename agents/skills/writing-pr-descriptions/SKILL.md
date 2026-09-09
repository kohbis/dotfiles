---
name: writing-pr-descriptions
description: "Drafts a pull request description from the current branch's git diff and the repository's PR template. Use whenever the user asks to write, draft, generate, or create a PR/pull request description — including natural requests like \"create a PR\", \"open a PR for this\", or \"write up this PR\" — even if they don't name this skill explicitly. Also trigger when invoked from another skill (e.g. shipping-with-git)."
---

# Writing PR Descriptions

Write only what a reviewer cannot get from the diff.

The reviewer will read the diff, so restating it is noise. The description carries what lives in the author's head and nowhere in the code: why the change exists, which alternative was rejected, what breaks if it's wrong, where to look first. Nothing else earns space — not a tour of the files, not what you did while making the change.

The default failure is a description that is longer than the change deserves, so treat brevity as the job rather than a finishing touch.

## Workflow

1. Detect current branch and target branch (default: `main`).
2. Collect change context:
   - `git diff --name-status {target}...HEAD`
   - `git diff --stat {target}...HEAD`
   - `git log --oneline {target}...HEAD`
   - Read key changed files to understand intent (not to summarize them)
   - Use commit messages, issue refs, branch names, and user-provided context for motivation and decisions. When context is unavailable, write `TODO` rather than inferring
3. Find the PR template, in order: `.github/pull_request_template.md`, `.github/PULL_REQUEST_TEMPLATE.md`, `.github/PULL_REQUEST_TEMPLATE/*.md` (pick the most relevant). **When one exists, its structure wins over anything below.** Keep every heading and checklist unless clearly marked optional, strip instructional comments (`<!-- describe your changes -->`), and answer a section you have nothing for with `N/A` — the tiers and heading conditions below then govern only how much you write under each heading, never which headings exist.
4. Pick a size tier (below) and draft to it.
5. **Cut pass — do this on the draft before showing anything.** Take each sentence and delete it if any of these is true:
   - a reviewer could learn it from the diff in under 30 seconds
   - it describes your session rather than the change (tests you ran, commands, results, time spent)
   - you already said it under another heading
   - you wrote it because a heading was empty, not because you had something to say
   Then drop any heading left with nothing under it — except a template's headings, which stay and take `N/A`. Deleting is the only fix — never rewrite a cut sentence into a denser one.
6. Report the outcome in one line in chat, not in the description: which tier you chose and which headings you dropped. If you dropped none, say so — that usually means the cut pass didn't really happen.

## How much to write

Length tracks how much undocumented thinking the change carries, never diff volume. A 600-line mechanical rename is one sentence; a five-line change to retry logic can need a paragraph. The word counts below are targets to aim under, not quotas to fill.

- **Self-evident** (typo, version bump, mechanical rename, regenerated file, config value) — one or two sentences, no headings, ~30 words. There is no hidden reasoning to transmit, so a section skeleton adds scrolling and nothing else.
- **Ordinary** — a paragraph of why, plus at most one reviewer note. Under ~120 words. Most PRs land here.
- **Substantial or risky** (migration, new external dependency, behavior change under load, security-relevant) — the full structure earns its place. Still under ~250 words: a reviewer should absorb it in under a minute.

**A bigger diff usually means less to write, not more.** When many files change for one reason, state the reason once instead of walking the areas — a bullet per directory, layer, or commit just reproduces `git diff --stat` in prose. If the change really holds several independent concerns, name them in one line and consider that the PR wants splitting.

## Earn each heading

This applies when no template exists. With a template, its headings are already settled — skip to the paragraph below the table.

Headings are a menu. Include one only when its condition holds:

| Heading | Include it when |
| --- | --- |
| **Why** | almost always — the problem or trigger isn't in the diff |
| **Approach** | you can name the alternative you rejected. If you can't, there wasn't one |
| **Reviewer guidance** | you can point at something specific a careful diff read would still miss |
| **Risks** | you can name a concrete failure mode, not "low risk overall" |

Hedged filler ("no significant risks expected", "the approach was straightforward") costs the reviewer more than the heading's absence would.

**With a template the headings are fixed but the volume isn't.** One sentence under a heading is a complete answer, and so is `N/A`. Don't grow a section to match its neighbors, don't restate one motivation under three headings, and use `TODO` where you lack evidence rather than filling the space.

**Example — dependency bump, over-inflated:**
> ## Why
> Keeping dependencies up to date is important for security and long-term maintainability of the project.
> ## Approach
> Bumped the version in the lockfile, which was the simplest and most direct approach available.
> ## Reviewer guidance
> Please review the lockfile diff and confirm the version is correct.
> ## Risks
> Low risk overall. Rollback is straightforward by reverting the commit.

**Example — same change, right-sized:**
> Bumps `lodash` to 4.17.21 for the prototype-pollution fix (CVE-2020-8203).
> No call sites needed changes.

## Never restate the diff

This is the most-violated rule, and the pressure peaks under any template heading named "changes", "summary", or "what was done". Such a heading reads like a demand for an inventory of edits; it is really asking *what did this accomplish, and what should I look at*. Answer with outcomes and review intent. If a sentence you wrote there could be reconstructed from the diff, it is noise — delete it and write the why, or leave `TODO`.

Never write:

- lists of files changed or added
- "Added function X", "Updated class Y", "Renamed Z to W"
- what the code does, line by line
- type signatures, imports, or structural changes
- "Refactored X to use Y" when the diff makes it obvious

**Example — bad:**
> - Added a `validateInput` function to the utils module
> - Updated the request handler to call `validateInput` before processing
> - Added tests for `validateInput`
> - Ran the test suite locally, all tests pass ✅

**Example — good:**
> Input validation was missing from the handler, allowing malformed payloads to reach the database layer.
> Validation lives at the handler boundary rather than the DB layer so we return user-friendly 400s instead of 500s.

## Never report your local session

These are transient facts about your machine, not durable context about the change. The reviewer can't verify them, CI reports its own results, and they read as false a week later.

- local test results — "ran the test suite locally, all pass", "tests green on my machine"
- commands you typed, or a play-by-play of your process
- time spent, dead ends explored, how the change was mechanically arrived at
- CI/build status

A "Testing" or "Verification" section is not an exception. Describe what a reviewer should verify or how to reproduce the scenario, or write `TODO` — never fabricate results.

## Ticket ID prefix (PR title & branch name)

When the user supplies a ticket ID in `XXX-123` format (letters, hyphen, digits — e.g. Jira-style), it identifies the change for tracking, so both the title and the branch carry it:

- **PR title** — prefix `[XXX-123]`, e.g. `[XXX-123] Fix null pointer in session handler`.
- **Branch name** — the ID lowercased with the hyphen removed, plus a trailing hyphen, e.g. `xxx123-fix-session-null-pointer`.

With no ticket ID, skip both prefixes rather than inventing one.

## Fallback structure (no template)

Use only the headings that pass *Earn each heading* — this is the full set, not a required set.

- **Why** — problem and motivation
- **Approach** — key decisions and trade-offs
- **Reviewer guidance** — where to focus, non-obvious things
- **Risks** — what could break, rollback plan

For a self-evident change, skip headings entirely and write the one or two sentences that explain it.

## Output rules

- Markdown only.
- No longer than the change warrants — see the tier targets above.
- One sentence per line — break after each `.` / `。`. A later edit then touches one line, so the markdown diff shows exactly what changed. (Consecutive lines still render as one paragraph; leave a blank line only for a real paragraph break.)
- Don't invent facts, issue links, or test results; mark unknowns as `TODO`.
- Write with authorial voice and active phrasing; avoid detached narration like "This PR adds…".
