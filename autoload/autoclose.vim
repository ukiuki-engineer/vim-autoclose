"
" 閉じ括弧補完
"
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
    " キャンセル機能が有効な場合は、補完状態を保存する
    if exists('g:autoclose#cancel_completion_enable') && g:autoclose#cancel_completion_enable == 1
      call s:save_completion_strings(a:bracket, s:reverse_bracket(a:bracket))
    endif
    " NOTE: <C-g>Uは、undoの単位の分割をしないという意味
    "       カーソル移動するとundoの単位が分割されるため、<C-g>Uでそれを防ぐ
    "       ※<C-g>uは、undoの単位の分割。その時点で<Esc>したのと同じことになる。
    return a:bracket . s:reverse_bracket(a:bracket) . "\<C-g>U\<Left>" " 括弧補完
  endif
endfunction

"
" 閉じ括弧入力時の挙動
"
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

"
" クォーテーション補完
"
function! autoclose#autoclose_quot(quot) abort
  let l:prev_char = getline('.')[col('.') - 2] " カーソルの前の文字
  let l:next_char = getline('.')[col('.') - 1] " カーソルの次の文字

  " カーソルの左右にクォーテンションがある場合は何も入力せずにカーソルを移動
  if l:prev_char == a:quot && l:next_char == a:quot
    return "\<RIGHT>"
  " 以下の場合は補完しない
  " ・カーソルの前の文字が(入力されたのと同じ)クォーテーション
  " ・カーソルの次の文字がアルファベット
  " ・カーソルの次の文字が数字
  " ・カーソルの次の文字が全角
  elseif l:prev_char == a:quot || l:next_char =~ '\a' || l:next_char =~ '\d' || l:next_char =~ '[^\x01-\x7E]'
    return a:quot
  " それ以外は補完する
  else
    " キャンセル機能が有効な場合は、補完状態を保存する
    if exists('g:autoclose#cancel_completion_enable') && g:autoclose#cancel_completion_enable == 1
      call s:save_completion_strings(a:quot, a:quot)
    endif
    return a:quot . a:quot . "\<Left>"
  endif
endfunction

"
" 閉じタグ補完
"
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
    let l:cursor_transition = l:cursor_transition . "\<C-g>U\<Left>" " カーソルをタグと閉じタグの中央に移動
  endfor

  if l:prev_char == "/" || l:prev_char == "-" || l:prev_char == "=" || l:prev_char == "%" || join(l:void_elements + l:not_element) =~ l:element_name || l:element_name =~ "/" || l:element_name == ""
    return a:ket
  else
    " キャンセル機能が有効な場合は、補完状態を保存する
    if exists('g:autoclose#cancel_completion_enable') && g:autoclose#cancel_completion_enable == 1
      call s:save_completion_strings(a:ket, "</" . l:element_name . a:ket)
    endif
    return a:ket . "</" . l:element_name . a:ket . l:cursor_transition
  endif
endfunction

