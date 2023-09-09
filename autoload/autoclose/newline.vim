"
" 改行時の挙動
"
function! autoclose#autoformat_newline()
  " カーソルの前の文字
  let l:prev_char = getline('.')[col('.') - 2]
  " カーソルの次の文字
  let l:next_char = getline('.')[col('.') - 1]
  if l:next_char != "" && l:next_char == s:reverse_bracket(l:prev_char)
    return "\<Cr>\<Esc>O"
  else
    return "\<Cr>"
  endif
endfunction