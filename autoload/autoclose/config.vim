"
" vimrcの設定を反映
"
function! autoclose#reflect_vimrc() abort
  " 設定されていなければデフォルト値を設定
  if !exists('g:autoclose#autoclosing_brackets_enable')
    let g:autoclose#autoclosing_brackets_enable = 1
  endif
  if !exists('g:autoclose#autoclosing_quots_enable')
    let g:autoclose#autoclosing_quots_enable = 1
  endif
  if !exists('g:autoclose#autoclosing_tags_enable')
    let g:autoclose#autoclosing_tags_enable = 1
  endif
  if !exists('g:autoclose#autoformat_newline_enable')
    let g:autoclose#autoformat_newline_enable = 1
  endif
  if !exists('g:autoclose#cancel_completion_enable')
    let g:autoclose#cancel_completion_enable = 0
  endif
  " 設定されていればデフォルト値を上書き
  if exists('g:autoclose#disable_nextpattern_autoclosing_brackets')
    let s:disable_nextpattern_autoclosing_brackets = g:autoclose#disable_nextpattern_autoclosing_brackets
  endif
  if exists('g:autoclose#disable_nextpattern_autoclosing_quots')
    let s:disable_nextpattern_autoclosing_quots = g:autoclose#disable_nextpattern_autoclosing_quots
  endif
  if exists('g:autoclose#enabled_autoclosing_tags_filetypes')
    let s:enabled_autoclosing_tags_filetypes = g:autoclose#enabled_autoclosing_tags_filetypes
  endif
  if exists('g:autoclose#enabled_autoclosing_tags_exts')
    let s:enabled_autoclosing_tags_exts =  map(g:autoclose#enabled_autoclosing_tags_exts, 'substitute(v:val, "*.", "", "")')
  endif
endfunction

