"vim:set ts=9 sts=2 sw=2 tw=0:
"vim:fdm=marker fdl=0 fdc=0 fdo+=jump,search:
"vim:fdt=substitute(getline(v\:foldstart),'\\(.\*\\){\\{3}','\\1',''):
"
"**************************************************

"**************************************************
"* Vim Environment {{{
"--------------------------------------------------
scriptencoding utf-8
if $MSYSTEM != ''
  finish
endif
if &compatible==1
  set nocompatible
endif
set cmdheight=2
set ignorecase
set smartcase
set tabstop=4
set shiftwidth=4
set history=50
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
if executable('grep')
  if globpath(substitute($PATH, ';', ',', 'g'), 'grep.exe') =~ 'borland'
    set grepprg=grep\ -no
  else
    set grepprg=grep\ -n
  endif
endif
set shellslash
set diffopt=filler,iwhite
set noundofile
" }}}
"**************************************************

" ignore bram's example script.
let no_gvimrc_example=1
let no_vimrc_example=1

"**************************************************
"* System Environment {{{
"--------------------------------------------------
if filereadable($VIM . '/vimrc') && filereadable($VIM . '/ViMrC')
  set tags=./tags,tags
endif

if $HOME=='' && has('win32') || has('win64')
  let $HOME=$USERPROFILE
endif

if $OSTYPE=='cygwin' || $TERM=='cygwin' || has('unix')
  let $DESKTOP=$HOME.'/Desktop'
else
  let $DESKTOP=$USERPROFILE."/\x83\x66\x83\x58\x83\x4e\x83\x67\x83\x62\x83\x76"
  if !isdirectory($DESKTOP)
    let $DESKTOP=$USERPROFILE."/\xC3\xDE\xBD\xB8\xC4\xAF\xCC\xDF"
  endif
  let $MYDOCUMENT=$USERPROFILE.'/My Documents'
endif

" }}}
"**************************************************

"**************************************************
"* Japanese Environment {{{
"--------------------------------------------------
if version >= 600
  if has('win32') || has('win64')
    " if using windows ...
    " if using win32 ...
    if $LANG=='' || ($OSTYPE=='cygwin' && $TERM=='cygwin')
      let $LANG='ja'
      set encoding=cp932
      lang mes ja
    endif
  else
    " if using cygwin console ...
    if exists("$HOMEDRIVE")
      set background=dark
      if $LANG==''
        let $LANG='ja_JP.SJIS'
        set encoding=cp932
      endif
      if $TERM=='xterm-color' && !has('gui_running')
        let $LANG='ja_JP.utf-8'
        set encoding=utf-8
        language ja_JP.utf-8
        set langmenu=ja_jp.utf-8
      elseif $LANG=='ja.SJIS' || $LANG=='ja_JP.SJIS'
        set encoding=cp932
        set langmenu=japanese_japan.932
      else
        set encoding=euc-jp
        set langmenu=ja_jp.eucjp
      endif 
    " if using unix console ...
    elseif $TERM=='kon' || $TERM=='kterm'
      if $LANG =~ 'UTF'
	set termencoding=euc-jp
	set ambiwidth=double
      else
        let $LANG='ja'
        set encoding=euc-jp
      endif
    else
      "let $LANG='ja'
      "set langmenu=ja_jp.eucjp
      "set encoding=eucjp
    endif
  endif
endif

if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " check the supporting JISX0213 for iconv
  if iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " build fileencodings
  set fileencodings=iso-2022-jp-3,iso-2022-jp,euc-jisx0213,euc-jp,utf-8
  set fileencodings+=utf-8
  if &encoding =~# '^euc-\%(jp\|jisx0213\)$'
    let &encoding = s:enc_euc
    silent! let &encoding = 'eucjp-ms'
  else
    let &fileencodings = &fileencodings .','. s:enc_euc . ',eucjp-ms'
  endif
  set fileencodings+=cp932
  unlet s:enc_euc
  unlet s:enc_jis
