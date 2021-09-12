autocmd BufRead,BufNewFile *.php       setfiletype php
autocmd BufRead,BufNewFile *.blade.php setfiletype php
autocmd BufRead,BufNewFile *.ejs       setfiletype html
autocmd BufRead,BufNewFile *.html      setfiletype html
autocmd BufRead,BufNewFile *.js        setfiletype javascript
autocmd BufRead,BufNewFile *.ts        setfiletype typescript
autocmd BufRead,BufNewFile *.css       setfiletype css
autocmd BufRead,BufNewFile *.scss      setfiletype scss
autocmd BufRead,BufNewFile *.pcss      setfiletype scss
autocmd BufRead,BufNewFile *.java      setfiletype java
autocmd BufRead,BufNewFile *.sh        setfiletype sh

autocmd Filetype json setl conceallevel=0
