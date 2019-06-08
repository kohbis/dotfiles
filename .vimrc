if &compatible
  set nocompatible
endif

" encoding
set encoding=utf-8
set fileencoding=utf-8

" file
set autoread
set confirm
set hidden
set nobackup
set noswapfile

" visual
set cursorline
set list listchars=tab:\>\-
set number
set ruler
set scrolloff=5
set showcmd
set showmatch
set title
set virtualedit=onemore
set visualbell t_vb=

" status
set laststatus=2
set statusline=%f%m%=%l,%c\ %{'['.(&fenc!=''?&fenc:&enc).']\ ['.&fileformat.']'}

" completation
set wildmenu wildmode=list:longest,full

" edit
set backspace=indent,eol,start
set clipboard=unnamed,unnamedplus
set mouse=a
set paste

" tab,indent
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set smartindent

" search
set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch

"
" map
"
noremap <C-n> :NERDTreeToggle<CR>

nnoremap j gj
nnoremap k gk
nnoremap Y y$
nnoremap + <C-a>
nnoremap - <C-x>
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>

"
" plugin
"
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

call dein#begin(expand('~/.vim/dein'))

  call dein#add('Shougo/unite.vim')
  call dein#add('scrooloose/nerdtree')
  call dein#add('tomasr/molokai')
  call dein#add('nathanaelkane/vim-indent-guides')
  call dein#add('Townk/vim-autoclose')
  call dein#add('itchyny/lightline.vim')
  call dein#add('scrooloose/syntastic')
  call dein#add('bronson/vim-trailing-whitespace')
  call dein#add('ctrlpvim/ctrlp.vim')
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neosnippet-snippets')

call dein#end()

filetype plugin indent on

if dein#check_install()
  call dein#install()
endif

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

let g:indent_guides_enable_on_vim_startup = 1

"
" color
"
syntax enable
colorscheme molokai

highlight CursorLine cterm=none ctermbg=234
highlight CursorLineNr cterm=none ctermbg=234

