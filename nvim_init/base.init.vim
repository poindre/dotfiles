set wrap
set t_Co=256
set hlsearch
set ignorecase
set smartcase
set autoindent
set inccommand=split
set signcolumn=yes
set ruler
set number
set list
set listchars=tab:»-,trail:-,eol:¬,extends:»,precedes:«,nbsp:%
set wildmenu
set showcmd
set shiftwidth=2
set softtabstop=2
set expandtab
set tabstop=2
set smarttab
set backspace=2
set shellslash
set clipboard=unnamedplus
set nrformats=

" 括弧の対応関係を一瞬表示する
set showmatch

" swpファイル格納先
set directory=~/.vim/tmp

"undoの格納先
" set undodir=~/.undodir

" カーソルラインをハイライト
set cursorline
highlight CursorLine term=reverse cterm=none ctermfg=NONE ctermbg=BLUE

" 保存時の文字コード
set fileencoding=utf-8

" カーソルの左右移動で行末から次の行の行頭への移動
set whichwrap=b,s,h,l,<,>,[,],~

" vim-gitgutterのアップデート時間設定
" set updatetime=100

" Vimの「%」を拡張する
source $VIMRUNTIME/macros/matchit.vim

" set pass for neovim
let g:python_host_prog='~/.anyenv/envs/pyenv/versions/2.7.17/bin/python2'
let g:python3_host_prog='~/.anyenv/envs/pyenv/versions/3.8.12/bin/python3'
let g:ruby_host_prog='~/.anyenv/envs/rbenv/versions/3.0.2/bin/ruby'

