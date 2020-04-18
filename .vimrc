"
" Encode
"
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis

"
" Curosr
"
set cursorline
set ignorecase
set smartcase
set incsearch

"
" LineNumber
"
set number
set relativenumber

"
" Search
"
set hlsearch

"
" Undo
"
if has('persistent_undo')
  let undo_path = expand('~/.vim/undo')
  exe 'set undodir=' . undo_path
  set undofile
endif

"
" Tab
"
set tabstop=2
set expandtab

"
" Indent
"
set smartindent
set shiftwidth=2
set autoindent
let g:indentLine_fileTypeExclude = ['help', 'nerdtree', 'tabbar', 'unite']

"
" Clipboard
"
set clipboard+=unnamed

"
" TabPage
"
set showtabline=2

"
" StatusLine
"
set laststatus=2

"
" CursorColumnSelect
"
set virtualedit=block

"
" CommandLine
"
set wildmenu
set wildmode=list:longest,full

"
" Keymap
"
nnoremap + <C-a>
nnoremap - <C-x>
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <C-s> :w<CR>
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>
nnoremap Y y$
nnoremap j gj
nnoremap k gk

"
" Etc
"
set autoread
set backspace=indent,eol,start
set confirm
set hidden
set list listchars=tab:\>\-
set mouse=a
set nobackup
set noswapfile
set paste
set ruler
set scrolloff=5
set showcmd
set showmatch
set softtabstop=2
set statusline=%f%m%=%l,%c\ %{'['.(&fenc!=''?&fenc:&enc).']\ ['.&fileformat.']'}
set title
set visualbell t_vb=
set wrapscan

"
" Plugin
"
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '~/.vim/dein/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . s:dein_repo_dir
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  call dein#add('Shougo/neosnippet-snippets')
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/unite.vim')
  call dein#add('SirVer/ultisnips')
  call dein#add('Townk/vim-autoclose')
  call dein#add('Yggdroot/indentLine')
  call dein#add('bronson/vim-trailing-whitespace')
  call dein#add('ctrlpvim/ctrlp.vim')
  call dein#add('itchyny/lightline.vim')
  call dein#add('jiangmiao/auto-pairs')
  call dein#add('jistr/vim-nerdtree-tabs')
  call dein#add('mattn/vim-lsp-settings')
  call dein#add('prabirshrestha/async.vim')
  call dein#add('prabirshrestha/asyncomplete-lsp.vim')
  call dein#add('prabirshrestha/asyncomplete.vim')
  call dein#add('prabirshrestha/vim-lsp')
  call dein#add('scrooloose/nerdtree')
  call dein#add('scrooloose/syntastic')
  call dein#add('simeji/winresizer')
  call dein#add('skanehira/translate.vim')
  call dein#add('tomasr/molokai')

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
  call map(s:removed_plugins, "delete(v:val, 'rf'")
  call dein#recache_runtimepath()
endif

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" NERDTree
let NERDTreeShowHidden=1
" UtilSnips
let g:UltiSnipsExpandTrigger="<tab>"
" winresizer
let g:winresizer_gui_enable = 1

"
" Syntax
"
syntax enable
filetype plugin indent on
" colorscheme molokai

highlight CursorLine cterm=none ctermbg=234
highlight CursorLineNr cterm=none ctermbg=234

