"**************************************************
"* Vim Environment {{{
"**************************************************
scriptencoding utf-8
if &compatible
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
set iminsert=0
set imsearch=0
set number
set cursorline
if !has('gui_running')
	set tgc		"use termguicolors
endif

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
"autocmd BufNewFile *.sh 0r $HOME/.vim/template/sh.txt
"autocmd BufNewFile *.c 0r $HOME/.vim/template/c.txt
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
		silent! colorscheme desert
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
"minpac
"Try to load minpac.
silent! packadd minpac
if !exists('*minpac#init')
	"minpacがロードされていない -> minpacを自動インストール
	execute '!mkdir -p ~/.vim/pack/minpac/opt && cd ~/.vim/pack/minpac/opt && git clone https://github.com/k-takata/minpac.git'
else
	call minpac#init()
	" minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
	call minpac#add('k-takata/minpac', {'type': 'opt'})
	" Add other plugins here.
	call minpac#add('itchyny/lightline.vim')
	call minpac#add('mattn/sonictemplate-vim')
	call minpac#add('vim-jp/vimdoc-ja')
	call minpac#add('vim-scripts/DirDiff.vim')
	call minpac#add('scrooloose/nerdtree')
	call minpac#add('ctrlpvim/ctrlp.vim')
	"load the plugins right now.
	packloadall
endif

filetype plugin indent on

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
		\ 'filename': 'LightLineFilename',
		\ 'fileformat': 'LightLineFileformat',
		\ 'filetype': 'LightLineFiletype',
		\ 'fileencoding': 'LightLineFileencoding',
		\ 'mode': 'LightLineMode'
		\ }
	\ }

function! LightLineModified()
	return &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightLineReadonly()
 return &readonly && &filetype !=# 'help' ? 'RO' : 'RW'
endfunction

function! LightLineFilename()
	return ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
			\ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
			\ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
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

"* sonictemplate-vim
let g:sonictemplate_vim_template_dir = [
			\ '~/.vim/dein/repos/github.com/mattn/sonictemplate-vim/template'
			\]

"* NERDTree
let g:NERDTreeDirArros = 1
let g:NERDTreeDirArrowExpandable = '▶'
let g:NERDTreeDirArrowCollapsible = '▼'

command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update()
command! PackClean packadd minpac | source $MYVIMRC | call minpac#clean()
"**************************************************
" }}}
"**************************************************
