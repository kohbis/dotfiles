"
" Encode
"
set encoding=UTF-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
set fileformats=unix,dos,mac

"
" True Color
"
set termguicolors

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

  let s:toml_dir = $HOME . '/workspace/settings/dotfiles/vim/dein'
  let s:toml = s:toml_dir . '/dein.toml'
  let s:toml_lazy = s:toml_dir . '/dein_lazy.toml'

  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:toml_lazy, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
  call map(s:removed_plugins, "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endif

"
" Plugins Lua
"
lua << EOF
require("bufferline").setup{
  options = {
    numbers = 'both',
    diagnostics = "coc",
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      local s = " "
      for e, n in pairs(diagnostics_dict) do
        local sym = e == "error" and " "
          or (e == "warning" and " " or "" )
        s = s .. n .. sym
      end
      return s
    end,
    offsets = {
      {
        filetype = "NvimTree",
        text = "EXPLORER",
      }
    }
  }
}

require('nvim-tree').setup{
}
EOF

"
" Syntax
"
syntax enable


"
" Color
"
colorscheme gruvbox
highlight SignColumn   ctermbg=none
highlight CursorLine   cterm=none ctermbg=234
highlight CursorLineNr cterm=none ctermbg=234

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
" Tab, Indent
"
" tab入力をspaceに置き換える
set expandtab
" tabとみなすspace数
set tabstop=4
" tab入力で挿入するspace数
set softtabstop=4
" 自動indentのspace数
set shiftwidth=4
" C構文解析に基づくindent
set smartindent
" 1行前に基づくindent
set autoindent
let g:indentLine_fileTypeExclude = ['help', 'nvimtree', 'tabbar', 'unite']
" filetypeごとの設定
filetype plugin indent on
" sw=softtabstop, sts=shiftwidth, ts=tabstop, et=expandtab
autocmd FileType c          setlocal sw=4 sts=4 ts=4 et
autocmd FileType cpp        setlocal sw=4 sts=4 ts=4 et
autocmd FileType go         setlocal sw=8 sts=8 ts=8 noet
autocmd FileType java       setlocal sw=4 sts=4 ts=4 et
autocmd FileType javascript setlocal sw=2 sts=2 ts=2 et
autocmd FileType lua        setlocal sw=2 sts=2 ts=2 et
autocmd FileType ruby       setlocal sw=2 sts=2 ts=2 et
autocmd FileType rust       setlocal sw=4 sts=4 ts=4 et
autocmd FileType sh         setlocal sw=2 sts=2 ts=2 et
autocmd FileType toml       setlocal sw=2 sts=2 ts=2 et
autocmd FileType json       let g:indentLine_setConceal = 0
autocmd StdinReadPre *      let s:std_in=1


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
nnoremap <C-s> :w<CR>
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>
nnoremap Y y$
nnoremap j gj
nnoremap k gk
nnoremap <Leader>bb :buffers<CR>:b<Space>
nnoremap <Left> :bp<CR>
nnoremap <Right> :bn<CR>
inoremap ;<CR> <End>;<CR>
inoremap ,<CR> <End>,<CR>

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
" swapファイルを作成するまでの秒数
set updatetime=500
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

set termguicolors

