" vim-autoclose
" カッコ、クォーテーション、タグの補完
"
" NOTE: 設定仕様
" 変数で設定する。コマンドはない。
" ・タグ補完を有効にする拡張子の指定
" →g:enabledAutoCloseTagExtensions
" ・タグ補完を有効にするFileTypeの指定
" →g:enabledAutoCloseTagFileTypes
" ・それぞれの補完機能のon/offを指定(0:off, 1:on(デフォルト))
" →g:enableAutoCloseBrackets
" →g:enableAutoCloseQuots
" →g:enableAutoCloseTags
" →g:enableAutoCloseErubyTag
" ・タグ補完を適用しないファイルの種類を指定
" →g:disabledAutoCloseTagFileTypes
" →g:disabledAutoCloseTagExtensions

" 括弧補完
if !exists('g:enableAutoCloseBrackets') || (exists('g:enableAutoCloseBrackets') && g:enableAutoCloseBrackets == 1)
  " 括弧入力
  inoremap <expr> ( autoclose#WriteCloseBracket("(")
  inoremap <expr> { autoclose#WriteCloseBracket("{")
  inoremap <expr> [ autoclose#WriteCloseBracket("[")
  " 閉じ括弧入力
  inoremap <expr> ) autoclose#NotDoubleCloseBracket(")")
  inoremap <expr> } autoclose#NotDoubleCloseBracket("}")
  inoremap <expr> ] autoclose#NotDoubleCloseBracket("]")
endif


" クォーテーション補完
if !exists('g:enableAutoCloseQuots') || (exists('g:enableAutoCloseQuots') && g:enableAutoCloseQuots == 1)
  inoremap <expr> ' autoclose#AutoCloseQuot("\'")
  inoremap <expr> " autoclose#AutoCloseQuot("\"")
  inoremap <expr> ` autoclose#AutoCloseQuot("\`")
endif

" タグ補完
if !exists('g:enableAutoCloseTags') || (exists('g:enableAutoCloseTags') && g:enableAutoCloseTags == 1)
  " vimrcの設定を反映
  call autoclose#ReflectVimrc()

  " タグ入力
  augroup VimAutoCloseTag
    au!
    au FileType,BufEnter * call autoclose#EnableAutoCloseTag()
  augroup END

  " FIXME: iunmapで解除ではなく、配列からファイルを除く処理をReflectVimrc()に追加する
  " vimrcで設定したFileType、拡張子のファイルに対して閉じタグ補完の解除
  if exists('g:disabledAutoCloseTagFileTypes') || exists('g:disabledAutoCloseTagFileExtensions')
    iunmap >
    iunmap </
  endif
endif

" erubyの<%%>補完
if !exists('g:enableAutoCloseErubyTag') || (exists('g:enableAutoCloseErubyTag') && g:enableAutoCloseErubyTag == 1)
  augroup VimAutoCloseErubyTag
    au!
    au FileType,BufEnter * call autoclose#EnableAutoCloseErubyTag()
  augroup END
endif
