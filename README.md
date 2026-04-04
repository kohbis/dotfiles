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
make unlink F=otel  # only otel-related claude skills
```

### Private dotfiles (optional)

Files are managed with file-level symbolic links, so files from a private repository can be integrated seamlessly.

Clone your private dotfiles into this repository's directory and `make` will detect and link them automatically:

```bash
git clone <dotfiles-private-repo> dotfiles-private
make link
```

`dotfiles-private/` is excluded from this repository via `.gitignore`.
