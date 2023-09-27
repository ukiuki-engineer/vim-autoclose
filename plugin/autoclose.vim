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
  call autoclose#enable_autoclose_tag()
endif

" 改行を良い感じに
" FIXME: cocの補完決定とダブってしまう。coc-pairsではどうしているのかを見てみる
if g:autoclose#autoformat_newline_enable == 1
  inoremap <expr> <Cr> autoclose#autoformat_newline()
endif

let g:autoclose#disabled_filetypes = ["html"]

" 指定されたFileTypeで補完無効化
if exists('g:autoclose#disabled_filetypes')
  let filetypes = join(g:autoclose#disabled_filetypes, ',')
  execute "autocmd FileType " .. filetypes .. " call autoclose#disable_completion()"
endif

