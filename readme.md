## 概要
括弧、クォーテーション、htmlのタグを閉じる補完を良い感じに行うプラグイン。

## 背景
括弧やクォーテーションを閉じる設定として、以下がよく知られている。
```
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
```

上記設定では、色々不便な点がある。  
```())```となってしまったり、括弧を閉じたくない時に閉じてしまったり...  
このプラグインでは、上記補完をもっといい感じに発火するように色々と制御しています。  
加えて、htmlの閉じタグ補完機能も実装しています。  
全体的に大体VSCodeのような動きをイメージして実装しました。

https://user-images.githubusercontent.com/101523180/207311455-5a2b63f4-6102-4607-b9f7-26e07552c7b8.mov

https://user-images.githubusercontent.com/101523180/207350557-5c52c90d-a058-45f1-b226-2dded5c428a4.mov


## 機能
- 閉じ括弧の補完
- 閉じクォーテーションの補完
- 閉じタグの補完  
→以下を入力した場合に閉じタグが補完される  
```>```or```</```
- 補完をいい感じに制御
→補完してほしくない時は無効になるようにいい感じに制御してある。
例えば以下ように制御してある。(全部を書くと多いので一部だけです)
  - ```()```と入力しても```())```とならないように
  - いわゆる**void要素**(以下)は閉じタグを補完しない  
  →```<br>```, ```<hr>```, ```<img>```, ```<input>```, ```<link>```, ```<meta>```
  - タグじゃない場合の>は補完をしない  
  →```=>```とか、```->```とか

## インストール方法
#### プラグインマネージャ経由
お好みのプラグインマネージャで'ukiuki-engineer/vim-autoclose'を追加してください。  
```vim
" 例)vim-plugの場合
Plug 'ukiuki-engineer/vim-autoclose'
```
#### 手動
```.vim/pack/plugins/start```というディレクトリを作成し、そこにこのプラグインを配置する
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

- タグ補完を適用するファイルの種類を追加  
vimrcに以下を追記
```vim
" ex)
let g:enabledAutoCloseTagFileTypes = ["vim", "php"]         " FileType
let g:enabledAutoCloseTagExtensions = ["vim", "php"]        " extension
```

- タグ補完を適用**しない**ファイルの種類を追加  
vimrcに以下を追記します
```vim
" ex)
let g:disabledAutoCloseTagFileTypes = ["javascript", "php"] " FileType
let g:disabledAutoCloseTagExtensions = ["js", "php"]        " extension
```
