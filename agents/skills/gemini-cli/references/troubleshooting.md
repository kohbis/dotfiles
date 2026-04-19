# Gemini CLI Troubleshooting

## Common Issues

### Authentication errors

```
Error: API key not found / not authenticated
```

Run `gemini` in interactive mode first to complete the authentication flow, then retry the headless command.

### Model not found

```
Error: Unknown model: gemini-x.x-xxx
```

Check available models: `gemini -p "list available models" --model gemini-2.0-flash --approval-mode plan`

Common model identifiers:
- `gemini-2.5-pro`
- `gemini-2.5-flash`
- `gemini-2.0-flash`

### Output too long / truncated

Add an explicit length instruction to the prompt:

```
OUTPUT: Concise bullet points only, max 20 items total
```

Or pipe through a pager:

```bash
gemini -p "..." --model gemini-2.5-pro --approval-mode plan | less
```

### Non-interactive mode not working

Ensure `-p` flag is used (not positional argument without `-p`):

```bash
# Correct
gemini -p "your prompt" --model gemini-2.5-pro --approval-mode plan

# Also valid (positional query without -p runs interactively by default)
# gemini "your prompt"  ← this opens interactive mode
```

### Sandbox mode

If the task needs network isolation, add `-s`:

```bash
gemini -p "{PROMPT}" --model gemini-2.5-pro --approval-mode plan -s
```
