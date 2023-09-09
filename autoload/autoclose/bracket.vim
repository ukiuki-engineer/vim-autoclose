"
" 閉じ括弧補完
"
function! autoclose#write_close_bracket(bracket) abort
  " カーソルの前の文字
  let l:prev_char = getline('.')[col('.') - 2]
  " カーソルの次の文字
  let l:next_char = getline('.')[col('.') - 1]
  " 指定されたパターンにマッチする場合は補完しない
  if l:next_char =~ join(s:disable_nextpattern_autoclosing_brackets, '\|') && !empty(s:disable_nextpattern_autoclosing_brackets)
    " 括弧補完しない
    return a:bracket
  else
    " キャンセル機能が有効な場合は、補完状態を保存する
    if g:autoclose#cancel_completion_enable == 1
      call s:save_completion_strings(a:bracket, s:reverse_bracket(a:bracket))
    endif
    " NOTE: <C-g>Uは、undoの単位の分割をしないという意味
    "       カーソル移動するとundoの単位が分割されるため、<C-g>Uでそれを防ぐ
    "       ※<C-g>uは、undoの単位の分割。その時点で<Esc>したのと同じことになる。
    " 括弧補完
    return a:bracket . s:reverse_bracket(a:bracket) . "\<C-g>U\<Left>"
  endif
endfunction

"
" 閉じ括弧入力時の挙動
"
function! autoclose#not_double_close_bracket(close_bracket) abort
  " カーソルの前の文字
  let l:prev_char = getline('.')[col('.') - 2]
  " カーソルの次の文字
  let l:next_char = getline('.')[col('.') - 1]
  " ()と入力した場合())とせずに()で止める
  if l:next_char == a:close_bracket && l:prev_char == s:reverse_bracket(a:close_bracket)
    return "\<RIGHT>"
  else
    return a:close_bracket
  endif
endfunction