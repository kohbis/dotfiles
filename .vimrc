if &compatible
  set nocompatible
endif

set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8

set autoindent
set autoread
set backspace=indent,eol,start
set clipboard=unnamed,unnamedplus
set confirm
set cursorline
set expandtab
set hidden
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set list listchars=tab:\>\-
set mouse=a
set nobackup
set noswapfile
set number
set paste
set relativenumber
set ruler
set scrolloff=5
set shiftwidth=2
set showcmd
set showmatch
set smartcase
set smartindent
set softtabstop=2
set statusline=%f%m%=%l,%c\ %{'['.(&fenc!=''?&fenc:&enc).']\ ['.&fileformat.']'}
set tabstop=2
set title
set virtualedit=onemore
set visualbell t_vb=
set wildmenu wildmode=list:longest,full
set wrapscan

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'tagbar', 'unite']
let NERDTreeShowHidden=1

nnoremap + <C-a>
nnoremap - <C-x>
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>
nnoremap Y y$
nnoremap j gj
nnoremap k gk

"
" plugin
"
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

call dein#begin(expand('~/.vim/dein'))

  call dein#add('Shougo/neosnippet-snippets')
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/unite.vim')
  call dein#add('Townk/vim-autoclose')
  call dein#add('bronson/vim-trailing-whitespace')
  call dein#add('ctrlpvim/ctrlp.vim')
  call dein#add('itchyny/lightline.vim')
  call dein#add('jistr/vim-nerdtree-tabs')
  call dein#add('nathanaelkane/vim-indent-guides')
  call dein#add('scrooloose/nerdtree')
  call dein#add('scrooloose/syntastic')
  call dein#add('tomasr/molokai')
  call dein#add('prabirshrestha/async.vim')
  call dein#add('prabirshrestha/asyncomplete.vim')
  call dein#add('prabirshrestha/asyncomplete-lsp.vim')
  call dein#add('prabirshrestha/vim-lsp')
  call dein#add('mattn/vim-lsp-settings')
call dein#end()

filetype plugin indent on

if dein#check_install()
  call dein#install()
endif

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

"
" color
"
syntax enable
colorscheme molokai

highlight CursorLine cterm=none ctermbg=234
highlight CursorLineNr cterm=none ctermbg=234

