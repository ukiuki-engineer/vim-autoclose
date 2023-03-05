" vim-autoclose
" カッコ、クォーテーション、タグの補完
"
" NOTE: 設定仕様
" 変数で設定する。コマンドはない。
" ・タグ補完を有効にする拡張子の指定
" →g:autoclose#enabled_autoclosing_tags_exts
" ・タグ補完を有効にするFileTypeの指定
" →g:autoclose#enabled_autoclosing_tags_filetypes
" ・それぞれの補完機能のon/offを指定(0:off, 1:on(デフォルト))
" →g:autoclose#autoclosing_brackets
" →g:autoclose#autoclosing_quots
" →g:autoclose#autoclosing_tags
" →g:autoclose#autoclosing_eruby_tags
" ・タグ補完を適用しないファイルタイプ、拡張子を指定
" →g:autoclose#disabled_autoclosing_tags_filetypes
" →g:autoclose#disabled_autoclosing_tags_exts

" 2重読み込み防止処理
if exists('g:autoclose#loaded_autoclose')
  finish
endif

let g:autoclose#loaded_autoclose = 1

" vimrcの設定を反映
call autoclose#reflect_vimrc()

" 括弧補完
if g:autoclose#autoclosing_brackets == 1
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
if g:autoclose#autoclosing_quots == 1
  inoremap <expr> ' autoclose#autoclose_quot("\'")
  inoremap <expr> " autoclose#autoclose_quot("\"")
  inoremap <expr> ` autoclose#autoclose_quot("\`")
endif

" タグ補完
if g:autoclose#autoclosing_tags == 1
  " タグ入力
  augroup autocloseTag
    au!
    au FileType,BufEnter * call autoclose#enable_autoclose_tag()
  augroup END
endif

" erubyの<%%>補完
if g:autoclose#autoclosing_eruby_tags == 1
  augroup autocloseErubyTag
    au!
    au FileType,BufEnter * call autoclose#enable_autoclose_eruby_tag()
  augroup END
endif