"
" vimrcの設定を反映
"
function! autoclose#reflect_vimrc() abort
  " 設定されていなければデフォルト値を設定
  if !exists('g:autoclose#autoclosing_brackets_enable')
    let g:autoclose#autoclosing_brackets_enable = 1
  endif
  if !exists('g:autoclose#autoclosing_quots_enable')
    let g:autoclose#autoclosing_quots_enable = 1
  endif
  if !exists('g:autoclose#autoclosing_tags_enable')
    let g:autoclose#autoclosing_tags_enable = 1
  endif
  if !exists('g:autoclose#autoclosing_eruby_tags')
    let g:autoclose#autoclosing_eruby_tags = 1
  endif
  " 設定されていればデフォルト値を上書き
  if exists('g:autoclose#enabled_autoclosing_tags_filetypes')
    let s:enabled_autoclosing_tags_filetypes = g:autoclose#enabled_autoclosing_tags_filetypes
  endif
  if exists('g:autoclose#enabled_autoclosing_tags_exts')
    let s:enabled_autoclosing_tags_exts =  map(g:autoclose#enabled_autoclosing_tags_exts, 'substitute(v:val, "*.", "", "")')
  endif
endfunction

"
" 閉じタグ補完を有効化するか判定して、有効化する
"
function! autoclose#enable_autoclose_tag() abort
  if index(s:enabled_autoclosing_tags_filetypes, &filetype) != -1 || index(s:enabled_autoclosing_tags_exts, expand('%:e')) != -1
    " NOTE: mapの引数に<buffer>を指定することで、カレントバッファだけマップする
    inoremap <buffer> <expr> > autoclose#write_close_tag(">")
    inoremap <buffer> </ </<C-x><C-o><ESC>F<i
  endif
endfunction

"
" erubyの<%%>補完
"
function! autoclose#autoclose_eruby_tag() abort
  let l:prev_char = getline('.')[col('.') - 2] " カーソルの前の文字
  " カーソルの前の文字が<の場合、%>を補完し、それ以外は%を返す
  if l:prev_char == "<"
    " キャンセル機能が有効な場合は、補完状態を保存する
    if exists('g:autoclose#cancel_completion_enable') && g:autoclose#cancel_completion_enable == 1
      call s:save_completion_strings("<%", "%>")
    endif
    return "%%>\<Left>\<Left>"
  else
    return "%"
  endif
endfunction

"
" erubyの<%%>補完を有効化
"
function! autoclose#enable_autoclose_eruby_tag() abort
  if &filetype == "eruby" || expand("%:e") == "erb"
    inoremap <buffer> <expr> % autoclose#autoclose_eruby_tag()
  endif
endfunction

"
" 補完をキャンセル
"
function! autoclose#cancel_completion() abort
  " FIXME: A"<C-c>などもドットで繰り返せるように
  if exists('g:autoclose#cancel_completion_enable') && g:autoclose#cancel_completion_enable == 1
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
    " 補完の後何か文字が入力された場合
    else
      return "\<Esc>" . "F" . l:trigger . "\"zdt" . l:completed[0] . "x\"zp"
    endif
  else
    return "\<Esc>"
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

" ------------------------------------------------------------------------------
" private
" ------------------------------------------------------------------------------
" 適用するFileType(デフォルト)
let s:enabled_autoclosing_tags_filetypes = [
  \"html",
  \"xml",
  \"javascript",
  \"blade",
  \"eruby",
  \"vue"
\]
" 適用する拡張子(デフォルト)
let s:enabled_autoclosing_tags_exts = [
  \"html",
  \"xml",
  \"js",
  \"blade.php",
  \"erb",
  \"vue"
\]

"
" 対の括弧を返す
"
function! s:reverse_bracket(bracket) abort
  " 括弧
  let l:start_bracket = {
    \")": "(",
    \"}": "{",
    \"]": "["
  \}
  " 閉じ括弧
  let l:close_bracket = {
    \"(": ")",
    \"{": "}",
    \"[": "]"
  \}

  if has_key(l:close_bracket, a:bracket) " 括弧が渡されたら閉じ括弧を返す
    return l:close_bracket[a:bracket]
  elseif has_key(l:start_bracket, a:bracket) " 閉じ括弧が渡されたら括弧を返す
    return l:start_bracket[a:bracket]
  else
    return ""
  endif
endfunction

"
" 要素内文字列から要素名を抜き出す
"
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

"
" カーソルより前の一番近い要素名を取得する
"
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

"
" 補完トリガーの文字列と、補完された文字列を保存
"
function! s:save_completion_strings(trigger_str, completed_str) abort
  let g:autoclose#completion_strings = {
    \"trigger": a:trigger_str,
    \"completed": a:completed_str
  \}
  " 保存文字列のクリア処理
  augroup autocloseClearSavedCompletionStrings
    au!
    execute 'au InsertLeave * ++once unlet g:autoclose#completion_strings'
  augroup END
endfunction
