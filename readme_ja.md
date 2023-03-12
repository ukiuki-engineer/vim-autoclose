# vim-autoclose
括弧、クォーテーション、htmlのタグを閉じる補完を良い感じに行うプラグイン。

## Features
- 閉じ括弧の補完
- 閉じクォーテーションの補完
- 閉じタグの補完  
→以下を入力した場合に閉じタグが補完される  
`>`or`</`
- erubyの<%%>を補完
- 補完をいい感じに制御
→補完してほしくない時は無効になるようにいい感じに制御してある。
例えば以下ように制御してある。(全部を書くと多いので一部だけです)
  - `()`と入力しても`())`とならないように
  - いわゆる**void要素**(以下)は閉じタグを補完しない  
  →`<br>`, `<hr>`, `<img>`, `<input>`, `<link>`, `<meta>`
  - タグじゃない場合の>は補完をしない  
  →`=>`とか、`->`とか

## デモ
https://user-images.githubusercontent.com/101523180/207311455-5a2b63f4-6102-4607-b9f7-26e07552c7b8.mov

https://user-images.githubusercontent.com/101523180/207350557-5c52c90d-a058-45f1-b226-2dded5c428a4.mov

## インストール方法
#### プラグインマネージャ経由
お好みのプラグインマネージャで'ukiuki-engineer/vim-autoclose'を追加してください。  
```vim
" ex) vim-plugの場合
Plug 'ukiuki-engineer/vim-autoclose'
```
#### 手動
`.vim/pack/plugins/start`というディレクトリを作成し、そこにこのプラグインを配置する
```
mkdir -p ~/.vim/pack/plugins/start
cd ~/.vim/pack/plugins/start
git clone https://github.com/ukiuki-engineer/vim-autoclose
```

## 使い方
基本的に何も設定せずに動作します。

## 設定
- 括弧補完無効化  
Default: `1`
```vim
let g:autoclose#autoclosing_brackets_enable = 0
```
- クォーテーション補完無効化  
Default: `1`
```vim
let g:autoclose#autoclosing_quots_enable = 0
```
- タグ補完無効化  
Default: `1`
```vim
let g:autoclose#autoclosing_tags_enable = 0
```
- erubyの<%%>補完を無効化
Default: `1`
```vim
let g:autoclose#autoclosing_eruby_tags = 0
```
- 括弧補完、クォーテーションを無効にするカーソルの次の文字(pattern)の設定
デフォルトでは以下が設定されています。  
Default\*: `['\a', '\d', '[^\x01-\x7E]']`  
\*`\a`: アルファベット  
\*`\d`: 数字  
\*`[^\x01-\x7E]`: 全角文字  
\*設定可能なパターンは他にもあります。詳しくは、`:h pattern`を参照してください。  
カーソルの次の文字が上記の該当した場合、括弧補完されません。  
この設定を変更するには、vimrcに以下を追記します。
```vim
" ex) 行末を追加
let g:autoclose#disable_nextpattern_autoclosing_brackets = [
  \'\a',
  \'\d',
  \'[^\x01-\x7E]',
  \'$'
\]
let g:autoclose#disable_nextpattern_autoclosing_quots = [
  \'\a',
  \'\d',
  \'[^\x01-\x7E]',
  \'$'
\]
```
- タグ補完を適用するファイルタイプ  
Default: `["html", "xml", "javascript", "blade", "eruby", "vue"]`
```vim
" ex) "markdown"を追加
let g:autoclose#enabled_autoclosing_tags_filetypes = [
  \"html",
  \"xml",
  \"javascript",
  \"blade",
  \"eruby",
  \"vue",
  \"markdown"
\]
````
- タグ補完を適用する拡張子  
Default: `["*.html", "*.xml", "*.javascript", "*.blade", "*.eruby", "*.vue"]`
```vim
" ex) "*.md"を追加
let g:autoclose#enabled_autoclosing_tags_exts = [
  \"*.html",
  \"*.xml",
  \"*.js",
  \"*.blade.php",
  \"*.erb",
  \"*.vue",
  \"*.md"
\]
```
- 改行の自動整形機能  
括弧、クォーテーション、htmlタグの改行を自動整形します。  
例:
```
{|}
{
  |
}
<div>|<div>
<div>
  |
<div>
```
この機能はデフォルトでオンになっています。
Default: `1`
```vim
" on(dafault)
let g:autoclose#autoformat_new_line_enable = 1
" off
let g:autoclose#autoformat_new_line_enable = 0
```
- 補完キャンセル機能  
補完したくない場合、補完をキャンセルする事ができます。この機能は、デフォルトではオフになっています。  
補完が行われた後、キャンセル機能を呼び出すと、補完された文字列が削除され、入力した文字列のみが残ります。  
補完機能を`<C-c>`に割り当てた場合、以下のように振る舞います。
```vim
"|"-><C-c>→"
" |"-><C-c>→" 
```
ここで、`|`はカーソル位置です。  

https://user-images.githubusercontent.com/101523180/224526079-97927c75-4034-4f82-bab1-0091fd444dad.mov

この機能を使用するには、vimrcに以下を追記します。
```vim
"Enable cancel feature
let g:autoclose#cancel_completion_enable = 1 " Default: 0
"Key mapping for cancel feature
inoremap <expr> <C-c> autoclose#is_completion() ? autoclose#cancel_completion() : "\<Esc>"
```

## TODO
- 補完しないタグを設定できるようにする
  現状、いわゆる**void要素**(以下)は閉じタグを補完しない  
  →`<br>`, `<hr>`, `<img>`, `<input>`, `<link>`, `<meta>`  
  これらを、vimrcで指定できるようにする。
