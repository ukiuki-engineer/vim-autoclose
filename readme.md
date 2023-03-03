# vim-autoclose
This plugin automatically closes parentheses, brackets, quotes, and other paired characters in Vim.  
[japanese](https://github.com/ukiuki-engineer/vim-autoclose/blob/master/readme_ja.md)

## Features:
- Automatically completes closing parentheses, brackets, and quotes
- Completes closing tags when typing `>` or `</` for HTML
- Completes `<%%>` in eruby
- Provides smart control over completion, so it doesn't interfere when you don't want it to. For example:
  - Doesn't automatically complete the closing character if you already typed both (e.g., `()` won't become `())`)
  - Does not automatically complete closing tags for **void elements** such as `<br>`, `<hr>`, `<img>`, `<input>`, `<link>`, `<meta>`
  - Does not automatically complete the closing > character if not in the context of an HTML tag (e.g., `=>` or `->`)

## Demo
https://user-images.githubusercontent.com/101523180/207311455-5a2b63f4-6102-4607-b9f7-26e07552c7b8.mov

https://user-images.githubusercontent.com/101523180/207350557-5c52c90d-a058-45f1-b226-2dded5c428a4.mov

## Installation
#### Via Plugin Manager
Add `ukiuki-engineer/vim-autoclose` to your preferred plugin manager.
For example, with vim-plug:
```vim
" ex)vim-plug
Plug 'ukiuki-engineer/vim-autoclose'
```
#### Manually
Create a directory named `.vim/pack/plugins/start` and place the plugin there:
```bash
mkdir -p ~/.vim/pack/plugins/start
cd ~/.vim/pack/plugins/start
git clone https://github.com/ukiuki-engineer/vim-autoclose
```

## Default settings
- Bracket completion → enabled
- Quotation completion → enabled
- Tag completion → enabled
- Types of files to which tag completion is applied
→
```
FileTypes: html, javascript, blade, vue
Extensions: *.html, *.js, *.blade.php, *.erb, *.vue
```

## Settings
- Disabling bracket completion  
Add the following to your vimrc:
```vim
let g:autoclosing_brackets = 0
```
- Disabling quotation completion  
Add the following to your vimrc:
```vim
let g:autoclosing_quots = 0
```
- Disabling tag completion  
Add the following to your vimrc:
```vim
let g:autoclosing_tags = 0
```

- Disabling completion of eruby's <%%>  
Add the following to your vimrc:
```vim
let g:autoclosing_eruby_tags = 0
```

- Adding file types and extensions to which tag completion is applied  
Add the following to your vimrc:
```vim
" ex)
let g:enabled_autoclosing_tags_filetypes = ["markdown", "php"]    " FileType
let g:enabled_autoclosing_tags_exts = ["*.md", "*.php"]           " extension
```

- Adding file types and extensions to which tag completion is **not** applied  
Add the following to your vimrc:
```vim
" ex)
let g:disabled_autoclosing_tags_filetypes = ["javascript", "php"] " FileType
let g:disabled_autoclosing_tags_exts = ["*.js", "*.php"]          " extension
```
