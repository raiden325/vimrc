"**************************************************
"* Vim Environment {{{
"**************************************************
scriptencoding utf-8
if &compatible==1
	set nocompatible
endif
set foldmethod=marker
set cmdheight=2
set ignorecase
set smartcase
set tabstop=4
set shiftwidth=4
set history=1000
set noexpandtab
set autoindent
set backspace=indent,eol,start
set wrapscan
set noshowmatch
set wildmenu
set nonumber
set ruler
if has('win32') || has('win64')
	set list listchars=tab:>-,trail:-,eol:@
elseif has('unix')
	set list listchars=tab:>-,trail:-,eol:↲
endif
set nrformats-=octal
set nowrap
set laststatus=2
set showcmd
set noswapfile
set nobackup
set nohlsearch
set cinoptions=>4
set visualbell
set incsearch
set isprint=@,~-247,249-255
set tags=./tags,tags,../tags
set diffopt=filler,iwhite
set helplang=ja,en
"**************************************************
" }}}
"**************************************************

" ignore bram's example script.
let no_gvimrc_example=1
let no_vimrc_example=1

"**************************************************
"* System Environment {{{
"**************************************************
if $HOME=='' && has('win32') || has('win64')
	let $HOME=$USERPROFILE
endif
"**************************************************
" }}}
"**************************************************

"**************************************************
"* Japanese Environment {{{
"**************************************************
if has('win32') || has('win64')
	" if using windows ...
	" if using win32 ...
	if $LANG=='' || ($OSTYPE=='cygwin' && $TERM=='cygwin')
		let $LANG='ja'
		set encoding+=cp932
		lang mes ja
	endif
else
	" if using cygwin console ...
	if exists("$HOMEDRIVE")
		set background=dark
		if $LANG==''
			let $LANG='ja_JP.SJIS'
			set encoding+=cp932
		endif
		if $TERM=='xterm-color' && !has('gui_running')
			let $LANG='ja_JP.utf-8'
			set encoding+=utf-8
			language ja_JP.utf-8
			set langmenu=ja_jp.utf-8
		elseif $LANG=='ja.SJIS' || $LANG=='ja_JP.SJIS'
			set encoding+=cp932
			set langmenu=japanese_japan.932
		else
			set encoding+=euc-jp
			set langmenu=ja_jp.eucjp
		endif
	" if using unix console ...
	elseif $TERM=='kon' || $TERM=='kterm'
		if $LANG =~ 'UTF'
			set termencoding=euc-jp
			set ambiwidth=double
		else
			let $LANG='ja'
			set encoding+=euc-jp
		endif
	else
	"let $LANG='ja'
	"set langmenu=ja_jp.eucjp
	"set encoding=eucjp
	endif
endif

" if windows, detect mac format
if $OSTYPE=='cygwin' || $TERM=='cygwin' || exists("$HOMEDRIVE")
	set fileformats+=mac
endif
set fileformats+=mac

" for printing
if has('printer')
	if has('win32') || has('win64')
		set printfont=FixedSys:h10
	elseif has("unix")
		set printencoding=euc-jp
		if exists('&printmbcharset')
			set printmbcharset=JIS_X_1983
			set printmbfont=r:Ryumin-Light,b:Ryumin-Light,a:yes,c:yes
		endif
	endif
endif

if exists('&formatoptions')
	set formatoptions+=mB
	let format_join_spaces=2
	let format_allow_over_tw=1
endif

if exists('&ambiwidth') && (has('gui_running') || $TERM=="cygwin")
	" some xterm don't support cjk width
	set ambiwidth=double
endif
"**************************************************
" }}}
"**************************************************

"**************************************************
"* Key Maps {{{
"**************************************************
if !exists('g:mapleader')
	" for all mapleader
	let g:mapleader = '\'
endif

"**************************************************
" }}}
"**************************************************

"**************************************************
"* Autocmd {{{
"**************************************************
autocmd!
autocmd QuickFixCmdPost *grep* cwindow 8
autocmd BufNewFile *.sh 0r $HOME/.vim/template/sh.txt
autocmd BufNewFile *.c 0r $HOME/.vim/template/c.txt
"**************************************************
" }}}
"**************************************************

"**************************************************
"* Syntax And Colorscheme {{{
"**************************************************
syntax on
" colorscheme
if has("gui_running")
	colorscheme desert
else
	if has('unix')
		silent! colorscheme torte
	endif
	if has('win32') || has('win64')
		silent! colorscheme torte
	endif
endif
"**************************************************
" }}}
"**************************************************

"**************************************************
"* Plugin Settings{{{
"**************************************************
"* dein.vim
" プラグインが実際にインストールされるディレクトリ
let s:dein_dir = expand('~/.vim/dein')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
	if !isdirectory(s:dein_repo_dir)
		execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
	endif
	execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" 設定開始
