" vim-autoclose
" カッコ、クォーテーション、タグの補完

" 括弧入力
inoremap <expr> ( autoclose#WriteCloseBracket("(")
inoremap <expr> { autoclose#WriteCloseBracket("{")
inoremap <expr> [ autoclose#WriteCloseBracket("[")

" 閉じ括弧入力
inoremap <expr> ) autoclose#NotDoubleCloseBracket(")")
inoremap <expr> } autoclose#NotDoubleCloseBracket("}")
inoremap <expr> ] autoclose#NotDoubleCloseBracket("]")

" クォーテーション入力
inoremap <expr> ' autoclose#AutoCloseQuot("\'")
inoremap <expr> " autoclose#AutoCloseQuot("\"")
inoremap <expr> ` autoclose#AutoCloseQuot("\`")

" vimrcの設定を反映
call autoclose#ReflectVimrc()

" タグ入力
augroup AutoCloseTag
  au!
  au FileType,BufEnter * call autoclose#EnableAutoCloseTag()
augroup END

" FIXME: iunmapで解除ではなく、配列からファイルを除く処理をReflectVimrc()に追加する
" vimrcで設定したFileType、拡張子のファイルに対して閉じタグ補完の解除
if exists('g:disabledAutoCloseTagFileTypes') || exists('g:disabledAutoCloseTagFileTypes')
  iunmap >
  iunmap </
endif
