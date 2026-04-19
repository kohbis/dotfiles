---
name: git-ship
description: "Auto-ship with branch creation, push, and PR fully automated. Stage and commit require user confirmation. Blocks on default branch."
disable-model-invocation: true
---

# Git Ship

Run the full git workflow: branch creation → stage & commit (with confirmation) → push → PR.

Branch creation, push, and PR creation are fully automatic.
Stage and commit require explicit user confirmation.

## Workflow

1. **Check working tree**
   - Run `git status` to confirm there are changes to ship.
   - If the tree is clean, stop and notify the user.

2. **Create branch** *(automatic)*
   - Analyze `git status` and `git diff` to infer the type (`feat` / `fix` / `chore` / `refactor` / `docs` / `test` / `ci` / `perf` / `style`) and a short kebab-case description of the changes.
   - Determine branch name in the format `<type>/<short-description>` (e.g. `feat/add-git-ship-command`).
   - Check whether the branch already exists.
   - If it does not exist, run `git switch -c <branch-name>` and report the created branch name.
   - If it already exists, stop and ask the user whether to switch to it or choose a different name.

3. **Stage & Commit** *(requires confirmation)*
   - Show the list of changed files with `git status --short`.
   - Show the diff with `git diff`.
   - Ask the user to confirm which files to stage and whether the changes are correct.
   - After confirmation, stage the selected files.
   - Show a summary of staged files via `git diff --cached --stat`.
   - If sensitive-looking files (e.g. `.env`, secrets) are staged, ask for confirmation before continuing.
   - Analyze `git diff --cached` to infer the commitizen type (`feat` / `fix` / `chore` / `refactor` / `docs` / `test` / `ci` / `perf` / `style`), scope, and subject.
   - Show the proposed commit message and ask the user to confirm or correct it.
   - Before running the commit command, verify that `npx` and `git-cz` are available in the current environment.
   - If the required tooling is unavailable, stop and report the missing prerequisite clearly.
   - After confirmation, run:
     ```
     npx git-cz --non-interactive --type <type> [--scope <scope>] --subject <subject>
     ```
   - Omit `--scope` when no meaningful scope applies.
   - Do NOT include an emoji in `<subject>` — `git-cz` automatically prepends the type emoji, so including one would duplicate it.

4. **Push** *(automatic)*
   - If the current branch is `main` or `master`, stop immediately and report to the user. Do not push.
   - Run `git push -u origin <branch-name>` and report the result.

5. **Generate PR description**
   - Run `/write-pr-description` to draft the PR body.

6. **Open PR** *(automatic)*
   - Build the PR title as `<type>: <subject>` when there is no scope, or `<type>(<scope>): <subject>` when scope is present.
   - Run:
     ```
     gh pr create --title "<pr-title>" --body "<pr-body>" -w
     ```
   - If the environment cannot open a browser, rerun without `-w` and show the created PR URL.

## Rules

- Always block when the current branch is `main` or `master`. Never push to the default branch.
- Never skip confirmation when sensitive-looking files are staged.
- Do not force-push or amend published commits.
- If any step fails, stop immediately and report the error clearly.