if dein#load_state(s:dein_dir)
	call dein#begin(s:dein_dir)

	" プラグインリストを収めた TOML ファイル
	" ~/.vim/rc/dein.toml,deinlazy.tomlを用意する
	let g:rc_dir = expand('~/.vim/rc')
	let s:toml = g:rc_dir . '/dein.toml'
	let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

	" TOML を読み込み、キャッシュしておく
	call dein#load_toml(s:toml, {'lazy': 0})
	call dein#load_toml(s:lazy_toml, {'lazy': 1})

	" 設定終了
	call dein#end()
	call dein#save_state()
endif

" もし、未インストールものものがあったらインストール
if dein#check_install()
	call dein#install()
endif

filetype plugin indent on
"Unite.vim
let g:unite_source_menu_menus = {
			\  "shortcut" : {
			\    "description" : "sample unite-menu",
			\    "command_candidates" : [
			\      ["file", "Unite file"],
			\      ["file mru", "Unite file_mru"],
			\      ["unite-output:message", "Unite output:message"],
			\      ["check key-mapping", "Unite mapping"],
			\      ["grep", "Unite grep"],
			\    ],
			\  },
			\}
"* denite.vim
" Change file_rec command.
"call denite#custom#var('file_rec', 'command',
"\ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
" Change ignore_globs
"call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
"\ [ '.git/', '.ropeproject/', '__pycache__/',
"\ 'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])

"* neocomlete
let g:neocomplete#enable_at_startup = 1
"for vim-clang
if !exists('g:neocomplete#force_omni_input_patterns')
	let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#force_omni_input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
"_区切りの補完の有効化
"let g:neocomlete#enable_underbar_completion = 1
"let g:neocomlete#enable_camel_completion = 1
"シンタックスをキャッシュする最小文字長の設定
let g:neocomlete#sources#syntax#min_keyword_length = 3
"ファイルタイプ毎に補完のディクショナリを設定
""let g:neocomlete_dictionary_filetype_lists={
"* vimfiler
"デフォルトのファイラーにする
let g:vimfiler_as_default_explorer = 1
"セーフモードを無効化する
let g:vimfiler_safe_mode_by_default = 0
"change icons (like Textmate)
let g:vimfiler_tree_leaf_icon = ' '
let g:vimfiler_tree_opened_icon = '▾'
let g:vimfiler_tree_closed_icon = '▸'
let g:vimfiler_file_icon = '-' 
let g:vimfiler_marked_file_icon = '*'


"* vim-clang
"disable auto completion for vim-clang
let g:clang_auto = 0

"default longset can not work with neocomplete
let g:clang_c_completeopt = 'menuone,preview'
let g:clang_cpp_completeopt = 'menuone,preview'

let g:clang_c_options = '-std=c11'
let g:clang_cpp_options = '-std=c++11 -stdlib=libc++'

"* vim-quickrun
"quickrunのデフォルト設定
let g:quickrun_config = {
		\  "_" : {
		\    "hook/close_unite_quickfix/enable_hook_loaded" : 1,
		\    "hook/unite_quickfix/enable_failure" : 1,
		\    "hook/close_quickfix/enable_exit" : 1,
		\    "hook/close_buffer/enable_failure" : 1,
		\    "hook/close_buffer/enable_empty_data" : 1,
		\    "outputter" : "multi:buffer:quickfix",
		\    "hook/shabadoubi_touch_henshin/enable" : 1,
		\    "hook/shabadoubi_touch_henshin/wait" : 20,
		\    "outputter/buffer/split" : ":botright 8sp",
		\    "runner" : "vimproc",
		\    "runner/vimproc/updatetime" : 40
		\    },
	\}
"<C-c>で実行を強制終了させる
"quickrun.vimが実行していない場合には<C-c>を呼び出す
nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"

"* lightline.vim
let g:lightline = {
		\ 'colorscheme': 'wombat',
		\ 'mode_map': {'c': 'NORMAL'},
		\ 'active': {
		\ 'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
		\ },
		\ 'component_function': {
		\ 'modified': 'LightLineModified',
		\ 'readonly': 'LightLineReadonly',
		\ 'fugitive': 'LightLineFugitive',
		\ 'filename': 'LightLineFilename',
		\ 'fileformat': 'LightLineFileformat',
		\ 'filetype': 'LightLineFiletype',
		\ 'fileencoding': 'LightLineFileencoding',
		\ 'mode': 'LightLineMode'
		\ }
	\ }

function! LightLineModified()
	return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightLineReadonly()
 return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
endfunction

function! LightLineFilename()
	return ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
			\ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
			\  &ft == 'unite' ? unite#get_status_string() :
			\  &ft == 'vimshell' ? vimshell#get_status_string() :
			\ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
			\ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFugitive()
	if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
		return fugitive#head()
	else
		return ''
	endif
endfunction

function! LightLineFileformat()
	return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightLineFiletype()
	return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightLineFileencoding()
	return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightLineMode()
	return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

"**************************************************
" }}}
"**************************************************
