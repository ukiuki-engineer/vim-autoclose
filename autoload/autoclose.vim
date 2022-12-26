" 対の括弧を返す
function! autoclose#ReverseBracket(bracket) abort
  let l:startBracket = {")": "(", "}": "{", "]": "["} " 括弧
  let l:closeBracket = {"(": ")", "{": "}", "[": "]"} " 閉じ括弧

  if has_key(l:closeBracket, a:bracket) " 括弧が渡されたら閉じ括弧を返す
    return l:closeBracket[a:bracket]
  elseif has_key(l:startBracket, a:bracket) " 閉じ括弧が渡されたら括弧を返す
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
    return a:bracket " 括弧補完しない
  else
    return a:bracket . autoclose#ReverseBracket(a:bracket) . "\<LEFT>" " 括弧補完
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

" クォーテーション補完
function! autoclose#AutoCloseQuot(quot)
  let l:prevChar = getline('.')[charcol('.') - 2] " カーソルの前の文字
  let l:nextChar = getline('.')[charcol('.') - 1] " カーソルの次の文字
  " カーソルの次の文字が以下に含まれている場合にクォーテーション補完を有効にする
  let l:availableNextChars = ["", " ", ",", "$", ")", "}", "]", ">"]

  if (l:prevChar == a:quot && l:nextChar == a:quot) " カーソルの左右にクォーテンションがある場合は何も入力せずにカーソルを移動
    return "\<RIGHT>"
  " 以下の場合はクォーテーション補完を行わない
  " ・カーソルの前の文字がアルファベット
  " ・カーソルの前の文字が数字
  " ・カーソルの前の文字が全角
  " ・カーソルの前の文字がクォーテーション
  elseif l:prevChar =~ "\a" || l:prevChar =~ "\d" || l:prevChar =~ "[^\x01-\x7E]" || l:prevChar == a:quot
    return a:quot
  " カーソルの次の文字が上記のl:availableNextCharsに含まれている場合、クォーテーション補完する
  elseif l:availableNextChars->count(l:nextChar) == 1
    return a:quot . a:quot . "\<LEFT>"
  else
    return a:quot
  endif
endfunction
