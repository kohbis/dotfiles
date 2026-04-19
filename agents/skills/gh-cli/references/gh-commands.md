# GitHub CLI Command Reference

Comprehensive reference for read-only `gh` commands with practical usage patterns.

## Table of Contents

- [Pull Requests](#pull-requests)
- [Issues](#issues)
- [GitHub Actions](#github-actions)
- [Releases](#releases)
- [Repository](#repository)
- [API Access](#api-access)
- [Advanced Patterns](#advanced-patterns)

## Pull Requests

### Basic Usage

```bash
# View PR
gh pr view <number>
gh pr view <number> --web

# List PRs
gh pr list
gh pr list --state all

# View diff
gh pr diff <number>

# Check CI status
gh pr checks <number>
```

### Advanced Usage

```bash
# Filter and format PR list
gh pr list --author @me --state merged --limit 10
gh pr list --json number,title,author,state --jq '.[] | "\(.number): \(.title)"'

# Detailed status check analysis
gh pr view <number> --json statusCheckRollup --jq '.statusCheckRollup[] | select(.conclusion == "FAILURE")'

# View PR with comments
gh pr view <number> --comments
```

## Issues

### Basic Usage

```bash
# View issue
gh issue view <number>
gh issue view <number> --web

# List issues
gh issue list
gh issue list --assignee @me
```

### Advanced Usage

```bash
# Complex filtering
gh issue list --label bug --state open --json number,title,labels
gh issue list --search "error in logs" --state all

# View with comments
gh issue view <number> --comments
```

## GitHub Actions

### Basic Usage

```bash
# View workflow runs
gh run view
gh run view <run-id>

# List runs
gh run list
gh run list --workflow "CI"

# View logs
gh run view <run-id> --log
gh run view <run-id> --log-failed

# Watch running workflow
gh run watch <run-id>
```

### Advanced Usage

```bash
# Filter by status and format output
gh run list --status failure --json databaseId,workflowName,conclusion
gh run list --branch main --event push --limit 20

# Download logs for offline analysis
gh run download <run-id>

# Monitor specific workflow
gh workflow view <workflow-name>
gh run list --workflow <workflow-name> --json status,conclusion --jq '.[] | select(.status == "completed")'
```

## Releases

### Basic Usage

```bash
# View releases
gh release view
gh release view <tag>

# List releases
gh release list

# Download assets
gh release download <tag>
```

### Advanced Usage

```bash
# Selective asset download
gh release download <tag> --pattern "*.zip" --dir ./downloads

# JSON output for automation
gh release list --json name,tagName,createdAt,isPrerelease
```

## Repository

### Basic Usage

```bash
# View repository
gh repo view
gh repo view owner/repo

# List repositories
gh repo list
gh repo list owner
```

### Advanced Usage

```bash
# Filter repositories
gh repo list --source --no-archived --limit 50
gh repo list --json name,description,isPrivate,stargazerCount
```

## API Access

Use `gh api` for operations not covered by specific commands.

### Common Patterns

```bash
# Repository information
gh api repos/:owner/:repo
gh api repos/:owner/:repo/branches
gh api repos/:owner/:repo/commits/<sha>

# PR and issue details
gh api repos/:owner/:repo/pulls/<number>/comments
gh api repos/:owner/:repo/pulls/<number>/reviews
gh api repos/:owner/:repo/issues/<number>/timeline

# Workflow details
gh api repos/:owner/:repo/actions/runs
gh api repos/:owner/:repo/actions/runs/<run-id>/jobs

# Search
gh api search/repositories --method GET -f q="language:python stars:>1000"
gh api search/code --method GET -f q="repo:owner/repo extension:js"
```

### Pagination and Processing

```bash
# Paginate results
gh api repos/:owner/:repo/issues --paginate

# Process with jq
gh api repos/:owner/:repo/pulls --jq '.[] | {number, title, author: .user.login}'
gh api repos/:owner/:repo --jq '.stargazers_count'
```

## Advanced Patterns

### JSON Output and Filtering

Most commands support `--json` with specific fields and `--jq` for processing:

```bash
# Extract specific fields
gh pr view 123 --json title,author,labels --jq '.title'

# Custom formatting
gh pr list --template '{{range .}}{{.number}}: {{.title}}{{"\n"}}{{end}}'

# Complex filtering
gh run list --json status,conclusion,workflowName \
  --jq '.[] | select(.status == "completed" and .conclusion == "failure")'
```

### Environment Variables

```bash
# Set default repository
export GH_REPO="owner/repo"

# Disable pager
export GH_PAGER=""
```

### Combining Commands

```bash
# Find failed CI runs for a specific workflow
gh run list --workflow "CI" --status failure --json databaseId,createdAt --jq '.[0].databaseId' | xargs gh run view --log-failed

# Get all open PRs by a specific author
gh pr list --author username --state open --json number | jq '.[].number'
```

## Tips and Best Practices

1. **Use JSON output for scripting**: Add `--json` flag with specific fields for machine-readable output
2. **Combine with jq**: Process JSON output with `jq` for powerful filtering and transformation
3. **Pagination**: Use `--paginate` with `gh api` to get complete results beyond the default limit
4. **Web viewing**: Add `--web` flag to quickly open resources in browser
5. **Environment variables**: Set `GH_REPO` to avoid repeating repository name
6. **Watch mode**: Use `gh run watch` for real-time monitoring of workflow runs
7. **Log downloads**: Download logs with `gh run download` for offline analysis or archiving
