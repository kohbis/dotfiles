## Usage

### Setting

Create symbolic links for dotfiles in home directory
```bash
$ git clone https://github.com/kohbis/dotfiles.git your-workspace/dotfiles
$ cd your-workspace/dotfiles
$ ./setup.sh -s
```

Remove symbolic links for dotfiles in home directory
```bash
$ ./setup.sh -d
```

Recreate (remove & create)
```
$ ./setup.sh -u
```
