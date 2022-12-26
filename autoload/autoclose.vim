" 対の括弧を返す
function! autoclose#ReverseBracket(bracket) abort
 " 括弧
  let l:startBracket = {")": "(", "}": "{", "]": "["}
 " 閉じ括弧
  let l:closeBracket = {"(": ")", "{": "}", "[": "]"}
  " 括弧が渡されたら閉じ括弧を返す
  if has_key(l:closeBracket, a:bracket)
    return l:closeBracket[a:bracket]
  " 閉じ括弧が渡されたら括弧を返す
  elseif has_key(l:startBracket, a:bracket)
    return l:startBracket[a:bracket]
  else
    return ""
  endif
endfunction

" 閉じ括弧を補完する
" FIXME: 補完した操作を、.で繰り返すことができない
function! autoclose#WriteCloseBracket(bracket) abort
  let l:prevChar = getline('.')[charcol('.') - 2] " カーソルの前の文字
  let l:nextChar = getline('.')[charcol('.') - 1] " カーソルの次の文字

  " 以下の場合は閉じ括弧を補完しない
  " ・カーソルの次の文字がアルファベット
  " ・カーソルの次の文字が数字
  " ・カーソルの次の文字が全角
  if l:nextChar =~ '\a' || l:nextChar =~ '\d' || l:nextChar =~ '[^\x01-\x7E]'
    " 括弧補完しない
    return a:bracket
  else
    " 括弧補完
    return a:bracket . autoclose#ReverseBracket(a:bracket) . "\<LEFT>"
  endif
endfunction

" 閉じ括弧入力時の挙動
function! autoclose#NotDoubleCloseBracket(closeBracket) abort
  let l:prevChar = getline('.')[charcol('.') - 2] " カーソルの前の文字
  let l:nextChar = getline('.')[charcol('.') - 1] " カーソルの次の文字
  " ()と入力した場合())とせずに()で止める
  if l:nextChar == a:closeBracket && l:prevChar == autoclose#ReverseBracket(a:closeBracket)
    return "\<RIGHT>"
  else
    return a:closeBracket
  endif
endfunction
