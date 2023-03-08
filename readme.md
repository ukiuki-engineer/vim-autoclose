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
let g:autoclose#autoclosing_brackets_enable = 0
```
- Disabling quotation completion  
Add the following to your vimrc:
```vim
let g:autoclose#autoclosing_quots_enable = 0
```
- Disabling tag completion  
Add the following to your vimrc:
```vim
let g:autoclose#autoclosing_tags_enable = 0
```

- Disabling completion of eruby's <%%>  
Add the following to your vimrc:
```vim
let g:autoclose#autoclosing_eruby_tags = 0
```

- Set the filetypes and extensions for which tag auto-closing should be enabled  
Add the following lines to your vimrc.
```vim
" FileTypes(default)
let g:autoclose#enabled_autoclosing_tags_filetypes = [
  \"html",
  \"xml",
  \"javascript",
  \"blade",
  \"eruby",
  \"vue"
\]
" extension(default)
let g:autoclose#enabled_autoclosing_tags_exts = [
  \"*.html",
  \"*.xml",
  \"*.js",
  \"*.blade.php",
  \"*.erb",
  \"*.vue"
\]
```
The above settings are the default configuration.  
If you do not specify any settings, these defaults will be applied.

- Autocompletion Cancel Feature  
You can cancel autocompletion if you don't want to use it. This feature is off by default.  
After completion is performed, calling the cancel function removes the completed string and leaves only the input string. If the completion function is assigned to <C-c>, it behaves as follows:
```vim
"|"-><C-c>→"
" |"-><C-c>→" 
```
Here, "|" represents the cursor position.  
To use this feature, add the following to your vimrc file.
```vim
let g:autoclose#cancel_completion_enable = 1
inoremap <expr> <C-c> autoclose#is_completion() ? autoclose#cancel_completion() : "\<Esc>"
```

## TODO
- Allow users to define the control of bracket and quotation completion.  
Currently, bracket and quotation completion are controlled by the plugin in the following way:  
→Do not auto-complete parentheses in the following cases:

  - The character immediately preceding the cursor is a quotation mark that matches the one that was entered.
  - The character immediately following the cursor is an alphabet.
  - The character immediately following the cursor is a number.
  - The character immediately following the cursor is a full-width character.

  Allow for fine-tuning of these settings in the vimrc file.  

- Allow for setting tags to not be auto-completed.  
  Currently, so-called void elements (listed below) do not have closing tags auto-completed.  
  → `<br>`, `<hr>`, `<img>`, `<input>`, `<link>`, `<meta>`  
  Allow for specifying these settings in the vimrc file.
- Add an option to insert a new line, similar to VSCode.  
This feature was previously implemented but has since been removed. I will add an option to use it.  
For example:
```
{|}
{
  |
}
```
