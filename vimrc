" vi:set ts=9 sts=2 sw=2 tw=0:
" vim:fdm=marker fdl=0 fdc=0 fdo+=jump,search:
" vim:fdt=substitute(getline(v\:foldstart),'\\(.\*\\){\\{3}','\\1',''):
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
	set list listchars=tab:>-,trail::-,eol:@
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
if $SSH_CLIENT != ''
  set clipboard=autoselect,exclude:cons\\\|linux\\\|cygwin\\\|rxvt\\\|screen\\\|xterm
else
  set clipboard=autoselect,exclude:cons\\\|linux\\\|cygwin\\\|rxvt\\\|screen
endif
set diffopt=filler,iwhite
if has('unix') && $SHELL == ''
  set shell=/bin/bash
endif
if $TERM=='jfbterm'
  "fixdel
endif
"let $GTK_IM_MODULE = 'xim'
"let $GDK_USE_XFT = 0
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

" expand path
cmap <c-x> <c-r>=expand('%:p:h')<cr>/
" expand file (not ext)
cmap <c-z> <c-r>=expand('%:p:r')<cr>
" try tab completion
cmap <s-tab> <c-p>
" like windows
vnoremap p <Esc>:let current_reg = @"<CR>gvs<C-R>=current_reg<CR><Esc>
vmap <tab> >gv
vmap <s-tab> <gv
" quit with no erase
nmap <silent> gZZ :set t_te= t_ti= <cr>:quit<cr>:set t_te& t_ti&<cr>
" shell with no erase
nmap <silent> gsh :set t_te= t_ti= <cr>:sh<cr>:set t_te& t_ti&<cr>
" for file complete
cnoremap <c-g> <Space><BS>
nmap te :tabedit<cr>
nmap tc :tabclose<cr>

if exists('&iminsert')
  set iminsert=0
  set imsearch=0
  if !exists('&imoptions')
    " for im_custom
    inoremap <silent> <c-\> <c-o>:let &iminsert=(&iminsert==2?0:2)<cr>
  endif
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
nmap <F5> :VimShell<cr>
" vimfiler
nmap <F6> :VimFiler<cr>
inoremap <m-d>	<c-r>=Date()<cr>
" }}}
"**************************************************

"**************************************************
"* Autocmd {{{
"--------------------------------------------------
autocmd BufNewFile,BufRead * set nowrap
autocmd BufNewFile,BufRead *.c imap bs \
autocmd FileType twitvim call s:MyTwitVimSettings()
" }}}
"**************************************************

"**************************************************
"* Syntax And Colorscheme {{{
"--------------------------------------------------
if isdirectory($VIMRUNTIME.'/syntax')
  if &t_Co > 2 || has("gui_running")
   syntax on
  endif
  if has("autocmd")
    filetype plugin indent on
  endif
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
"* unite.vim

"* neocomplcache
let g:neocomplcache_enable_at_startup = 1
"ファイル名補完
inoremap <expr><C-x><C-f> neocomplcache#manual_filename_complete()
"_区切りの補完の有効化
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_enable_camel_completion = 1
"シンタックスをキャッシュする最小文字長の設定
let g:neocomplcache_min_sytax_length = 3
"シンタックスをキャッシュする最小文字長の設定
let g:neocomplcache_min_sytax_length = 3
"ファイルタイプ毎に補完のディクショナリを設定
""let g:neocomplcache_dictionary_filetype_lists={

"* vimfiler
"デフォルトのファイラーにする
let g:vimfiler_as_default_explorer = 1
"セーフモードを無効化する
let g:vimfiler_safe_mode_by_default = 0

"* pathogen
"call pathogen#runtime_append_all_bundles()

"* TwitVim
let g:twitvim_count=50
nnoremap tp :PosttoTwitter<CR>
nnoremap tf :FriendsTwitter<CR>
nnoremap tr :RefreshTwitter<CR>
if has('win32') || has('win64')
  let twitvim_browser_cmd='firefox.exe'
elseif has('unix')
  let twitvim_browser_cmd='firefox'
endif
function! s:MyTwitVimSettings()
  set wrap
endfunction
"--------------------------------------------------
" }}}
"**************************************************
