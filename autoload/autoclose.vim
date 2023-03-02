" 対の括弧を返す
function! s:reverse_bracket(bracket) abort
  let l:start_bracket = {")": "(", "}": "{", "]": "["} " 括弧
  let l:close_bracket = {"(": ")", "{": "}", "[": "]"} " 閉じ括弧

  if has_key(l:close_bracket, a:bracket) " 括弧が渡されたら閉じ括弧を返す
    return l:close_bracket[a:bracket]
  elseif has_key(l:start_bracket, a:bracket) " 閉じ括弧が渡されたら括弧を返す
    return l:start_bracket[a:bracket]
  else
    return ""
  endif
endfunction

" 閉じ括弧を補完する
function! autoclose#write_close_bracket(bracket) abort
  let l:prev_char = getline('.')[col('.') - 2] " カーソルの前の文字
  let l:next_char = getline('.')[col('.') - 1] " カーソルの次の文字
  " 以下の場合は閉じ括弧を補完しない
  " ・カーソルの次の文字がアルファベット
  " ・カーソルの次の文字が数字
  " ・カーソルの次の文字が全角
  if l:next_char =~ '\a' || l:next_char =~ '\d' || l:next_char =~ '[^\x01-\x7E]'
    return a:bracket " 括弧補完しない
  else
    return a:bracket . s:reverse_bracket(a:bracket) . "\<LEFT>" " 括弧補完
  endif
endfunction

" 閉じ括弧入力時の挙動
function! autoclose#not_double_close_bracket(close_bracket) abort
  let l:prev_char = getline('.')[col('.') - 2] " カーソルの前の文字
  let l:next_char = getline('.')[col('.') - 1] " カーソルの次の文字
  " ()と入力した場合())とせずに()で止める
  if l:next_char == a:close_bracket && l:prev_char == s:reverse_bracket(a:close_bracket)
    return "\<RIGHT>"
  else
    return a:close_bracket
  endif
endfunction

" クォーテーション補完
function! autoclose#autoclose_quot(quot) abort
  let l:prev_char = getline('.')[col('.') - 2] " カーソルの前の文字
  let l:next_char = getline('.')[col('.') - 1] " カーソルの次の文字
  " カーソルの次の文字が以下に含まれている場合にクォーテーション補完を有効にする
  let l:available_next_chars = ["", " ", ",", "$", ")", "}", "]", ">"]

  " カーソルの左右にクォーテンションがある場合は何も入力せずにカーソルを移動
  if (l:prev_char == a:quot && l:next_char == a:quot)
    return "\<RIGHT>"
  " カーソルの前の文字がクォーテーションの場合補完しない
  elseif l:prev_char == a:quot
    return a:quot
  " カーソルの次の文字が上記のl:available_next_charsに含まれている場合、クォーテーション補完する
  elseif index(l:available_next_chars, l:next_char) != -1
    return a:quot . a:quot . "\<LEFT>"
  else
    return a:quot
  endif
endfunction

" 要素内文字列から要素名を抜き出す
function! s:trim_elementname(str_line_num, str_in_tags) abort
  let l:element_name = ""
  let l:start_range = 1
  " カーソル行とタグがある行が違う場合、
  " インデントが含まれているので要素名抜き出しのスタート位置をずらす
  if a:str_line_num != line('.')
    let l:start_range = indent(a:str_line_num) + 1
  endif
  for i in range(l:start_range, strlen(a:str_in_tags))
    if a:str_in_tags[i] == " "
      break
    endif
    if a:str_in_tags[i] != "<"
      let l:element_name = l:element_name . a:str_in_tags[i]
    endif
  endfor
  return l:element_name
endfunction

" カーソルより前の一番近い要素名を取得する
function! s:find_element_name(ket) abort
  " カーソル行を検索
  let l:str_in_tag = ""
  for i in range(1, col('.'))
    let l:target_char = getline('.')[col('.') - 1 - i]
    let l:str_in_tag = l:target_char . l:str_in_tag
    if l:target_char == "<"
      break
    endif
  endfor
  " カーソル行で要素名が見つかれば要素名を返す
  if "<" == matchstr(l:str_in_tag, "<")
    return s:trim_elementname(line('.'), l:str_in_tag)
  endif
  " カーソル行で要素名が見つからなければ、上の行を見つかるまで逐次検索
  let l:str_on_line = ""
  for i in range(1, line('.') - 1)
    let l:str_on_line = getline(line('.') - i)
    if "<" == matchstr(l:str_on_line, "<")
      return s:trim_elementname(line('.') - i, l:str_on_line)
    endif
  endfor
  return a:ket
