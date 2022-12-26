" 対の括弧を返す
function! ReverseBracket(bracket) abort
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
    return a:bracket . ReverseBracket(a:bracket) . "\<LEFT>" " 括弧補完
  endif
endfunction

" 閉じ括弧入力時の挙動
function! autoclose#NotDoubleCloseBracket(closeBracket) abort
  let l:prevChar = getline('.')[charcol('.') - 2] " カーソルの前の文字
  let l:nextChar = getline('.')[charcol('.') - 1] " カーソルの次の文字
  " ()と入力した場合())とせずに()で止める
  if l:nextChar == a:closeBracket && l:prevChar == ReverseBracket(a:closeBracket)
    return "\<RIGHT>"
  else
    return a:closeBracket
  endif
endfunction

" クォーテーション補完
function! autoclose#AutoCloseQuot(quot) abort
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

" 要素内文字列から要素名を抜き出す
function! TrimElementName(strLineNum, strInTag) abort
  let l:elementName = ""
  let l:startRange = 1
  " カーソル行とタグがある行が違う場合、
  " インデントが含まれているので要素名抜き出しのスタート位置をずらす
  if a:strLineNum != line('.')
    let l:startRange = indent(a:strLineNum) + 1
  endif
  for i in range(l:startRange, strlen(a:strInTag))
    if a:strInTag[i] == " "
      break
    endif
    if a:strInTag[i] != "<"
      let l:elementName = l:elementName . a:strInTag[i]
    endif
  endfor
  return l:elementName
endfunction

" カーソルより前の一番近い要素名を取得する
function! FindElementName(ket) abort
  " カーソル行を検索
  let l:strInTag = ""
  for i in range(1, charcol('.'))
    let l:targetChar = getline('.')[charcol('.') - 1 - i]
    let l:strInTag = l:targetChar . l:strInTag
    echo l:strInTag
    if l:targetChar == "<"
      break
    endif
  endfor
  if "<" == matchstr(l:strInTag, "<")
    return TrimElementName(line('.'), l:strInTag)
  endif
  " カーソルより上の行を検索
  let l:strOnLine = ""
  for i in range(1, line('.') - 1)
    let l:strOnLine = getline(line('.') - i)
    if "<" == matchstr(l:strOnLine, "<")
      return TrimElementName(line('.') - i, l:strOnLine)
    endif
  endfor
  return a:ket
endfunction

" 閉じタグを補完する
function! WriteCloseTag(ket) abort
  let l:prevChar = getline('.')[charcol('.') - 2] " カーソルの前の文字
  let l:voidElements = ["br", "hr", "img", "input", "link", "meta"]
  " 以下の場合は閉じタグ補完を行わない
  " ・/>で閉じる場合
  " ・->と入力した場合
  " ・=>と入力した場合
  " ・上記のl:voidElementsに含まれる要素
  " ・l:elementNameに/が含まれる場合
  " ・l:elementNameが空白の場合
  let l:elementName = FindElementName(a:ket)
  if l:prevChar == "/" || l:prevChar == "-" || l:prevChar == "=" || l:voidElements->count(l:elementName) == 1 || l:elementName =~ "/" || l:elementName == ""
    return a:ket
  else
    return a:ket . "</" . l:elementName . a:ket . "\<ESC>F<i"
  endif
endfunction

" 適用するFileType
let s:enabledAutoCloseTagFileTypes = ["html", "xml", "javascript", "blade", "eruby", "vue"]
" 適用する拡張子
let s:enabledAutoCloseTagExtensions = ["html", "xml", "js", "blade.php", "erb", "vue"]

" vimrcの設定を反映
function! autoclose#ReflectVimrc() abort
  if exists('g:enabledAutoCloseTagFileTypes')
    let s:enabledAutoCloseTagFileTypes = s:enabledAutoCloseTagFileTypes + g:enabledAutoCloseTagFileTypes
  endif
  if exists('g:enabledAutoCloseTagExtensions')
    let s:enabledAutoCloseTagExtensions = s:enabledAutoCloseTagExtensions + g:enabledAutoCloseTagExtensions
  endif
endfunction

" 閉じタグ補完を有効化するか判定して、有効化する
function! autoclose#EnableAutoCloseTag() abort
  if s:enabledAutoCloseTagFileTypes->count(&filetype) == 1 || s:enabledAutoCloseTagExtensions->count(expand("%:e")) == 1
    " memo: mapの引数に<buffer>を指定することで、カレントバッファだけマップする
    inoremap <buffer> <expr> > WriteCloseTag(">")
    inoremap <buffer> </ </<C-x><C-o><ESC>F<i
  endif
endfunction
