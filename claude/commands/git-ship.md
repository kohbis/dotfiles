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
   - After confirmation, run `git switch -c <branch-name>`.

3. **Stage changes**
   - Run `git add .` to stage all changes.
   - Show a summary of staged files via `git diff --cached --stat`.
   - If sensitive-looking files (e.g. `.env`, secrets) are staged, ask for confirmation before continuing.

4. **Commit**
   - Analyze `git diff --cached` to infer the commitizen type (`feat` / `fix` / `chore` / `refactor` / `docs` / `test` / `ci` / `perf` / `style`), scope, and subject.
   - Show the proposed commit message to the user and accept confirmation or corrections.
   - After confirmation, run:
     ```
     npx git-cz --non-interactive --type <type> --scope <scope> --subject <subject>
     ```

5. **Generate PR description**
   - Run `/write-pr-description` to draft the PR body.

6. **Open PR**
   - Use the generated PR body to run:
     ```
     gh pr create --title "<type>(<scope>): <subject>" --body "<pr-body>" -w
     ```

## Rules

- Never skip confirmation when sensitive-looking files are staged.
- Do not force-push or amend published commits.
- If any step fails, stop immediately and report the error clearly.
