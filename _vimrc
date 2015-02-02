execute pathogen#infect()
call pathogen#helptags()
set nocompatible
set ignorecase
set smartcase
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin
set background=dark
colorscheme solarized

set guioptions-=T
set tabstop=4 softtabstop=0 noexpandtab shiftwidth=4

" Filetypes {{{
au BufRead,BufNewFile *.config,*.sfdb,*.vssettings,*.csproj,*.proj,*.manifest set filetype=xml
" }}}

" Line numbering {{{
set number
set relativenumber
autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber
" }}}

if has("win32") || has("win16")
	set fileformats=dos
	au GUIEnter * simalt ~x
	set guifont=consolas:h10:cANSI
else
	set fileformat=mac
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
