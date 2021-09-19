scriptencoding utf-8

syntax enable
filetype plugin indent on

augroup autocmd
  autocmd!
augroup END

function! s:source_init_vim(file_name)
  let init_file = expand($HOME . '/.dotfiles/nvim_init/' . a:file_name)
  if filereadable(init_file)
    execute 'source' init_file
  endif
endfunction

call s:source_init_vim('filetype.init.vim')
call s:source_init_vim('base.init.vim')
call s:source_init_vim('keymaps.init.vim')
call s:source_init_vim('lsp.init.vim')
call s:source_init_vim('tabs.init.vim')

let s:dein_dir = expand($HOME . '/.cache/dein')
let s:dein_plugin_dir = $HOME . '/.dotfiles/dein'
let s:lazy_toml_file = $HOME . '/.dotfiles/dein/dein_lazy.toml'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" 初回のみgit clone
if !isdirectory(s:dein_repo_dir)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif
execute 'set runtimepath^=' . s:dein_repo_dir

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  call dein#load_toml(s:dein_plugin_dir . '/dein/dein.toml', {'lazy': 0})
  call dein#load_toml(s:dein_plugin_dir . '/colorscheme/dein.toml', {'lazy': 0})
  call dein#load_toml(s:dein_plugin_dir . '/vim-polyglot/dein.toml', {'lazy': 0})
  call dein#load_toml(s:dein_plugin_dir . '/coc/dein.toml', {'lazy': 0})

  call dein#load_toml(s:dein_plugin_dir . '/lightline/dein.toml', {'lazy': 0})
  call dein#load_toml(s:dein_plugin_dir . '/fzf/dein.toml', {'lazy': 0})

  call dein#load_toml(s:dein_plugin_dir . '/markup/dein.toml', {'lazy': 0})
  call dein#load_toml(s:dein_plugin_dir . '/markdown/dein.toml', {'lazy': 0})
  call dein#load_toml(s:dein_plugin_dir . '/git/dein.toml', {'lazy': 0})
  call dein#load_toml(s:dein_plugin_dir . '/util/dein.toml', {'lazy': 0})

  call dein#load_toml(s:lazy_toml_file, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif
