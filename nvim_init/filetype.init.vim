autocmd BufRead,BufNewFile *.php       setfiletype php
autocmd BufNewFile,BufRead *.ctp       setfiletype php
autocmd BufNewFile,BufRead *.blade.php setfiletype blade
autocmd BufRead,BufNewFile *.ejs       setfiletype html
autocmd BufRead,BufNewFile *.html      setfiletype html
autocmd BufRead,BufNewFile *.js        setfiletype javascript
autocmd BufRead,BufNewFile *.ts        setfiletype typescript
autocmd BufRead,BufNewFile *.css       setfiletype css
autocmd BufRead,BufNewFile *.scss      setfiletype scss
autocmd BufRead,BufNewFile *.pcss      setfiletype scss
autocmd BufRead,BufNewFile *.java      setfiletype java
autocmd BufRead,BufNewFile *.sh        setfiletype sh
autocmd BufRead,BufNewFile *.mkd       setfiletype markdown
autocmd BufRead,BufNewFile *.md        setfiletype markdown

autocmd Filetype json setl conceallevel=0

" cssはハイフンも単語とする
augroup VimCSS3Syntax
  autocmd!
  autocmd FileType css,scss,pcss setlocal iskeyword+=-
augroup END
