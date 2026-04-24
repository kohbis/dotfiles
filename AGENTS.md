# AGENTS.md

## Project Overview

Personal dotfiles repository. Shell configs, editor configs, and AI-agent skills are managed as file-level symbolic links driven by a `Makefile`. Skills are the source of truth under `agents/skills/` and are fanned out to multiple AI CLIs (Claude Code, Codex) through a shared `~/.agents/skills/` hub.

## Architecture

```
dotfiles/
├── agents/skills/      # AI skills — source of truth
├── claude/             # Claude-specific config (agents/, etc.)
├── config/             # linked into ~/.config/<tool>/
├── dotfiles-private/   # optional, gitignored, auto-detected
└── <dotfile>           # linked as ~/.<dotfile>
```

Skill symlink chain (important when editing — never edit through a symlink target):

```
dotfiles/agents/skills/<skill>       # edit here
        ↑
~/.agents/skills/<skill>             # shared hub
        ↑                    ↑
~/.claude/skills/<skill>  ~/.codex/skills/<skill>
```

`dotfiles-private/agents/skills/` is linked into `~/.agents/skills/` the same way when present.

## Key Commands

```
Link:    make link          # create all symlinks
Unlink:  make unlink        # remove all symlinks
Relink:  make relink        # unlink && link
List:    make list          # show [v] linked / [-] unlinked status
Help:    make help
```

Filter any target to a subset of files with `F=<substring>`:

```
make link F=vim      # only vimrc / nvim config
make unlink F=otel   # only otel-related skills
make list F=skills   # all skills
```

Sub-targets exist for each domain and can be run individually: `link-dotfiles`, `link-config`, `link-agents`, `link-claude`, `link-codex` (and their `unlink-*` counterparts). `link-claude` and `link-codex` depend on `link-agents`.

## Coding Conventions

### Model naming policy for skills

When a skill references a model name explicitly, follow the convention for the target tool. Mismatched names cause the tool to reject or silently mis-route the request.

| Tool / CLI         | Naming policy                           | Examples                                       |
| ------------------ | --------------------------------------- | ---------------------------------------------- |
| Codex CLI          | Explicit model IDs                      | `gpt-5.4`, `gpt-5.5`, `gpt-5.4-mini`           |
| GitHub Copilot CLI | Explicit versioned names                | `claude-sonnet-4.6`, `claude-opus-4.7`         |
| Gemini CLI         | Prefer stable aliases                   | `pro`, `flash`, `flash-lite`, `auto`           |
| Claude Code CLI    | Prefer family aliases                   | `opus`, `sonnet`, `haiku`                      |

## Scope & Boundaries

- `dotfiles-private/` is gitignored. Do not commit its contents or add references that assume it exists.
- Edit skills only at `agents/skills/<skill>/...`. The paths under `~/.agents/`, `~/.claude/skills/`, and `~/.codex/skills/` are symlinks — editing through them is fine mechanically but bypasses git.
- The `.system` directory inside `~/.codex/skills/` is managed by Codex itself; that's why `link-codex` uses individual per-skill symlinks rather than linking the whole `skills/` directory.

## Notes for AI Agents

- After adding or renaming a skill under `agents/skills/`, run `make link` (or `make link F=<name>`) so the new symlinks propagate to `~/.agents/`, `~/.claude/skills/`, and `~/.codex/skills/`.
- `make list` is the fastest way to verify link state after changes — `[v]` is linked, `[-]` is unlinked.
- The Makefile discovers `claude/` subdirectories and `config/` tools dynamically via `find`, so adding a new subdirectory under either is picked up without editing the Makefile.
