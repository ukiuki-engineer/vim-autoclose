"
" クォーテーション補完
"
function! autoclose#autoclose_quot(quot) abort
  " カーソルの前の文字
  let l:prev_char = getline('.')[col('.') - 2]
  " カーソルの次の文字
  let l:next_char = getline('.')[col('.') - 1]

  " カーソルの左右にクォーテンションがある場合は何も入力せずにカーソルを移動
  if l:prev_char == a:quot && l:next_char == a:quot
    return "\<RIGHT>"
  " カーソルの前の文字が入力されたクォーテーションの場合は補完しない
  elseif l:prev_char == a:quot
    return a:quot
  " 指定されたパターンにマッチする場合は補完しない
  elseif l:next_char =~ join(s:disable_nextpattern_autoclosing_quots, '\|') && !empty(s:disable_nextpattern_autoclosing_quots)
    return a:quot
  " それ以外は補完する
  else
    " キャンセル機能が有効な場合は、補完状態を保存する
    if g:autoclose#cancel_completion_enable == 1
      call s:save_completion_strings(a:quot, a:quot)
    endif
    return a:quot . a:quot . "\<Left>"
  endif
endfunction