endfunction

" 閉じタグを補完する
function! autoclose#write_close_tag(ket) abort
  let l:prev_char = getline('.')[col('.') - 2] " カーソルの前の文字
  let l:void_elements = ["br", "hr", "img", "input", "link", "meta"]
  let l:not_element = ["%"]
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
    let l:cursor_transition = l:cursor_transition . "\<LEFT>" " カーソルをタグと閉じタグの中央に移動
  endfor

  if l:prev_char == "/" || l:prev_char == "-" || l:prev_char == "=" || l:prev_char == "%" || join(l:void_elements + l:not_element) =~ l:element_name || l:element_name =~ "/" || l:element_name == ""
    return a:ket
  else
    return a:ket . "</" . l:element_name . a:ket . l:cursor_transition
  endif
endfunction

" 適用するFileType
let s:enabled_autoclose_tag_filetypes = ["html", "xml", "javascript", "blade", "eruby", "vue"]
" 適用する拡張子
let s:enabled_autoclose_tag_exts = ["html", "xml", "js", "blade.php", "erb", "vue"]
" 無効化するFileType
let s:disabled_autoclose_tag_filetypes = []
" 無効化する拡張子
let s:disabled_autoclose_tag_exts = []

" vimrcの設定を反映
function! autoclose#reflect_vimrc() abort
  if exists('g:enabled_autoclose_tag_filetypes')
    let s:enabled_autoclose_tag_filetypes = s:enabled_autoclose_tag_filetypes + g:enabled_autoclose_tag_filetypes
  endif
  if exists('g:enabled_autoclose_tag_exts')
    let s:enabled_autoclose_tag_exts = s:enabled_autoclose_tag_exts + map(g:enabled_autoclose_tag_exts, 'substitute(v:val, "*.", "", "")')
  endif
  if exists('g:disabled_autoclose_tag_filetypes')
    let s:disabled_autoclose_tag_filetypes = s:disabled_autoclose_tag_filetypes + g:disabled_autoclose_tag_filetypes
  endif
  if exists('g:disabled_autoclose_tag_exts')
    let s:disabled_autoclose_tag_exts = s:disabled_autoclose_tag_exts + map(g:disabled_autoclose_tag_exts, 'substitute(v:val, "*.", "", "")')
  endif
endfunction

" 閉じタグ補完を有効化するか判定して、有効化する
function! autoclose#enable_autoclose_tag() abort
  if (index(s:disabled_autoclose_tag_filetypes, &filetype) == -1 && index(s:disabled_autoclose_tag_exts, expand('%:e')) == -1)
    \&& (index(s:enabled_autoclose_tag_filetypes, &filetype) != -1 || index(s:enabled_autoclose_tag_exts, expand('%:e')) != -1)
    " NOTE: mapの引数に<buffer>を指定することで、カレントバッファだけマップする
    inoremap <buffer> <expr> > autoclose#write_close_tag(">")
    inoremap <buffer> </ </<C-x><C-o><ESC>F<i
  endif
endfunction

" erubyの<%%>補完
function! autoclose#autoclose_eruby_tag() abort
  let l:prev_char = getline('.')[col('.') - 2] " カーソルの前の文字
  " カーソルの前の文字が<の場合、%>を補完し、それ以外は%を返す
  if l:prev_char == "<"
    return "%%>\<LEFT>\<LEFT>"
  else
    return "%"
  endif
endfunction

" erubyの<%%>補完を有効化
function! autoclose#enable_autoclose_eruby_tag() abort
  if &filetype == "eruby" || expand("%:e") == "erb"
    inoremap <buffer> <expr> % autoclose#autoclose_eruby_tag()
  endif
endfunction
