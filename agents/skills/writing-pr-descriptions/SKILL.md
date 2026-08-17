---
name: writing-pr-descriptions
description: "Drafts a pull request description from the current branch's git diff and the repository's PR template. Use whenever the user asks to write, draft, generate, or create a PR/pull request description — including natural requests like \"create a PR\", \"open a PR for this\", or \"write up this PR\" — even if they don't name this skill explicitly. Also trigger when invoked from another skill (e.g. shipping-with-git)."
---

# Writing PR Descriptions

Write a PR description that tells reviewers what they cannot learn from the diff alone.

Reviewers will read the diff — they can see every line added, removed, or moved. A PR description that restates the diff is noise. The description exists to carry the context that lives in the author's head but not in the code: the motivation, the rejected alternatives, the non-obvious risks, and the things the reviewer should pay extra attention to.

Everything you write should be about the change itself and its durable context — the concern of the PR. It is not a log of what you personally did while making the change. The fact that you ran the tests locally and they passed, which commands you typed, how long it took, what your machine printed — none of that is the reviewer's concern. It isn't verifiable, it doesn't survive past the moment you wrote it, and CI reports its own results anyway. Keep the description focused on what the change is and why, so it stays true and useful long after the branch is merged.

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
4. Judge how much the change actually needs (see *Scale the description to the change*), then draft to that shape following the template or the fallback structure below.
5. Before finalizing, run every sentence through three filters:
   - "Could a reviewer learn this from the diff in under 30 seconds?" If yes, cut it or rewrite it to explain why it matters.
   - "Is this about the change, or about what I did while making it?" If it describes your local process — tests you ran, commands you typed, results you saw — cut it.
   - "Did I already say this under another heading?" If yes, keep the instance that fits best and cut the other.
   Keep a sentence only if it carries durable context (motivation, decisions, risk, review guidance) or is needed to satisfy a template section.
   When the draft is too long, the fix is deleting sentences, not compressing them into denser ones.

## Scale the description to the change

Length should track how much undocumented thinking the change carries, not how big the diff is.
A 600-line mechanical rename can be one sentence.
A five-line change to retry logic can need a paragraph.
Sizing by diff volume is what produces descriptions that are long and still say nothing.

Pick the smallest shape that carries the context:

- **Self-evident change** (typo, version bump, mechanical rename, regenerated file) — one or two sentences, no headings at all.
  There is no hidden reasoning to transmit, so a section skeleton adds scrolling and nothing else.
- **Ordinary change** — a short paragraph of why, plus a reviewer note only when something is genuinely non-obvious.
  Two or three headings at most, and only the ones with real content.
- **Substantial or risky change** (migration, new external dependency, behavior change under load, security-relevant) — here the full fallback structure earns its place.
  This is the only tier where a long description is the right answer, and even here aim for something a reviewer absorbs in under a minute.

**Headings are a menu, not a checklist.** Drop any heading you would have to pad.
A section filled with hedged filler ("no significant risks expected", "the approach was straightforward") costs the reviewer more than its absence would.
If you cannot name a rejected alternative, there wasn't one — omit **Approach** rather than inventing a trade-off.

**A bigger diff usually means less to write, not more.** When many files change for one reason, state the reason once instead of walking the areas.
Resist the pull to give each directory, layer, or commit its own bullet: that just reproduces `git diff --stat` in prose.
If the change genuinely holds several independent concerns, name them in one line — and consider that it's a sign the PR wants splitting — rather than growing a section per concern.

**With a template, the headings are fixed but the volume isn't.** One or two sentences under a heading is a complete answer, and `N/A` is a complete answer.
Don't grow a section to match the size of its neighbors, and don't restate one motivation under three headings.

**Example — a dependency bump, over-inflated:**
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

## What does NOT belong

**Hard rule: never restate what the code already shows.** This is the single most-violated rule, and the pressure to break it is strongest inside any template section whose heading names "changes," "summary," or "what was done." Such a heading feels like it demands a list of edits — resist that. It is really asking "what did this change accomplish, and what should I look at": answer with outcomes and review intent, never a file-by-file or function-by-function inventory. If every sentence you wrote under such a heading could be reconstructed by reading the diff, you have written noise; delete it and write the *why* instead, or leave `TODO`.

**Things the diff already shows.** Writing them adds length without adding understanding.

- Lists of files changed or added
- "Added function X", "Updated class Y", "Renamed Z to W"
- Restating what the code does line by line
- Describing type signatures, imports, or structural changes
- "Refactored X to use Y" when the diff makes it obvious

**Things that aren't the PR's concern.** These are transient facts about your local session, not durable context about the change. The reviewer can't verify them and they add nothing to understanding the code.

- Local test results — "ran the test suite locally, all pass", "tests green on my machine"
- Commands you typed while working, or a play-by-play of your process
- Time spent, dead ends explored, or how the change was arrived at mechanically
- CI/build status — CI reports this itself; don't restate it

Even when a template has a "Testing" or "Verification" section, don't fill it with local pass/fail claims. Instead describe what a reviewer should verify or how to reproduce the scenario, or write `TODO` — never fabricate results.

**Example — bad:**
> - Added a `validateInput` function to the utils module
> - Updated the request handler to call `validateInput` before processing
> - Added tests for `validateInput`
> - Ran the test suite locally, all tests pass ✅

**Example — good:**
> Input validation was missing from the handler, allowing malformed payloads to reach the database layer. Validation is done at the handler boundary rather than the DB layer because we want to return user-friendly 400 errors, not 500s.

## Fallback structure (when no template exists)

Use only the headings that have something to say — this is the full set, not a required set.
**Why** is the one that almost always earns its place; the others appear when the change actually raises them.

- **Why** — Problem and motivation
- **Approach** — Key decisions and trade-offs
- **Reviewer guidance** — Where to focus, non-obvious things
- **Risks** — What could break, rollback plan

For a self-evident change, skip the headings entirely and write the one or two sentences that explain it.

## Output rules

- Markdown only.
- Concise — every sentence earns its place, and the body is no longer than the change warrants.
- One sentence per line — never pack multiple sentences onto a single line. Break after each sentence's end (`.` / `。`) with a newline. This keeps the markdown diff-friendly: a later edit to one sentence touches one line, so reviewers see exactly what changed. (Markdown still renders consecutive lines as one paragraph, so this doesn't affect the rendered layout — leave a blank line only where you intend a real paragraph break.)
- Do not invent facts, issue links, or test results; mark unknowns as `TODO`.
- Use authorial context and active phrasing; avoid detached narration like "This PR adds…".