elseif executable('iconv')
  function! CharConvert()
    call system("iconv -f " . v:charconvert_from . " -t " . v:charconvert_to . " <" . v:fname_in . " >" . v:fname_out)
    return v:shell_error
  endfun
  set charconvert=CharConvert()
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
" }}}
"**************************************************

"**************************************************
"* Key Maps {{{
"--------------------------------------------------
if !exists('g:mapleader')
  " for all mapleader
  let g:mapleader = '\'
endif

" toggle list
nmap <F2> :let &list=(&list == 1 ? 0 : 1)<cr>
" helptags
if has('mac')
  nmap <F3> :helptags /Applications/MacVim.app/Contents/Resources/vim/runtime/doc
endif
" toggle highlight search
nmap <F4> :let &hls=(&hls == 1 ? 0 : 1)<cr>
" vimshell
nmap vs :VimShell<cr>
" vimfiler
nmap vf :VimFiler<cr>
inoremap <m-d>	<c-r>=Date()<cr>
" unite outline
nmap uo :Unite outline<cr>
" QuickRun
nmap qr :QuickRun<cr>
" dein update
nmap du :call dein#update()<cr>
" }}}
"**************************************************

"**************************************************
"* Autocmd {{{
"--------------------------------------------------
autocmd!
autocmd BufNewFile,BufReadPre * set nowrap
autocmd BufNewFile,BufReadPre *.c imap bs \
autocmd QuickFixCmdPost *grep* cwindow 8
autocmd BufNewFile *.sh 0r $HOME/.vim/template/sh.txt
autocmd BufNewFile *.c 0r $HOME/.vim/template/c.txt
" }}}
"**************************************************

"**************************************************
"* Syntax And Colorscheme {{{
"--------------------------------------------------
syntax on
if isdirectory($VIMRUNTIME.'/syntax')
  autocmd BufReadPost *
    \ silent! if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
endif
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
" }}}
"**************************************************

"**************************************************
"* Plugin Settings{{{
"--------------------------------------------------
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
  let g:rc_dir    = expand('~/.vim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
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

"* unite.vim

"* neocomlete
let g:neocomplete#enable_at_startup = 1
"_区切りの補完の有効化
"let g:neocomlete#enable_underbar_completion = 1
"let g:neocomlete#enable_camel_completion = 1
"シンタックスをキャッシュする最小文字長の設定
let g:neocomlete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
"ファイルタイプ毎に補完のディクショナリを設定
""let g:neocomlete_dictionary_filetype_lists={
"* vimfiler
"デフォルトのファイラーにする
let g:vimfiler_as_default_explorer = 1
"セーフモードを無効化する
let g:vimfiler_safe_mode_by_default = 0

"* vim-quickrun
"quickrunのデフォルト設定
let g:quickrun_config = {
  \ "_" : {
  \     "hook/close_unite_quickfix/enable_hook_loaded" : 1,
  \     "hook/unite_quickfix/enable_failure" : 1,
  \     "hook/close_quickfix/enable_exit" : 1,
  \     "hook/close_buffer/enable_failure" : 1,
  \     "hook/close_buffer/enable_empty_data" : 1,
  \     "outputter" : "multi:buffer:quickfix",
  \     "outputter/buffer/split" : ":botright 8sp",
  \     "runner" : "vimproc",
  \     "runner/vimproc/updatetime" : 40
  \ },
  \}
"<C-c>で実行を強制終了させる
"quickrun.vimが実行していない場合には<C-c>を呼び出す
nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"

"* lightline.vim
let g:lightline = {
        \ 'colorscheme': 'wombat',
        \ 'mode_map': {'c': 'NORMAL'},
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
        \ },
        \ 'component_function': {
        \   'modified': 'LightLineModified',
        \   'readonly': 'LightLineReadonly',
        \   'fugitive': 'LightLineFugitive',
        \   'filename': 'LightLineFilename',
        \   'fileformat': 'LightLineFileformat',
        \   'filetype': 'LightLineFiletype',
        \   'fileencoding': 'LightLineFileencoding',
        \   'mode': 'LightLineMode'
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

"--------------------------------------------------
" }}}
"**************************************************
