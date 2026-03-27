---
name: multi-model-review
description: Run code review in parallel using multiple AI models and synthesize results into a unified report. Default reviewers: codex (GPT via Codex CLI) + copilot (Claude Opus via Copilot CLI). Optional: gemini (Gemini CLI), claude (Claude Code). Trigger when user says "multi-model review", "/multi-model-review", or "review with multiple models".
---

# Multi-Model Review

## Reviewers

| Reviewer | CLI | Model | Default? | Skill Reference |
|----------|-----|-------|----------|-----------------|
| codex | Codex CLI | gpt-5.3-codex | Yes | [codex-review](../codex-review/SKILL.md) |
| copilot | Copilot CLI | claude-opus-4.6 | Yes | [copilot-cli](../copilot-cli/SKILL.md) |
| gemini | Gemini CLI | gemini-2.5-pro | No | [gemini-cli](../gemini-cli/SKILL.md) |
| claude | Claude Code CLI | claude-opus-4-6 | No | — |

Default: run **codex + copilot** (GPT + Claude Opus via Copilot CLI). Add others with e.g. "add gemini" or "use all reviewers".

## Workflow

1. **Determine review target** — default: `git diff HEAD`; alternatives below
2. **Check prerequisites** — verify `git` is available and (if needed) `gh auth status`; run `command -v {cli}` for all selected reviewers
3. **Ask the user to confirm reviewers and models** — present availability results and proposed defaults; let the user adjust before proceeding. If the user does not respond, proceed with the proposed defaults after stating them clearly.
4. **Warn about sensitive content** — if the diff may contain secrets or PII, remind the user that content will be sent to external CLI tools before proceeding
5. **Build common prompt** — same prompt sent to every reviewer
6. **Run all reviewers in parallel** — spawn each as a subagent in the same turn; collect outputs as they finish
7. **Synthesize** — normalize severity, extract common and unique findings, verify file:line references
8. **Report** — present structured summary

> Parallel execution: spawn all reviewer subagents in a single turn so they run concurrently. Do not wait for one to finish before starting the next.

## Confirming Reviewers with the User

Before running, always present a summary like:

```
Reviewers (proposed):
  ✓ codex    gpt-5.3-codex        [installed]
  ✓ copilot  claude-opus-4.6      [installed]
  ✗ gemini                        [not found]
  ✗ claude                        [not found]

Proceed with codex + copilot? (or specify different reviewers/models)
```

If the user confirms or does not respond with changes, proceed with the proposed configuration.

## Review Target

```bash
# Uncommitted changes — staged + unstaged (default)
# Note: does NOT include untracked (new) files; use --cached for staged-only
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

For large diffs (>500 lines), consider limiting scope to specific files or directories to avoid token limit degradation.

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

Spawn all selected reviewers as subagents **in the same turn** so they run in parallel.

### Codex (default)
```bash
codex exec \
  --model gpt-5.3-codex \
  --config model_reasoning_effort="high" \
  --sandbox read-only \
  --skip-git-repo-check \
  -C {WORKING_DIR} \
  "{PROMPT}"
```

### Copilot (default, Claude Opus via Copilot CLI)
```bash
copilot -p "{PROMPT}" \
  --model claude-opus-4.6 \
  --allow-tool 'shell(read:*)'
```

### Gemini (optional)
```bash
gemini -p "{PROMPT}" \
  --model gemini-2.5-pro \
  --approval-mode plan
```

### Claude (optional, Claude Code CLI)
```bash
claude -p "{PROMPT}" \
  --model claude-opus-4-6 \
  --allowedTools "Bash(git:*),Read,Glob,Grep"
```

If a reviewer fails or times out, note it in the report and proceed with the remaining outputs.

See each reviewer's skill file for full parameter options and rules.

## Synthesis

After collecting all outputs:

1. **Normalize severity** — map each reviewer's scale to critical/major/minor:
   - critical: data loss, security vulnerability, crashes, build-breaking
   - major: incorrect behavior, missing error handling, significant performance issue
   - minor: style, clarity, minor inefficiency, missing tests
2. **Common findings** — issues mentioned by 2+ reviewers (higher confidence, prioritize these)
3. **Unique findings** — issues from only one reviewer (potentially model-specific insight)
4. **Deduplicate** — treat findings as the same if they point to the same root cause in the same file/function, even if worded differently
5. **Verify file:line references** — cross-check reported locations against the actual diff; drop or flag any that do not exist in the reviewed changes
6. Sort by severity: critical → major → minor

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

### Copilot Unique Findings
- (none)

### Overall Assessment
{1–2 sentence summary of the overall code quality and the most important action items.}

> One section per reviewer used. Add/remove sections to match the actual reviewers.
```

## References

- [examples](references/examples.md) - End-to-end usage examples
