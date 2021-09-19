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

" toggle search highlight
nnoremap <silent><Esc><Esc> :<C-u>set nohlsearch!<CR>

" add empty line
nnoremap <Leader>j o<ESC>k
nnoremap <Leader>k O<ESC>j

" save shortcut
nnoremap <Leader>w :w<CR>

