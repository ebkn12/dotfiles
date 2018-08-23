set shell=/bin/zsh

" encoding
set encoding=utf8
scriptencoding utf8
set fileencoding=utf-8
set termencoding=utf8
set fileencodings=utf-8,ucs-boms,euc-jp,ep932
set fileformats=unix,dos,mac
set ambiwidth=double " □や○文字が崩れる問題を解決
set nobomb "bomb無効化
set t_Co=256 " 256色を指定

set ttyfast " 高速ターミナル接続
set lazyredraw " 再描画を調節
set autoread " 編集中のファイルが変更されたら自動で読み直す
set hidden " バッファが編集中でもその他のファイルを開けるように
set showcmd " 入力中のコマンドをステータスに表示する
set noshowmode " モード表示しない

" ファイル作成
set nobackup " backupを作成しない
set noswapfile " swapfileを作成しない
set nowritebackup " 上書き成功時にbackup破棄
set noundofile " undofileを作成しない

" %jump
set showmatch " 括弧の対応関係を一瞬表示する
source $VIMRUNTIME/macros/matchit.vim " vimの%を拡張

" completion
set wildmenu wildmode=list:full " コマンドモードの補完
set history=1000 " 保存するコマンド履歴の数

set visualbell " ビープ音を可視化
set laststatus=2 " ステータスラインを常に表示
set wildmode=list:longest " コマンドラインの補完

" tab, indent
set expandtab " タブ入力を複数の空白入力に置き換える
set tabstop=2 " 画面上でタブ文字が占める幅
set softtabstop=2 " 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set autoindent " 改行時に前の行のインデントを継続する
set smartindent " 改行時に前の行の構文をチェックし次の行のインデントを増減する
set shiftwidth=2 " smartindentで増減する幅

" Search
set incsearch " インクリメンタルサーチ
set ignorecase " 検索パターンに大文字小文字を区別しない
set smartcase " 検索パターンに大文字を含んでいたら大文字小文字を区別する
set hlsearch " 検索結果をハイライト
set wrapscan " 検索時に最後まで行ったら最初に戻る
set wildignore+=*/tmp*,*.so,*.swp,*.zip " 検索等に含めないファイル

" cursor
set whichwrap=b,s,h,l,<,>,[,],~ " 左右移動で前後の行に移動
set virtualedit=onemore " 行末の1文字先までカーソルを移動できるように
set number " 行番号
set nocursorline " カーソルラインをハイライトしない
set nocursorcolumn " 現在の行をハイライトしない
set norelativenumber " 行番号の相対表示しない
set backspace=indent,eol,start " バックスペースキー有効化
set ruler
" 折り返し表示の際に表示行単位でカーソル移動
nnoremap j gj
nnoremap k gk
nnoremap <down> gj
nnoremap <up> gk

" insert mode kemaps like emacs
imap <C-p> <Up>
imap <C-n> <Down>
imap <C-b> <Left>
imap <C-f> <Right>
imap <C-a> <C-o>:call <SID>home()<CR>
imap <C-e> <End>
imap <C-d> <Del>
imap <C-h> <BS>
imap <C-k> <C-r>=<SID>kill()<CR>
function! s:home()
  let start_column = col('.')
  normal! ^
  if col('.') == start_column
  ¦ normal! 0
  endif
  return ''
endfunction
function! s:kill()
  let [text_before, text_after] = s:split_line()
  if len(text_after) == 0
  ¦ normal! J
  else
  ¦ call setline(line('.'), text_before)
  endif
  return ''
endfunction
function! s:split_line()
  let line_text = getline(line('.'))
  let text_after  = line_text[col('.')-1 :]
  let text_before = (col('.') > 1) ? line_text[: col('.')-2] : ''
  return [text_before, text_after]
endfunction

" clipboard
set clipboard=unnamed,autoselect

" マウス有効化
if has('mouse')
    set mouse=a
    if has('mouse_sgr')
        set ttymouse=sgr
    elseif v:version > 703 || v:version is 703 && has('patch632')
        set ttymouse=sgr
    elseif
        set ttymouse=xterm2
    endif
endif

" 全角スペースの表示
function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
endfunction
if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme * call ZenkakuSpace()
        autocmd VimEnter,WinEnter,BufRead * let w:m1=matchadd('ZenkakuSpace', '　')
    augroup END
    call ZenkakuSpace()
endif

