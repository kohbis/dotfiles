---
name: syncing-model-versions
description: Syncs model IDs, aliases, reasoning levels, and the README naming policy across this repo's AI CLI skills (Codex, Copilot CLI, Claude Code) when any upstream tool changes its model lineup. Trigger when the user says "syncing model versions", "/syncing-model-versions", or describes a model rename/addition/removal that needs to land in the skill docs.
disable-model-invocation: true
---

# Syncing Model Versions

Keep the AI-CLI skills and the shared naming policy in `README.md` aligned when one of Codex, Copilot CLI, or Claude Code changes its model lineup.

The skills are the contract these CLIs operate under — if a model ID or alias drifts, every downstream invocation (including `reviewing-with-multi-models`) silently uses the wrong model or fails. Treat this as a documentation-consistency job, not a creative one.

## Scope

In-scope files — anything under these globs that mentions a model name:

- `agents/skills/**/*.md` (every `SKILL.md` plus any `references/` or `templates/` docs — search recursively, don't assume only those two paths)
- `README.md` (the **Model Naming Policy** table is the single source of truth for per-tool naming style)

Don't work from a remembered list of skills — the set that references models drifts as skills are added or edited. Start from a search across the in-scope globs (Workflow step 1) and act on whatever it surfaces. The directory is small enough to scan in full every time, so discover the set rather than recalling it.

## Workflow

1. **Inventory every model reference first.** Before anything else, search the in-scope globs with `rg` (see Search patterns), README included — don't work from a remembered list of skills. Whatever the search surfaces is the authoritative set of files in play.
2. **Identify the affected CLI(s)** — one tool's rename doesn't justify touching the others. Keep the blast radius small.
3. **Establish the new names.** Order of trust:
   1. What the user told you in this conversation — authoritative.
   2. `<cli> --help` or equivalent on the local machine — ground truth for installed versions.
   3. Official docs (WebFetch) — only when 1 and 2 don't settle it.
   If these conflict, say so; don't silently pick one.
4. **Pick one naming style per tool** and apply it consistently. The style is defined in `README.md` → **Model Naming Policy**. If the user is asking you to *change* the style, update the README table and rationale first, then propagate.
5. **Update in pairs.** A model change in a parameter-selection table should land together with every command example that uses it — otherwise the skill ships an example that invokes a model it doesn't document.
6. **Check cross-skill references.** `reviewing-with-multi-models` names reviewer models directly; they must match whatever `reviewing-with-codex` / `running-copilot-cli` now say.
7. **Re-search** for the old name after editing, so nothing stale hides in a reference doc.
8. **Report** which files changed, which names are now canonical, and any source-of-truth conflicts from step 3.

## Editing principles

- **Don't mix aliases and pinned names for the same CLI** unless the tool itself requires it. Mixing is how drift starts.
- **One change = one coherent edit.** If a CLI drops `gpt-5.3`, the table entry, the command example, and any `references/examples.md` using it all move in the same pass. Partial updates are worse than no update.
- **Version-pinned names are a deliberate choice, not laziness.** If you leave something pinned (e.g., a Copilot model per the README policy), note it in the report so the reviewer knows it was considered.
- **Don't invent names.** If you can't confirm a name from the three sources in step 3, ask.

## Search patterns

Find model references anywhere in scope:

```bash
rg -ni --no-heading -- 'gpt-[0-9]|claude-[a-z0-9.-]+|\b(opus|sonnet|haiku|fable)\b|--model ' \
  agents/skills README.md
```

Caveat: this deliberately casts wide. `claude-[a-z0-9.-]+` catches versioned names like `claude-sonnet-4.6` and `claude-opus-4.8`; the bare-alias branch catches Claude Code family aliases (`opus`/`sonnet`/`haiku`/`fable`) used without the `claude-` prefix — which is how most skills name Claude Code models. The bare aliases also appear in ordinary prose, so expect false positives and decide per-match; missing a real model reference is worse than skimming a few extra hits.

After a rename, verify the old name is gone:

```bash
rg -n --no-heading -- '<old-model-name>' agents/skills README.md
```

(Use the literal old name. A generic "stale-name regex" produces false positives.)

## What to report back

- Files updated, grouped by CLI.
- New canonical names per CLI, cross-referenced against `README.md`'s naming-policy table.
- Anything left intentionally pinned, with a one-line why.
- Any conflicts between the user's stated names, local `--help` output, and official docs.
