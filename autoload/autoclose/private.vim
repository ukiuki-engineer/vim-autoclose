" ------------------------------------------------------------------------------
" private
" ------------------------------------------------------------------------------
" カーソルの次の文字が以下にマッチする場合は括弧、クォーテーション補完を無効にする(デフォルト)
" ・カーソルの次の文字がアルファベット
" ・カーソルの次の文字が数字
" ・カーソルの次の文字が全角
let s:disable_nextpattern_autoclosing_brackets = [
  \'\a',
  \'\d',
  \'[^\x01-\x7E]'
\]
let s:disable_nextpattern_autoclosing_quots = [
  \'\a',
  \'\d',
  \'[^\x01-\x7E]'
\]
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
    \"]": "[",
    \">": "<"
  \}
  " 閉じ括弧
  let l:close_bracket = {
    \"(": ")",
    \"{": "}",
    \"[": "]",
    \"<": ">"
  \}

  " 括弧が渡されたら閉じ括弧を返す
  if has_key(l:close_bracket, a:bracket)
    return l:close_bracket[a:bracket]
  " 閉じ括弧が渡されたら括弧を返す
  elseif has_key(l:start_bracket, a:bracket)
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

"
" 閉じタグ補完のmapping
"
function! s:mapping_autoclose_tags() abort
  " バッファローカルにマップする
  inoremap <buffer> <expr> > autoclose#write_close_tag(">")
  inoremap <buffer> </ </<C-x><C-o><ESC>F<i
endfunction