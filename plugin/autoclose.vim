" vim-autoclose
" カッコ、クォーテーション、タグの補完
"
" NOTE: 設定仕様
" 変数で設定する。コマンドはない。
" ・タグ補完を有効にする拡張子の指定
" →g:enabled_autoclosing_tags_exts
" ・タグ補完を有効にするFileTypeの指定
" →g:enabled_autoclosing_tags_filetypes
" ・それぞれの補完機能のon/offを指定(0:off, 1:on(デフォルト))
" →g:autoclosing_brackets
" →g:autoclosing_quots
" →g:autoclosing_tags
" →g:autoclosing_eruby_tags
" ・タグ補完を適用しないファイルタイプ、拡張子を指定
" →g:disabled_autoclosing_tags_filetypes
" →g:disabled_autoclosing_tags_exts

" 括弧補完
if !exists('g:autoclosing_brackets') || (exists('g:autoclosing_brackets') && g:autoclosing_brackets == true)
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
if !exists('g:autoclosing_quots') || (exists('g:autoclosing_quots') && g:autoclosing_quots == true)
  inoremap <expr> ' autoclose#autoclose_quot("\'")
  inoremap <expr> " autoclose#autoclose_quot("\"")
  inoremap <expr> ` autoclose#autoclose_quot("\`")
endif

" タグ補完
if !exists('g:autoclosing_tags') || (exists('g:autoclosing_tags') && g:autoclosing_tags == true)
  " vimrcの設定を反映
  call autoclose#reflect_vimrc()
  " タグ入力
  augroup VimAutoCloseTag
    au!
    au FileType,BufEnter * call autoclose#enable_autoclose_tag()
  augroup END
endif

" erubyの<%%>補完
if !exists('g:autoclosing_eruby_tags') || (exists('g:autoclosing_eruby_tags') && g:autoclosing_eruby_tags == true)
  augroup VimautocloseErubyTag
    au!
    au FileType,BufEnter * call autoclose#enable_autoclose_eruby_tag()
  augroup END
endif
