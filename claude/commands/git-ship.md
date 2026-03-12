---
description: "Full git ship workflow: create branch, commit, and open a PR."
---

# Git Ship

Run the full git workflow: branch creation → commit → PR.

## Workflow

1. **Check working tree**
   - Run `git status` to confirm there are changes to ship.
   - If the tree is clean, stop and notify the user.

2. **Create branch**
   - Analyze `git status` and `git diff` to infer the type (`feat` / `fix` / `chore` / `refactor` / `docs` / `test` / `ci` / `perf` / `style`) and a short kebab-case description of the changes.
   - Propose a branch name in the format `<type>/<short-description>` (e.g. `feat/add-git-ship-command`).
   - Show the proposed branch name to the user and accept confirmation or corrections.
   - After confirmation, check whether the branch already exists.
   - If it does not exist, run `git switch -c <branch-name>`.
   - If it already exists, stop and ask the user whether to switch to it or choose a different name.

3. **Stage changes**
   - Show the unstaged file list with `git status --short`.
   - Ask the user to confirm the files to include before staging.
   - Stage only the confirmed files instead of using `git add .`.
   - Show a summary of staged files via `git diff --cached --stat`.
   - If sensitive-looking files (e.g. `.env`, secrets) are staged, ask for confirmation before continuing.

4. **Commit**
   - Analyze `git diff --cached` to infer the commitizen type (`feat` / `fix` / `chore` / `refactor` / `docs` / `test` / `ci` / `perf` / `style`), scope, and subject.
   - Show the proposed commit message to the user and accept confirmation or corrections.
   - Before running the commit command, verify that `npx` and `git-cz` are available in the current environment.
   - If the required tooling is unavailable, stop and report the missing prerequisite clearly.
   - After confirmation, run:
     ```
     npx git-cz --non-interactive --type <type> [--scope <scope>] --subject <subject>
     ```
   - Omit `--scope` when no meaningful scope applies.

5. **Generate PR description**
   - Run `/write-pr-description` to draft the PR body.

6. **Open PR**
   - Build the PR title as `<type>: <subject>` when there is no scope, or `<type>(<scope>): <subject>` when scope is present.
   - Use the generated PR body to run:
     ```
     gh pr create --title "<pr-title>" --body "<pr-body>" -w
     ```
   - If the environment cannot open a browser, rerun without `-w` and show the created PR URL.

## Rules

- Never skip confirmation when sensitive-looking files are staged.
- Never bulk-stage all changes without explicit user confirmation.
- Do not force-push or amend published commits.
- If any step fails, stop immediately and report the error clearly.
