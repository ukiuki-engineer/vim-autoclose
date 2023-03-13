" ================================================================================
" vim-autoclose
" Author: ukiuki-engineer
" License: MIT
" ================================================================================

" 2重読み込み防止処理
if exists('g:autoclose#loaded_autoclose')
  finish
endif
let g:autoclose#loaded_autoclose = 1

" vimrcの設定を反映
call autoclose#reflect_vimrc()

" 括弧補完
if g:autoclose#autoclosing_brackets_enable == 1
  " 括弧入力
  inoremap <expr> ( autoclose#write_close_bracket("(")
  inoremap <expr> { autoclose#write_close_bracket("{")
  inoremap <expr> [ autoclose#write_close_bracket("[")
  " 閉じ括弧入力
  inoremap <expr> ) autoclose#not_double_close_bracket(")")
  inoremap <expr> } autoclose#not_double_close_bracket("}")
  inoremap <expr> ] autoclose#not_double_close_bracket("]")
endif


" クォーテーション補完
if g:autoclose#autoclosing_quots_enable == 1
  inoremap <expr> ' autoclose#autoclose_quot("\'")
  inoremap <expr> " autoclose#autoclose_quot("\"")
  inoremap <expr> ` autoclose#autoclose_quot("\`")
endif

" タグ補完
if g:autoclose#autoclosing_tags_enable == 1
  " タグ入力
  augroup autocloseTag
    au!
    au FileType,BufEnter * call autoclose#enable_autoclose_tag()
  augroup END
endif

" erubyの<%%>補完
if g:autoclose#autoclosing_eruby_tags_enable == 1
  augroup autocloseErubyTag
    au!
    au FileType,BufEnter * call autoclose#enable_autoclose_eruby_tag()
  augroup END
endif

" 改行を良い感じに
" FIXME: cocの補完決定とダブってしまう。coc-pairsではどうしているのかを見てみる
if g:autoclose#autoformat_newline_enable == 1
  inoremap <expr> <Cr> autoclose#autoformat_newline()
endif
