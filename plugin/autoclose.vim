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
