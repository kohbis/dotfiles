set fenc=utf-8

set nobackup
set noswapfile
set autoread
set hidden

set showcmd

set number
set cursorline
" set cursorcolumn
set virtualedit=onemore
set smartindent
set visualbell
set showmatch
set laststatus=2
set wildmode=list:longest
nnoremap j gj
nnoremap k gk

syntax enable
colorscheme molokai

set list listchars=tab:\▸\-
set expandtab
set tabstop=2
set shiftwidth=2

set backspace=indent,eol,start

set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch
nmap <Esc><Esc> :nohlsearch<CR><Esc>

highlight CursorLine cterm=none ctermbg=234

