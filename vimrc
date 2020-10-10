"
" Encode
"
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
set fileformats=unix,dos,mac

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
" colorscheme molokai
highlight CursorLine cterm=none ctermbg=234
highlight CursorLineNr cterm=none ctermbg=234

filetype plugin indent on

autocmd BufEnter *.json setl conceallevel=0

"
" Curosr
"
set cursorline
set ignorecase

"
" LineNumber
"
set number
" set relativenumber

"
" Search
"
set ignorecase
set hlsearch
set incsearch
" 大文字入力した場合はignorecaseを無効化
set smartcase
" 最後尾まで検索したら先頭に戻る
set wrapscan

"
" Undo
"
set undolevels=1000
if has('persistent_undo')
  let undo_path = expand('~/.vim/undo')
  exe 'set undodir=' . undo_path
  set undofile
endif

"
" Tab
"
" tabとみなすspace数
set tabstop=4
" tab入力で挿入するspace数
set softtabstop=4
set expandtab

"
" Indent
"
" C構文解析に基づくindent
set smartindent
" 1行前に基づくindent
set autoindent
" 自動indentのspace数
set shiftwidth=4
let g:indentLine_fileTypeExclude = ['help', 'nerdtree', 'tabbar', 'unite']

"
" Clipboard
"
if has("mac")
  set clipboard+=unnamed
else
  set clipboard^=unnamedplus
endif

"
" TabPage
"
" tabを常に表示
set showtabline=2

"
" StatusLine
"
" stausを常に表示
set laststatus=2
set statusline=%f%m%=%l,%c\ %{'['.(&fenc!=''?&fenc:&enc).']\ ['.&fileformat.']'}

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
" Terminal
"
" window移動
tnoremap <silent> <C-w>p <C-w>:tabprevious<CR>
tnoremap <silent> <C-w>n <C-w>:tabnext<CR>

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
" 外部の変更を自動読込
set autoread
" backspaceの影響範囲
set backspace=indent,eol,start
" 未保存ファイルがある場合に終了前に保存確認
set confirm
" 未保存ファイルがある場合でも別ファイルを開く
set hidden
" 不可視文字の表示
set list
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%
" マウス操作有効化
set mouse=a
" ファイル保存時にbackupファイルを作成しない
set nobackup
" swapファイルを作成しない
set noswapfile
" カーソル位置
set ruler
" スクロール時の確保行
set scrolloff=10
" 入力コマンド表示
set showcmd
" 対応する括弧表示
set showmatch
" bepp音無効化
set visualbell t_vb=

