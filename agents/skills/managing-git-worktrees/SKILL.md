---
name: managing-git-worktrees
description: "Manages git worktrees — creating, listing, removing, and navigating them with a consistent sibling-directory layout. Use whenever the user mentions worktrees, parallel branch checkouts, working on multiple branches at once, or git worktree commands, even if they don't say 'worktree' explicitly."
---

# Managing Git Worktrees

Help the user create, list, remove, and navigate git worktrees so they can check out several branches at once without stashing or re-cloning.

Worktrees let one repository have multiple working directories, each on its own branch. The hard part is keeping them organized and cleaning them up without losing uncommitted work — this skill standardizes both.

## Layout convention

Place every worktree in a sibling directory next to the repository, so the repo itself stays uncluttered:

```
<repo>.worktrees/<branch>
```

For a repo at `/Users/me/work/myrepo` on branch `feat/login`, the worktree goes to `/Users/me/work/myrepo.worktrees/feat/login`.

Resolve paths from the repository root, not the current directory, so the layout is stable regardless of where the user is standing:

```bash
ROOT=$(git rev-parse --show-toplevel)
WORKTREES_DIR="${ROOT}.worktrees"
```

Branch names with slashes (`feat/login`) become nested directories under `<repo>.worktrees/` — that's fine, git handles it. Keep the branch name and the directory leaf identical so the mapping stays obvious.

## Create a worktree

1. Determine the target branch name and resolve the worktree path from the layout convention above.
2. Check whether the branch already exists with `git branch --list <branch>` (and `git branch -r --list` for remotes).
3. Create the worktree:
   - Existing local branch: `git worktree add "<repo>.worktrees/<branch>" <branch>`
   - New branch: `git worktree add -b <branch> "<repo>.worktrees/<branch>"`
   - Tracking a remote branch: `git worktree add -b <branch> "<repo>.worktrees/<branch>" origin/<branch>`
4. If the target directory already exists, stop and ask the user how to proceed — don't overwrite it.
5. Report the absolute path of the created worktree so the user can `cd` into it.

## List & inspect

Show all worktrees, their branches, and HEAD state — this is read-only and always safe:

```bash
git worktree list
```

Use `git worktree list --porcelain` when you need to parse paths and branches programmatically.

## Remove & clean up

1. Resolve the target worktree path and inspect its state:
   ```bash
   git -C "<path>" status --short
   ```
2. **If the worktree is clean** (no uncommitted changes and nothing unpushed), remove it without asking, then prune stale metadata:
   ```bash
   git worktree remove "<path>"
   git worktree prune
   ```
3. **If there are uncommitted or unpushed changes**, stop and warn the user with what would be lost. Do not remove it and do not add `--force` on your own — let the user decide.
4. Removing a worktree does not delete its branch. If the branch is now merged and the user wants it gone, mention `git branch -d <branch>` as a separate, explicit step.

## Navigate / switch

To move between worktrees, point the user at the target path (`git worktree list` shows them all) and remind them which branch lives where. Each worktree is just a directory — switching is a `cd`, not a `git switch`, which is the whole point of worktrees.

## Hard Rule

- A clean worktree may be removed without confirmation, but a worktree with uncommitted or unpushed changes must never be removed without explicit user confirmation — and never silently `--force`.
- Never remove or operate on the main working directory (the primary repository checkout) as if it were a disposable worktree.
- If any command fails, stop immediately and report the error clearly rather than guessing a workaround.
