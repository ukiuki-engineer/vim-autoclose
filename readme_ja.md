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
" 例)vim-plugの場合
Plug 'ukiuki-engineer/vim-autoclose'
```
#### 手動
`.vim/pack/plugins/start`というディレクトリを作成し、そこにこのプラグインを配置する
```
mkdir -p ~/.vim/pack/plugins/start
cd ~/.vim/pack/plugins/start
git clone https://github.com/ukiuki-engineer/vim-autoclose
```

## デフォルト設定
基本的に何も設定せずに動作します。
デフォルト設定は以下のようになっています。
- 括弧補完             →有効
- クォーテーション補完 →有効
- タグ補完             →有効
- タグ補完が有効なファイルの種類  
→
```
FileTypes(ファイルタイプ): html, javascript, blade, vue
Extensions(拡張子): *.html, *.js, *.blade.php, *.erb, *.vue
```

## 設定
- 括弧補完無効化  
vimrcに以下を追記
```vim
let g:autoclose#autoclosing_brackets_enable = 0
```
- クォーテーション補完無効化  
vimrcに以下を追記
```vim
let g:autoclose#autoclosing_quots_enable = 0
```
- タグ補完無効化  
vimrcに以下を追記
```vim
let g:autoclose#autoclosing_tags_enable = 0
```

- erubyの<%%>補完を無効化
```vim
let g:autoclose#autoclosing_eruby_tags = 0
```

- タグ補完を適用するファイルタイプ、拡張子を設定  
vimrcに以下を追記します。
```vim
" FileTypes(default)
let g:autoclose#enabled_autoclosing_tags_filetypes = [
  \"html",
  \"xml",
  \"javascript",
  \"blade",
  \"eruby",
  \"vue"
\]
" extension(default)
let g:autoclose#enabled_autoclosing_tags_exts = [
  \"*.html",
  \"*.xml",
  \"*.js",
  \"*.blade.php",
  \"*.erb",
  \"*.vue"
\]
```
上記はデフォルト設定です。  
何も設定しなければ、デフォルトで上記設定が適用されます。

- 補完キャンセル機能  
補完したくない場合、補完をキャンセルする事ができます。この機能は、デフォルトではオフになっています。  
補完が行われた後、キャンセル機能を呼び出すと、補完された文字列が削除され、入力した文字列のみが残ります。  
補完機能を`<C-c>`に割り当てた場合、以下のように振る舞います。
```vim
"|"-><C-c>→"
" |"-><C-c>→" 
```
ここで、`|`はカーソル位置です。  
この機能を使用するには、vimrcに以下を追記します。
```vim
"Enable cancel feature
let g:autoclose#cancel_completion_enable = 1
"Key mapping for cancel feature
inoremap <expr> <C-c> autoclose#is_completion() ? autoclose#cancel_completion() : "\<Esc>"
```

## TODO
- 括弧、クォーテーション補完の制御をユーザーが定義できるように  
現状、括弧、クォーテーション補完はプラグイン側で以下のように制御されている。  
→以下の場合は閉じ括弧を補完しない
  - カーソルの次の文字がアルファベット
  - カーソルの次の文字が数字  

  これを、vimrc側で細かく設定できるようにする。
- VSCodeのような改行をオプションで追加する  
これは以前実装していたが、今は消している。これをオプションとして使用できるようにする。
```
{|}
{
  |
}
```
