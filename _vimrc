execute pathogen#infect()
call pathogen#helptags()
set nocompatible
set ignorecase
set smartcase
set background=dark
"set encryption to something more secure. pkzip is default.
set cm=blowfish
source $VIMRUNTIME/vimrc_example.vim
colorscheme solarized

set guioptions-=T "remove toolbar
set tabstop=4 softtabstop=0 noexpandtab shiftwidth=4
set nobomb "remove byte order mark

let mapleader=";"
"copies current filename to clipboard
nmap <Leader>p :let @* = expand("%")<CR>

" WindowMgmt {{{
set winminheight=0
nmap <Leader>j <C-w>j<C-w>_
nmap <Leader>k <C-w>k<C-w>_
"}}}

" Filetypes {{{
au BufRead,BufNewFile *.config,*.sfdb,*.vssettings,*.csproj,*.proj,*.manifest set filetype=xml
au BufRead,BufNewFile *.md set filetype=markdown
au BufRead,BufNewFile *.cshtml set filetype=html
" }}}

" Line numbering {{{
set number
set relativenumber
" }}}

if has("win32") || has("win16")
	set fileformats=dos
	au GUIEnter * simalt ~x
	set guioptions-=m  "remove menu bar
	set guifont=consolas:h10:cANSI
	autocmd InsertEnter * :set norelativenumber
	autocmd InsertLeave * :set relativenumber
	let g:skip_loading_mswin=1 " turn this off if you really want awful windows ctrl bindings
	source $VIMRUNTIME/mswin.vim
	behave mswin
	let $vimfiles = '~\vimfiles'
	let $rec = 'c:\sofodev\mediasite\main\applications\recorder2'
	let $recui = 'c:\sofodev\mediasite\main\server\mediasiteroot\mediasiteroot\areas\recorder'
	let $ts = '~\Dropbox\AutoSync\Tagspaces'
	let $sites = 'c:\webdevstreams\SonicFoundry\Site'
else
	set fileformat=mac
	autocmd InsertEnter * :set number
	autocmd InsertLeave * :set relativenumber
	let $vimfiles = '~/.vim'
endif

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction
