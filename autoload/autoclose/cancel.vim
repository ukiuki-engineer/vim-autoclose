"
" 補完をキャンセル
"
" FIXME: A"<C-c>などもドットで繰り返せるように
function! autoclose#cancel_completion() abort
  if !exists('g:autoclose#cancel_completion_enable') || g:autoclose#cancel_completion_enable != 1
    return "\<Esc>"
  endif

  let l:trigger = g:autoclose#completion_strings['trigger']
  let l:completed = g:autoclose#completion_strings['completed']
  let l:delete_num = strlen(l:trigger) + strlen(l:completed)
  " カーソルの前の文字
  let l:prev_char = getline('.')[col('.') - 2]
  " 補完された文字列の次の文字
  let l:next_char_of_completed = getline('.')[col('.') - 1 + strlen(l:completed)]

  " 補完の後何も文字が入力されていないかつ、文末の場合
  if l:prev_char == l:trigger && l:next_char_of_completed == ""
    return "\<Esc>" . l:delete_num . "xa" . l:trigger . "\<Esc>"
  " 補完の後何も文字が入力されていないかつ、文末ではない場合
  elseif l:prev_char == l:trigger && l:next_char_of_completed != ""
    return "\<Esc>" . l:delete_num . "xi" . l:trigger . "\<Esc>"
  " 補完の後何か文字が入力されかつ、文末の場合
  elseif l:prev_char != l:trigger && l:next_char_of_completed == ""
    return "\<Esc>" . "F" . l:trigger . "\"zdt" . l:completed[0] . "x\"zp"
  " 補完の後何か文字が入力されかつ、文末ではない場合
  elseif l:prev_char != l:trigger && l:next_char_of_completed != ""
    return "\<Esc>" . "F" . l:trigger . "\"zdt" . l:completed[0] . "x\"zP"
  endif
endfunction

"
" 直前で補完が行われたかどうかを判定
"
function! autoclose#is_completion()
  if !exists('g:autoclose#completion_strings')
    return v:false
  endif
  let l:trigger_len = strlen(g:autoclose#completion_strings['trigger'])
  let l:completed_len = strlen(g:autoclose#completion_strings['completed'])
  let l:line = getline('.')
  let l:col = col('.')
  return l:line[l:col - 1 : l:col + l:completed_len - 2] == g:autoclose#completion_strings['completed']
endfunction