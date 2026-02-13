---
name: gh-cli
description: GitHub CLI (gh) command helper for read-only operations. Use when working with GitHub resources like pull requests, issues, GitHub Actions, repositories, or commits. Trigger with /gh or when user mentions viewing/checking/listing PRs, issues, CI/CD runs, repository information, or GitHub-related queries. Provides comprehensive gh command reference and common usage patterns for read-only operations.
---

# GitHub CLI Helper

Efficiently use GitHub CLI (gh) for read-only operations to view and inspect GitHub resources.

## Quick Start

```bash
# View pull request
gh pr view <number>
gh pr list

# View issues
gh issue view <number>
gh issue list

# Check CI/CD status
gh run view
gh run list

# View repository info
gh repo view
```

## Common Patterns

```bash
# Open in browser
gh pr view <number> --web
gh issue view <number> --web

# JSON output for scripting
gh pr view <number> --json title,author,state
gh issue list --json number,title,labels

# Filter and search
gh pr list --author @me --state open
gh issue list --assignee @me --label bug
gh run list --workflow "CI" --status failure

# Direct API access
gh api repos/:owner/:repo
gh api repos/:owner/:repo/pulls/<number>/comments
```

## Advanced Usage

For detailed command reference, advanced filtering, jq integration, and practical examples, see:
- `references/gh-commands.md` - Complete command reference with basic and advanced patterns
