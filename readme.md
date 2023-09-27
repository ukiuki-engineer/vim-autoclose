# vim-autoclose

This plugin automatically closes brackets, quotes, and HTML tags in Vim.  

## Features:

- Automatically close brackets and quotes.
- Completes closing HTML tags when typing `>` or `</`.
- Provides smart control over completion, so it doesn't interfere when you don't want it to. For example:
  - Doesn't automatically complete the closing character if you already typed both (e.g., `()` won't become `())`)
  - Does not automatically complete closing tags for **void elements** such as `<br>`, `<hr>`, `<img>`, `<input>`, `<link>`, `<meta>`
  - Does not automatically complete the closing > character if not in the context of an HTML tag (e.g., `=>` or `->`)
- Auto-format Line-Break Feature  
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

## Installation

#### Via Plugin Manager

Add `ukiuki-engineer/vim-autoclose` to your preferred plugin manager.  
For example, with vim-plug:

```vim
" ex) vim-plug
Plug 'ukiuki-engineer/vim-autoclose'
```

#### Manually

Create a directory named `.vim/pack/plugins/start` and place the plugin there:

```bash
mkdir -p ~/.vim/pack/plugins/start
cd ~/.vim/pack/plugins/start
git clone https://github.com/ukiuki-engineer/vim-autoclose
```

## Usage

This plugin basically works without setting.

## Default Configuration

```vim
" default configration

" bracket completion enabled
let g:autoclose#autoclosing_brackets_enable = 1
" quot completion enabled
let g:autoclose#autoclosing_quots_enable    = 1
" tag completion enabled
let g:autoclose#autoclosing_tags_enable     = 1
" Auto-format Line-Break enabled
let g:autoclose#autoformat_newline_enable   = 1

" The setting for the next pattern after cursor that disables bracket and quotation completion.
let g:autoclose#disable_nextpattern_autoclosing_brackets = [
  \ '\a',
  \ '\d',
  \ '[^\x01-\x7E]',
\ ]
let g:autoclose#disable_nextpattern_autoclosing_quots = [
  \ '\a',
  \ '\d',
  \ '[^\x01-\x7E]',
\ ]
" NOTE:
" \*`\a`: alphabet  
" \*`\d`: number  
" \*`[^\x01-\x7E]`: Double-byte character  
" Please refer to :h pattern for details

" Filetypes which tag auto-closing should be enabled
let g:autoclose#enabled_autoclosing_tags_filetypes = [
  \ "html",
  \ "xml",
  \ "javascript",
  \ "blade",
  \ "eruby",
  \ "vue",
\ ]
```

## Additional Configuration Examples

```vim
" -----------------------------------------------------------------------------
" Enable cancel feature
let g:autoclose#cancel_completion_enable = 1 " Default: 0
" Key mapping for cancel feature
inoremap <expr> <C-c> autoclose#is_completion() ? autoclose#cancel_completion() : "\<Esc>"

" -----------------------------------------------------------------------------
" Custom Completion
augroup autoclose#custom_completion
  autocmd!
  " html commentout
  autocmd FileType html,vue,markdown call autoclose#custom_completion({
        \ 'prev_char' : '<',
        \ 'input_char': '!',
        \ 'output'    : '!--  -->',
        \ 'back_count': 4
        \ })
  " eruby tags
  autocmd FileType eruby call autoclose#custom_completion({
        \ 'prev_char' : '<',
        \ 'input_char': '%',
        \ 'output'    : '%%>',
        \ 'back_count': 2
        \ })
  " eruby commentout
  autocmd FileType eruby call autoclose#custom_completion({
        \ 'prev_char' : '%',
        \ 'input_char': '#',
        \ 'output'    : '#  ',
        \ 'back_count': 1
        \ })
  " Laravel-blade commentout
  autocmd FileType blade call autoclose#custom_completion({
        \ 'prev_char' : '{',
        \ 'input_char': '-',
        \ 'output'    : '--  --',
        \ 'back_count': 3
        \ })
augroup END

" -----------------------------------------------------------------------------
" Disable Completion FileTypes
let g:autoclose#disabled_filetypes = ["TelescopePrompt"]
```
