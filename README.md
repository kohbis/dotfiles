# dotfiles

## Usage

### Setting

```bash
git clone https://github.com/kohbis/dotfiles.git your-workspace/dotfiles
cd your-workspace/dotfiles
./setup.sh [option]
```

| Option | Description |
| ------ | ----------- |
| `-c` | Create symbolic links |
| `-d` | Delete symbolic links |
| `-r` | Recreate symbolic links (delete & create) |

### Private dotfiles (optional)

Files are managed with file-level symbolic links, so files from a private repository can be integrated seamlessly.

Clone your private dotfiles into this repository's directory and `setup.sh` will detect and link them automatically:

```bash
git clone <dotfiles-private-repo> dotfiles-private
./setup.sh -c
```

`dotfiles-private/` is excluded from this repository via `.gitignore`.
