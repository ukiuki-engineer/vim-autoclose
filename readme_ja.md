# vim-autoclose
括弧、クォーテーション、htmlのタグを閉じる補完を良い感じに行うプラグイン。

## features
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
let g:enableAutoCloseBrackets = 0
```
- クォーテーション補完無効化  
vimrcに以下を追記
```vim
let g:enableAutoCloseQuots = 0
```
- タグ補完無効化  
vimrcに以下を追記
```vim
let g:enableAutoCloseTags = 0
```

- erubyの<%%>補完を無効化
```vim
let g:enableAutoCloseErubyTag = 0
```

- タグ補完を適用するファイルタイプ、拡張子を追加  
vimrcに以下を追記
```vim
" ex)
let g:enabledAutoCloseTagFileTypes = ["markdown", "php"]    " FileType
let g:enabledAutoCloseTagExts = ["*.md", "*.php"]           " extension
```

- タグ補完を適用**しない**ファイルタイプ、拡張子を追加  
vimrcに以下を追記します
```vim
" ex)
let g:disabledAutoCloseTagFileTypes = ["javascript", "php"] " FileType
let g:disabledAutoCloseTagExts = ["*.js", "*.php"]          " extension
```
