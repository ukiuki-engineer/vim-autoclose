# vim-autoclose
This plugin automatically closes parentheses, brackets, quotes, and other paired characters in Vim.

## features
- Automatically completes closing parentheses, brackets, and quotes
- Completes closing tags when typing `>` or `</` for HTML
- Completes `<%%>` in eruby
- Provides smart control over completion, so it doesn't interfere when you don't want it to. For example:
  - Doesn't automatically complete the closing character if you already typed both (e.g., `()` won't become `())`)
  - Does not automatically complete closing tags for **void elements** such as `<br>`, `<hr>`, `<img>`, `<input>`, `<link>`, `<meta>`
  - Does not automatically complete the closing > character if not in the context of an HTML tag (e.g., `=>` or `->`)

## Demo
https://user-images.githubusercontent.com/101523180/207311455-5a2b63f4-6102-4607-b9f7-26e07552c7b8.mov

https://user-images.githubusercontent.com/101523180/207350557-5c52c90d-a058-45f1-b226-2dded5c428a4.mov

## Installation
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

- erubyの<%%>補完を無効化
```vim
let g:enableAutoCloseErubyTag = 0
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
