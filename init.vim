scriptencoding utf-8

syntax on
filetype plugin indent on

runtime nvim_init/base.init.vim

" autocmd ColorScheme * highlight lspReference ctermfg=234 ctermbg=110
" autocmd ColorScheme * highlight GitGutterAdd ctermfg=green
" autocmd ColorScheme * highlight GitGutterChange ctermfg=yellow
" autocmd ColorScheme * highlight GitGutterDelete ctermfg=red
" autocmd ColorScheme * highlight GitGutterChangeDelete ctermfg=yellow

let s:dein_dir = expand('~/.cache/dein')
let s:toml_file = "${DOTDIR}/dein/dein.toml"
let s:lazy_toml_file = "${DOTDIR}/dein/dein_lazy.toml"
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" 初回のみgit clone
if !isdirectory(s:dein_repo_dir)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif
execute 'set runtimepath^=' . s:dein_repo_dir

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  call dein#load_toml(s:toml_file, {'lazy': 0})
  call dein#load_toml(s:lazy_toml_file, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif
