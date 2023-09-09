"
" 閉じタグ補完
"
function! autoclose#write_close_tag(ket) abort
  " カーソルの前の文字
  let l:prev_char = getline('.')[col('.') - 2]
  let l:disable_elements = ["br", "hr", "img", "input", "link", "meta", "%"]
  " 以下の場合は閉じタグ補完を行わない
  " ・/>で閉じる場合
  " ・->と入力した場合
  " ・=>と入力した場合
  " ・%>と入力した場合
  " ・上記のl:void_elements,l:not_elementに含まれる要素
  " ・l:element_nameに/が含まれる場合
  " ・l:element_nameが空白の場合
  let l:element_name = s:find_element_name(a:ket)
  let l:cursor_transition =""
  for i in range(1, strlen(l:element_name) + 3)
    " カーソルをタグと閉じタグの中央に移動
    let l:cursor_transition = l:cursor_transition . "\<C-g>U\<Left>"
  endfor

  if l:prev_char == "/" || l:prev_char == "-" || l:prev_char == "=" || l:prev_char == "%" || index(l:disable_elements, l:element_name) != -1 || l:element_name =~ "/" || l:element_name == ""
    return a:ket
  else
    " キャンセル機能が有効な場合は、補完状態を保存する
    if g:autoclose#cancel_completion_enable == 1
      call s:save_completion_strings(a:ket, "</" . l:element_name . a:ket)
    endif
    return a:ket . "</" . l:element_name . a:ket . l:cursor_transition
  endif
endfunction

"
" 閉じタグ補完のmappingを呼ぶ
"
function! autoclose#enable_autoclose_tag() abort
  let filetypes = join(s:enabled_autoclosing_tags_filetypes, ',')
  execute "augroup autocloseTag | au! | au FileType " . filetypes . " call s:mapping_autoclose_tags() | augroup EMD"
endfunction