" ペースト設定
if &term =~ "xterm"
  let &t_SI .= "\e[?2004h"
  let &t_EI .= "\e[?2004l"
  let &pastetoggle = "\e[201~"

  function XTermPasteBegin(ret)
    set paste
    return a:ret
  endfunction

  inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif

" 画面分割
nnoremap s <Nop>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap sq :<C-u>q<CR>

" make vsplit faster
if has("vim_starting") && !has('gui_running') && has('vertsplit')
  function! EnableVsplitMode()
    " enable origin mode and left/right margins
    let &t_CS = "y"
    let &t_ti = &t_ti . "\e[?6;69h"
    let &t_te = "\e[?6;69l\e[999H" . &t_te
    let &t_CV = "\e[%i%p1%d;%p2%ds"
    call writefile([ "\e[?6;69h" ], "/dev/tty", "a")
  endfunction

  " old vim does not ignore CPR
  map <special> <Esc>[3;9R <Nop>

  " new vim can't handle CPR with direct mapping
  " map <expr> ^[[3;3R EnableVsplitMode()
  set t_F9=^[[3;3R
  map <expr> <t_F9> EnableVsplitMode()
  let &t_RV .= "\e[?6;69h\e[1;3s\e[3;9H\e[6n\e[0;0s\e[?6;69l"
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim packages
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if &compatible
  set nocompatible
endif
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')
  call dein#add('~/.cache/dein')

  " load plugin settings
  let s:toml_dir=expand('~/.dein')
  let s:toml=s:toml_dir . 'dein.toml'
  let s:toml_lazy=s:toml_dir . 'dein-lazy.toml'
  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:toml_lazy, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
end

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" settings for packages
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

filetype plugin indent on " ファイルごとのindent

" autosave
let g:autosave=1

" colorscheme
if (empty($TMUX))
  if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  if (has("termguicolors"))
    set termguicolors
  endif
endif

syntax on " syntax有効化
colorscheme onedark
" molokai用設定
" colorscheme molokai
" let g:molokai_original=1
" let g:rehash256=1
set background=dark " 背景色

" lightline
let g:lightline = {
  \ 'colorscheme': 'onedark',
  \ 'active': {
  \   'left': [
  \     [ 'mode', 'paste' ],
  \     [ 'gitbranch', 'readonly', 'relativepath', 'modified']
  \   ],
  \   'right': [
  \     [ 'percent' ],
  \     [ 'linter_errors', 'linter_warnings' ],
  \     [ 'fileencoding', 'filetype' ]
  \   ]
  \ },
  \ 'inactive': {
  \   'left': [
  \     [ 'gitbranch', 'readonly', 'relativepath', 'modified' ]
  \   ],
  \   'right': [
  \     [ 'linter_errors', 'linter_warnings' ],
  \   ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'fugitive#head'
  \ },
\ }
let g:lightline.component_expand = {
  \  'linter_checking': 'lightline#ale#checking',
  \  'linter_warnings': 'lightline#ale#warnings',
  \  'linter_errors': 'lightline#ale#errors',
  \  'linter_ok': 'lightline#ale#ok',
  \ }
let g:lightline.component_type = {
  \     'linter_checking': 'left',
  \     'linter_warnings': 'warning',
  \     'linter_errors': 'error',
  \     'linter_ok': 'left',
  \ }

" NERDTree
" 自動起動設定
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
map <silent><C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1 " dotfile表示
let NERDTreeIgnore=['\.DS_Store', '\.git$', 'node_modules', 'bower_components', '__pycache__', '\.db', '\.sqlite$', '\.rbc$', '\~$', '\.pyc', '\.idea$', '\.vscode$', '\vendor\/bundle', '\.awcache$']
let g:NERDTreeDirArrows=1 " ディレクトリツリーの矢印指定
let g:NERDTreeDirArrowExpandable='▸'
let g:NERDTreeDirArrowCollapsible='▾'
" どのファイルをsyntaxhighlightするか設定
let g:NERDTreeFileExtensionHighlightFullName=1
let g:NERDTreeExactMatchHighlightFullName=1
let g:NERDTreePatternMatchHighlightFullName=1
let g:NERDTreeLimitedSyntax=1 " 遅延解消
set guifont=SauseCodePro\ Nerd\ Font\ Medium:h14
" syntax highlight
let s:brown = "905532"
let s:aqua =  "3AFFDB"
let s:blue = "689FB6"
let s:darkBlue = "44788E"
let s:purple = "834F79"
let s:lightPurple = "834F79"
let s:red = "AE403F"
let s:beige = "F5C06F"
let s:yellow = "F09F17"
let s:orange = "D4843E"
let s:darkOrange = "F16529"
let s:pink = "CB6F6F"
let s:salmon = "EE6E73"
let s:green = "8FAA54"
let s:lightGreen = "31B53E"
let s:white = "FFFFFF"
let s:rspec_red = 'FE405F'
let s:git_orange = 'F54D27'
let g:NERDTreeExtensionHighlightColor = {}
let g:NERDTreeExactMatchHighlightColor = {}
let g:NERDTreePatternMatchHighlightColor = {}
" git plugin
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }

" 補完
let g:acp_enableAtStartup=1 " 起動時に有効にするために設定
let g:neocomplete#enable_at_startup=1 " vim起動時に有効にする
let g:neocomplete#enable_smart_case=1 " 大文字が入力されるまで大文字小文字区別しない
let g:neocomplete#sources#syntax#min_keyword_length=2 " 2文字以上の単語に対して保管する
let g:neocomplete#enable_underbar_completion=1 " アンダーバー有効化
let g:neocomplete#enable_camel_case_completion=1 " キャメルケース有効化
let g:neocomplete#enable_auto_delimiter=1 " 区切り文字を含める
let g:neocomplete#auto_completion_start_length=2 " 2文字目から開始
let g:neocomplete#max_list=15 " 表示数
" dictionary設定
let g:neocomplete#sources#dictionary#dictionaries={
  \ 'default': '',
  \ 'vimshell': $HOME.'/.vimshell_hist',
  \ 'scheme': $HOME.'/.gosh_completions'
\ }
" keyword設定
if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns={}
endif
let g:neocomplete#keyword_patterns['default']='\h\w*'
" keymap
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" Close popup by <Space>.
" inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" neosnippet呼び出し
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)
smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
" タブキーで補完候補の選択. スニペット内のジャンプもタブキーでジャンプ
imap <expr><TAB> pumvisible() ? "<C-n>" : neosnippet#jumpable() ? "<Plug>(neosnippet_expand_or_jump)" : "<TAB>"
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif
let g:neosnippet#snippets_directory='~/.vim/bundle/neosnippet-snippets/snippets/' " 補完のディレクトリ指定

" fzf設定
map <C-t> :Files<CR>
let g:fzf_layout = { 'down': '~40%' }
let g:fzf_buffers_jump=1

" grepper設定
map <C-g> :Grepper -tool ag -highlight<CR>

" ale設定
let g:ale_lint_on_enter=1
let g:ale_lint_on_save=1
let g:ale_lint_on_text_changed=0
let g:ale_sign_column_always=1 " 左にずれるのを防止
let g:ale_linters = {
  \ 'html': [],
  \ 'css': ['stylelint'],
  \ 'javascript': ['eslint', 'flow'],
  \ 'json': ['jsonlint'],
  \ 'ruby': ['rubocop'],
  \ 'go': ['goimports'],
  \ 'haml': ['haml-lint'],
  \ 'sass': ['sass-lint'],
  \ 'scss': ['sass-lint'],
  \ 'swift': ['swiftlint'],
  \ 'typescript': ['tslint', 'tsserver'],
  \ 'vim': ['vint'],
  \ 'yaml': ['yamllint'],
  \ }
let g:ale_sign_error='E'
let g:ale_sign_warning='W'
let g:ale_echo_msg_error_str='E'
let g:ale_echo_msg_warning_str='W'
let g:ale_echo_msg_format='[%linter%] %s (%severity%)'
let g:ale_statusline_format=['E %d', 'W %d', '']
let g:ale_open_list=1
let g:ale_set_loclist=0
let g:ale_set_quickfix=1 " QuickFix使用
let g:ale_keep_list_window_open=0

" vim-typescript 設定
autocmd FileType typescript :set makeprg=tsc

" gitgutter設定
let g:gitgutter_async=1

" caw.vim設定
nmap <C-c> <Plug>(caw:i:toggle)
vmap <C-c> <Plug>(caw:i:toggle)

" html autoclose設定
let g:closetag_filenames='*.html,*.xhtml,*.phtml'
let g:closetag_xhtml_filenames='*.xhtml,*.jsx,*.tsx'
let g:closetag_emptyTags_caseSensitive=1
let g:closetag_shortcut='>' " >を押すと自動で閉じる
let g:closetag_close_shortcat='<leader>>'

" emmet
let g:user_emmet_leader_key='<C-e>'

" vim-processing設定
let g:processing_fold=1

" vim-markdown設定
let g:vim_markdown_folding_disabled=0
