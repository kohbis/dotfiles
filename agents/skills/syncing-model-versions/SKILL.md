---
name: syncing-model-versions
description: Syncs model IDs, aliases, reasoning levels, and the README naming policy across this repo's AI CLI skills (Codex, Copilot CLI, Gemini CLI, Claude Code) when any upstream tool changes its model lineup. Trigger when the user says "syncing model versions", "/syncing-model-versions", or describes a model rename/addition/removal that needs to land in the skill docs.
disable-model-invocation: true
---

# Syncing Model Versions

Keep the AI-CLI skills and the shared naming policy in `README.md` aligned when one of Codex, Copilot CLI, Gemini CLI, or Claude Code changes its model lineup.

The skills are the contract these CLIs operate under — if a model ID or alias drifts, every downstream invocation (including `reviewing-with-multi-models`) silently uses the wrong model or fails. Treat this as a documentation-consistency job, not a creative one.

## Scope

In-scope files — anything under these globs that mentions a model name:

- `agents/skills/*/SKILL.md`
- `agents/skills/*/references/*.md`
- `README.md` (the **Model Naming Policy** table is the single source of truth for per-tool naming style)

The skills that actually reference models today:
`coding-with-codex`, `reviewing-with-codex`, `running-copilot-cli`, `running-gemini-cli`, `reviewing-with-multi-models`. Other skills under `agents/skills/` don't pin model names and can be ignored unless a search turns them up.

## Workflow

1. **Identify the affected CLI(s)** — one tool's rename doesn't justify touching the others. Keep the blast radius small.
2. **Establish the new names.** Order of trust:
   1. What the user told you in this conversation — authoritative.
   2. `<cli> --help` or equivalent on the local machine — ground truth for installed versions.
   3. Official docs (WebFetch) — only when 1 and 2 don't settle it.
   If these conflict, say so; don't silently pick one.
3. **Find every occurrence** with `rg` (see patterns below). Include README.
4. **Pick one naming style per tool** and apply it consistently. The style is defined in `README.md` → **Model Naming Policy**. If the user is asking you to *change* the style, update the README table and rationale first, then propagate.
5. **Update in pairs.** A model change in a parameter-selection table should land together with every command example that uses it — otherwise the skill ships an example that invokes a model it doesn't document.
6. **Check cross-skill references.** `reviewing-with-multi-models` names reviewer models directly; they must match whatever `reviewing-with-codex` / `running-copilot-cli` / `running-gemini-cli` now say.
7. **Re-search** for the old name after editing, so nothing stale hides in a reference doc.
8. **Report** which files changed, which names are now canonical, and any source-of-truth conflicts from step 2.

## Editing principles

- **Don't mix aliases and pinned names for the same CLI** unless the tool itself requires it. Mixing is how drift starts.
- **One change = one coherent edit.** If a CLI drops `gpt-5.3`, the table entry, the command example, and any `references/examples.md` using it all move in the same pass. Partial updates are worse than no update.
- **Version-pinned names are a deliberate choice, not laziness.** If you leave something pinned (e.g., a Copilot model per the README policy), note it in the report so the reviewer knows it was considered.
- **Don't invent names.** If you can't confirm a name from the three sources in step 2, ask.

## Search patterns

Find model references anywhere in scope:

```bash
rg -n --no-heading -- 'gpt-[0-9]|claude-(sonnet|opus|haiku|[0-9])|gemini-[0-9]|--model ' \
  agents/skills README.md
```

Caveat: the `claude-(sonnet|opus|haiku)` part matches *current* versioned Copilot names like `claude-sonnet-4.6` as well as bare aliases. That's intentional — you want both surfaces of the API in the hit list so you can decide per-match.

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
