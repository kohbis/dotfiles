---
name: multi-model-review
description: Run code review using multiple AI models (Codex/GPT, Gemini via Copilot, Gemini CLI, Claude Code) and synthesize results into a unified report showing common findings and per-reviewer unique insights. Trigger when user says "multi-model review", "/multi-model-review", or "review with multiple models". Available reviewers: codex (Codex CLI / GPT), copilot (Copilot CLI / Gemini), gemini (Gemini CLI), claude (Claude Code CLI).
---

# Multi-Model Review

## Reviewers

| Reviewer | CLI | Model | Default? | Skill Reference |
|----------|-----|-------|----------|-----------------|
| codex | Codex CLI | gpt-5.3-codex | ✅ | [codex-review](../codex-review/SKILL.md) |
| copilot | Copilot CLI | gemini-2.5-pro | ✅ | [copilot-cli](../copilot-cli/SKILL.md) |
| gemini | Gemini CLI | gemini-2.5-pro | — | [gemini-cli](../gemini-cli/SKILL.md) |
| claude | Claude Code CLI | claude-opus-4-6 | — | — |

Default: run **codex + copilot** (GPT + Gemini via Copilot CLI). Add others with e.g. "add gemini" or "use all reviewers".

## Workflow

1. **Determine review target** — default: `git diff HEAD`; alternatives below
2. **Confirm reviewers** — ask if not specified; default to codex + copilot
3. **Check CLI availability** — run `which {cli}` for each selected reviewer; handle missing tools (see below)
4. **Build common prompt** — same prompt sent to every reviewer
5. **Run all reviewers in parallel** — spawn each as a subagent simultaneously; collect outputs as they finish
6. **Synthesize** — extract common and unique findings
7. **Report** — present structured summary

> Running in parallel cuts total review time to the slowest single reviewer rather than the sum of all. Spawn subagents in the same turn so they execute concurrently.

## Handling Missing CLIs

Before running, check availability with `which {cli}`. If a CLI is not found, skip that reviewer and inform the user which tool was unavailable and its install command. Continue with whichever reviewers are available.

Install hints:
- **codex**: `npm install -g @openai/codex`
- **copilot**: `npm install -g @github/copilot-cli` (requires GitHub Copilot subscription)
- **gemini**: `npm install -g @google/gemini-cli`
- **claude**: `npm install -g @anthropic-ai/claude-code`

## Review Target

```bash
# Uncommitted changes (default)
git diff HEAD

# Staged changes only
git diff --cached

# Specific files
git diff HEAD -- {files}

# PR diff
gh pr diff {number}

# Specific commit
git show {hash}
```

Pipe diff content into the prompt or paste it inline.

## Common Prompt Format

Use this structure for all reviewers (substitute `{diff}` with actual content):

```
TASK: Review the following code changes for quality, correctness, and potential issues.
CONTEXT: {tech stack, environment, relevant background}
FOCUS: {specific concerns, e.g., security, performance, correctness — or "general" if none}
OUTPUT: List issues by severity (critical / major / minor), with file:line references where applicable.

CODE CHANGES:
{diff or file content}
```

## Running Each Reviewer

### Codex
```bash
codex exec \
  --model gpt-5.3-codex \
  --config model_reasoning_effort="high" \
  --sandbox read-only \
  --skip-git-repo-check \
  -C {WORKING_DIR} \
  "{PROMPT}"
```

### Gemini
```bash
gemini -p "{PROMPT}" \
  --model gemini-2.5-pro \
  --approval-mode plan
```

### Copilot (Gemini via Copilot CLI)
```bash
copilot -p "{PROMPT}" \
  --model gemini-2.5-pro \
  --allow-tool 'shell(read:*)'
```

### Claude (Claude Code CLI)
```bash
claude -p "{PROMPT}" \
  --model claude-opus-4-6 \
  --allowedTools "Bash(git:*),Read,Glob,Grep"
```

See each reviewer's skill file for full parameter options and rules.

## Synthesis

After collecting all outputs:

1. **Common findings** — issues mentioned by 2+ reviewers (higher confidence, prioritize these)
2. **Unique findings** — issues from only one reviewer (potentially model-specific insight)
3. Deduplicate issues that are substantially the same
4. Sort by severity: critical → major → minor

## Output Format

```markdown
## Multi-Model Review Summary

**Reviewers:** {list of reviewers used}
**Target:** {what was reviewed, e.g., "git diff HEAD (3 files)"}

### Common Findings (2+ reviewers)
- [critical] {issue description} ({file:line if available})
- [major] {issue description}

### Codex Unique Findings
- [minor] {issue description}

### Gemini Unique Findings
- [major] {issue description}

### Copilot Unique Findings
- (none)

### Overall Assessment
{1–2 sentence summary of the overall code quality and the most important action items.}
```

## References

- [examples](references/examples.md) - End-to-end usage examples
