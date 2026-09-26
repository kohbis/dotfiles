---
name: writing-pr-descriptions
description: "Drafts a pull request description from the current branch's git diff and the repository's PR template. Use whenever the user asks to write, draft, generate, or create a PR/pull request description — including natural requests like \"create a PR\", \"open a PR for this\", or \"write up this PR\" — even if they don't name this skill explicitly. Also trigger when invoked from another skill (e.g. shipping-with-git)."
---

# Writing PR Descriptions

Write only what a reviewer cannot get from the diff.

The reviewer will read the diff, so restating it is noise. The description carries what lives in the author's head and nowhere in the code: why the change exists, which alternative was rejected, what breaks if it's wrong, which part is substantive when most of the diff is mechanical. Nothing else earns space — not a tour of the files, not what you did while making the change.

Unless the user asks for more, the description is one or two sentences saying why the change exists — for every PR, whatever its size. Brevity is the default, not a finishing touch.

## Workflow

1. Detect current branch and target branch (default: `main`).
2. Collect change context:
   - `git diff --name-status {target}...HEAD`
   - `git diff --stat {target}...HEAD`
   - `git log --oneline {target}...HEAD`
   - Read key changed files to understand intent (not to summarize them)
   - Use commit messages, issue refs, branch names, and user-provided context for motivation and decisions. When context is unavailable, write `TODO` rather than inferring
3. Find the PR template, in order: `.github/pull_request_template.md`, `.github/PULL_REQUEST_TEMPLATE.md`, `.github/PULL_REQUEST_TEMPLATE/*.md` (pick the most relevant). Whether one exists decides the structure — see *Structure*.
4. Draft the default form — one or two sentences — unless the user asked for more (see *How much to write*).
5. **Cut pass — do this on the draft before showing anything.** Take each sentence and delete it if any of these is true:
   - a reviewer could learn it from the diff in under 30 seconds
   - it describes your session rather than the change (tests you ran, commands, results, time spent)
   - you already said it elsewhere in the description
   - you wrote it to fill a slot (a template heading, a "risks" point), not because you had something to say
   Deleting is the only fix — never rewrite a cut sentence into a denser one.
6. Report the outcome in one line in chat, not in the description: default or longer form (and why, if longer), and what the cut pass removed. If it removed nothing, say so — that usually means the cut pass didn't really happen.

## How much to write

**Default: one or two sentences, ~30 words, whatever the size of the change.** Say why the change exists; the diff, the commit messages, and the reviewer's own questions cover the rest. When most of the diff is mechanical, the second sentence can say where the real change is — e.g. "The real change is in `retry.go`; the rest is regenerated code." When the change holds several independent concerns, name them in that one line rather than expanding — the PR probably wants splitting.

**Longer form, only when the user asks** — "詳しく", "more detail", "explain the approach", naming points or sections to cover. Then length tracks how much undocumented thinking the change carries, never diff volume; the word counts are ceilings, not quotas:

- **Ordinary** — one paragraph of why, under ~120 words.
- **Substantial or risky** (migration, new external dependency, behavior change under load, security-relevant) — two or three short paragraphs covering the points below that apply, under ~250 words.

Even then, a bigger diff usually means less to write, not more: state a shared reason once instead of walking directories, layers, or commits.

## Structure

**Without a template**, write plain paragraphs — no `##` headings, no bold pseudo-headings (`**Why:**`), no section-per-topic bullets — in both forms.
Use sections only when the user explicitly asks for a structure; then follow exactly the structure given.

**With a template**, its structure wins over anything else here.
Keep every heading and checklist unless clearly marked optional, strip instructional comments (`<!-- describe your changes -->`), and answer a section you have nothing for with `N/A`.
The headings are fixed but the volume isn't: one sentence under a heading is a complete answer, so don't grow a section to match its neighbors or restate one motivation under three headings.

In the default form, say only the why.
In the longer form, the points below are a menu for what to say, in this order, whether as prose or under a template's headings.
Include one only when its condition holds:

| Point | Include it when |
| --- | --- |
| why | almost always — the problem or trigger isn't in the diff |
| approach | you can name the alternative you rejected. If you can't, there wasn't one |
| risks | you can name a concrete failure mode and its rollback, not "low risk overall" |

Hedged filler ("no significant risks expected", "the approach was straightforward") costs the reviewer more than its absence would.

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

This is the most-violated rule, and the pressure peaks under any template heading named "changes", "summary", or "what was done". Such a heading reads like a demand for an inventory of edits; it is really asking *what did this accomplish*. Answer with outcomes. If a sentence you wrote there could be reconstructed from the diff, it is noise — delete it and write the why instead.

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

## Ticket ID prefix (PR title)

When the user supplies a ticket ID in `XXX-123` format (letters, hyphen, digits — e.g. Jira-style), prefix the PR title with `[XXX-123]`, e.g. `[XXX-123] Fix null pointer in session handler`.
With no ticket ID, skip the prefix rather than inventing one.

## Output rules

- Markdown only.
- One sentence per line — break after each `.` / `。`. A later edit then touches one line, so the markdown diff shows exactly what changed. (Consecutive lines still render as one paragraph; leave a blank line only for a real paragraph break.)
- Don't invent facts, issue links, or test results; mark unknowns as `TODO`.
- Write with authorial voice and active phrasing; avoid detached narration like "This PR adds…".
