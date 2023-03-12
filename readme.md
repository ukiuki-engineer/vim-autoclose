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

## Usage
This plugin basically works without setting.

## Configuration
- Disabling bracket completion  
Default: `1`
```vim
let g:autoclose#autoclosing_brackets_enable = 0
```
- Disabling quotation completion  
Default: `1`
```vim
let g:autoclose#autoclosing_quots_enable = 0
```
- Disabling tag completion  
Default: `1`
```vim
let g:autoclose#autoclosing_tags_enable = 0
```
- Disabling completion of eruby's <%%>  
Default: `1`
```vim
let g:autoclose#autoclosing_eruby_tags = 0
```
- The setting for the pattern that disables bracket completion and quotation after the cursor.  
By default, the following patterns are set:  
Default\*: `['\a', '\d', '[^\x01-\x7E]']`  
\*`\a`: alphabet  
\*`\d`: number  
\*`[^\x01-\x7E]`: Double-byte character  
\*There are other configurable patterns as well. Please refer to :h pattern for details.  
If the next character after the cursor matches the applicable pattern mentioned above, bracket completion will not be triggered.  
To change this setting, add the following to your vimrc file.
```vim
" ex) add the end of line
let g:autoclose#disable_nextpattern_autoclosing_brackets = [
  \'\a',
  \'\d',
  \'[^\x01-\x7E]',
  \'$'
\]
let g:autoclose#disable_nextpattern_autoclosing_quots = [
  \'\a',
  \'\d',
  \'[^\x01-\x7E]',
  \'$'
\]
```
- Filetypes which tag auto-closing should be enabled  
Default: `["html", "xml", "javascript", "blade", "eruby", "vue"]`
```vim
" ex) add "markdown"
let g:autoclose#enabled_autoclosing_tags_filetypes = [
  \"html",
  \"xml",
  \"javascript",
  \"blade",
  \"eruby",
  \"vue",
  \"markdown"
\]
```
- Extensions which tag auto-closing should be enabled  
Default: `["*.html", "*.xml", "*.javascript", "*.blade", "*.eruby", "*.vue"]`
```vim
" ex) add "*.md"
let g:autoclose#enabled_autoclosing_tags_exts = [
  \"*.html",
  \"*.xml",
  \"*.js",
  \"*.blade.php",
  \"*.erb",
  \"*.vue",
  \"*.md"
\]
```
The above settings are the default configuration.  
If you do not specify any settings, these defaults will be applied.
- Auto-format New Line Feature  
Auto-format brackets, quotations, and line breaks in html tags.  
For Example:
```
{|}
{
  |
}
<div>|<div>
<div>
  |
<div>
```
This feature is enabled by default.  
Default: `1`
```vim
" on(default)
let g:autoclose#autoformat_newline_enable = 1
" off
let g:autoclose#autoformat_newline_enable = 0
```
- Autocompletion Cancel Feature  
You can cancel autocompletion if you don't want to use it. This feature is off by default.  
After completion is performed, calling the cancel function removes the completed string and leaves only the input string. If the completion function is assigned to <C-c>, it behaves as follows:
```vim
"|"-><C-c>→"
" |"-><C-c>→" 
```
Here, "|" represents the cursor position.  

https://user-images.githubusercontent.com/101523180/224526079-97927c75-4034-4f82-bab1-0091fd444dad.mov

To use this feature, add the following to your vimrc file.
```vim
let g:autoclose#cancel_completion_enable = 1 " Default: 0
"Key mapping for cancel feature
inoremap <expr> <C-c> autoclose#is_completion() ? autoclose#cancel_completion() : "\<Esc>"
```

## TODO
- Allow for setting tags to not be auto-completed.  
  Currently, so-called void elements (listed below) do not have closing tags auto-completed.  
  → `<br>`, `<hr>`, `<img>`, `<input>`, `<link>`, `<meta>`  
  Allow for specifying these settings in the vimrc file.
