" leader key mapping
let mapleader = "\<Space>"

" replace <ESC>
inoremap <silent> jj <ESC>
inoremap <silent> <C-j> j
inoremap <silent> kk <ESC>
inoremap <silent> <C-k> k

" change windows key mapping
nnoremap s <Nop>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H

" Move cursor on Display line
nnoremap j gj
nnoremap k gk
nnoremap <down> gj
nnoremap <up> gk

" toggle search highlight
nnoremap <silent><Esc><Esc> :<C-u>set nohlsearch!<CR>

" add empty line
nnoremap <Leader>jj o<ESC>k
nnoremap <Leader>kk O<ESC>j

" save shortcut
nnoremap <Leader>w :w<CR>

