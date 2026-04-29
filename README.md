# dotfiles

## Usage

### Setting

```bash
git clone https://github.com/kohbis/dotfiles.git your-workspace/dotfiles
cd your-workspace/dotfiles
make link
```

| Command        | Description                                |
| -------------- | ------------------------------------------ |
| `make link`    | Create symbolic links                      |
| `make unlink`  | Remove symbolic links                      |
| `make relink`  | Recreate symbolic links (remove & create)  |
| `make help`    | Show available commands                    |

Filter with `F=<string>` to target specific files:

```bash
make link F=vim     # only vimrc and nvim config
make unlink F=otel  # only otel-related skills
```

### Structure

```
dotfiles/
├── agents/skills/   # AI skills (source of truth)
├── claude/          # Claude-specific config (agents/, etc.)
├── config/          # ~/.config/ entries
└── ...              # dotfiles (~/.bashrc, ~/.zshrc, etc.)
```

Skills are linked through `~/.agents/skills/` as a shared hub:

```
dotfiles/agents/skills/<skill>
        ↑
~/.agents/skills/<skill>
        ↑                    ↑
~/.claude/skills/<skill>  ~/.codex/skills/<skill>
```

### Model Naming Policy

When a skill needs an explicit model name, follow these conventions:

| Tool / CLI | Naming policy | Examples |
| ---------- | ------------- | -------- |
| Codex CLI | Use explicit model IDs | `gpt-5.5`, `gpt-5.4-mini` |
| GitHub Copilot CLI | Use explicit versioned model names | `claude-sonnet-4.6`, `claude-opus-4.7` |
| Gemini CLI | Prefer stable aliases | `pro`, `flash`, `flash-lite`, `auto` |
| Claude Code CLI | Prefer family aliases | `opus`, `sonnet`, `haiku` |

Rationale:
- Codex skills currently use concrete OpenAI model IDs rather than family aliases.
- Copilot CLI should stay version-pinned unless GitHub documents alias support explicitly.
- Gemini CLI is more stable when using its alias-based routing.
- Claude Code CLI is intended to use family-level aliases rather than pinned release names.

### Private dotfiles (optional)

Files are managed with file-level symbolic links, so files from a private repository can be integrated seamlessly.

Clone your private dotfiles into this repository's directory and `make` will detect and link them automatically:

```bash
git clone <dotfiles-private-repo> dotfiles-private
make link
```

Skills in `dotfiles-private/agents/skills/` are also linked into `~/.agents/skills/` automatically.

`dotfiles-private/` is excluded from this repository via `.gitignore`.
