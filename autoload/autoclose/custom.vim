"
" カスタム補完を有効化
" NOTE: 呼び出し例
" autocmd FileType html,vue call autoclose#custom_completion({
"   \ 'prev_char' : '<',
"   \ 'input_char': '!',
"   \ 'output'    : '!--  -->',
"   \ 'back_count': 4
" \ })

function! autoclose#custom_completion(rule) abort
  execute "inoremap <buffer><expr>"
    \ a:rule['input_char']
    \ "autoclose#output_custom_completion('" .. a:rule['prev_char'] .. "', '" .. a:rule['input_char'] .. "', '" .. a:rule['output'] .. "', " .. a:rule['back_count'] ..  ")"
endfunction

"
" カスタム補完
"
function! autoclose#output_custom_completion(prev_char, input_char, output, back_count) abort
  " カーソルの前の文字
  let l:prev_char = getline('.')[col('.') - 2]
  " カーソルの前の文字が<の場合、--  -->を補完し、それ以外は!を返す
  if l:prev_char == a:prev_char
    return a:output .. repeat("\<Left>", a:back_count)
  else
    return a:input_char
  endif
endfunction