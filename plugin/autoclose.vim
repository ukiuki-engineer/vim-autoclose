" vim-autoclose
" カッコ、クォーテーション、タグの補完
"
" NOTE: 設定仕様
" 変数で設定する。コマンドはない。
" ・タグ補完を有効にする拡張子の指定
" →g:enabled_autoclose_tag_exts
" ・タグ補完を有効にするFileTypeの指定
" →g:enabled_autoclose_tag_filetypes
" ・それぞれの補完機能のon/offを指定(0:off, 1:on(デフォルト))
" →g:enable_autoclose_brackets
" →g:enable_autoclose_quots
" →g:enable_autoclose_tags
" →g:enable_autoclose_eruby_tag
" ・タグ補完を適用しないファイルタイプ、拡張子を指定
" →g:disabled_autoclose_tag_filetypes
" →g:disabled_autoclose_tag_exts

" 括弧補完
if !exists('g:enable_autoclose_brackets') || (exists('g:enable_autoclose_brackets') && g:enable_autoclose_brackets == 1)
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
if !exists('g:enable_autoclose_quots') || (exists('g:enable_autoclose_quots') && g:enable_autoclose_quots == 1)
  inoremap <expr> ' autoclose#autoclose_quot("\'")
  inoremap <expr> " autoclose#autoclose_quot("\"")
  inoremap <expr> ` autoclose#autoclose_quot("\`")
endif

" タグ補完
if !exists('g:enable_autoclose_tags') || (exists('g:enable_autoclose_tags') && g:enable_autoclose_tags == 1)
  " vimrcの設定を反映
  call autoclose#reflect_vimrc()
  " タグ入力
  augroup VimAutoCloseTag
    au!
    au FileType,BufEnter * call autoclose#enable_autoclose_tag()
  augroup END
endif

" erubyの<%%>補完
if !exists('g:enable_autoclose_eruby_tag') || (exists('g:enable_autoclose_eruby_tag') && g:enable_autoclose_eruby_tag == 1)
  augroup VimautocloseErubyTag
    au!
    au FileType,BufEnter * call autoclose#enable_autoclose_eruby_tag()
  augroup END
endif
