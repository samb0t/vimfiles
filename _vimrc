" Plugins {{{
execute pathogen#infect()
call pathogen#helptags()
" }}}

" LookAndFeel {{{
set nocompatible
set ignorecase
set smartcase
set background=dark
colorscheme solarized
set guioptions-=T "remove toolbar
set tabstop=4 softtabstop=0 noexpandtab shiftwidth=4
set nobomb "remove byte order mark
set number
set relativenumber
" }}}

" Misc {{{
"set encryption to something more secure. pkzip is default.
set cm=blowfish
source $VIMRUNTIME/vimrc_example.vim
" }}}

" FileIO {{{
set nobackup
" }}}

" LeaderMappings {{{
let mapleader=";"
"copies current filename to clipboard
nmap <Leader>p :let @* = expand("%")<CR>
" }}}

" Filetypes {{{
au BufRead,BufNewFile *.config,*.sfdb,*.vssettings,*.csproj,*.proj,*.manifest set filetype=xml
au BufRead,BufNewFile *.md set filetype=markdown
au BufRead,BufNewFile *.cshtml set filetype=html
" }}}

if has("win32") || has("win16")
	" FileIOWin {{{
	if !isdirectory($HOME . "\\.vimbackups")
		call mkdir($HOME . "\\.vimbackups", "p", 0700)
	endif
	set fileformats=dos
	" }}}
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
	" FileIOXnix {{{
	if !isdirectory($HOME . "/.vimbackups")
		call mkdir($HOME . "/.vimbackups", "p", 0700)
	endif
	" }}}
	set fileformat=mac
	autocmd InsertEnter * :set number
	autocmd InsertLeave * :set relativenumber
	let $vimfiles = '~/.vim'
	let $ts = '~/Dropbox/AutoSync/Tagspaces'
endif

" BackupLocation {{{
" set backupdir is a no-op if set nobackup
set backupdir=~/.vimbackups//
set directory=~/.vimbackups//
set undodir=~/.vimbackups//
" }}}

" WindowMgmt {{{
" Rolodex split windows; Maximize up/down
set winminheight=0
nmap <Leader>j <C-w>j<C-w>_
nmap <Leader>k <C-w>k<C-w>_

" Maximize (:only) with Save/Restore split configuration: {{{
" http://vim.wikia.com/wiki/Maximize_window_and_return_to_previous_split_structure
nnoremap <C-W>O :call MaximizeToggle()<CR>
nnoremap <C-W>o :call MaximizeToggle()<CR>
nnoremap <C-W><C-O> :call MaximizeToggle()<CR>

function! MaximizeToggle()
  if exists("s:maximize_session")
    exec "source " . s:maximize_session
    call delete(s:maximize_session)
    unlet s:maximize_session
    let &hidden=s:maximize_hidden_save
    unlet s:maximize_hidden_save
  else
    let s:maximize_hidden_save = &hidden
    let s:maximize_session = tempname()
    set hidden
    exec "mksession! " . s:maximize_session
    only
  endif
endfunction
" }}}
" WindowMgmt }}}

" Unite {{{

" (see http://usevim.com/2013/06/19/unite/)
" Also, http://bling.github.io/blog/2013/06/02/unite-dot-vim-the-plugin-you-didnt-know-you-need/

" search file dir and immediately fuzzy find
nnoremap <Leader>f :Unite -start-insert file_rec<CR>

" search yank history
let g:unite_source_history_yank_enable = 1
nnoremap <Leader>y :Unite history/yank<cr>

" quick buffer switching
nnoremap <Leader>b :Unite -quick-match buffer<cr>

" Unite }}}

" OmniSharp (Most from https://github.com/OmniSharp/omnisharp-vim examples) {{{
" Code documentation to be split below rather than above
set splitbelow

augroup omnisharp_commands

	autocmd!

	"run vim-dispatch builds async
	autocmd FileType cs nnoremap <leader>b :wa!<cr>:OmniSharpBuildAsync<cr>
	"keep VS bindings for muscle memory
	autocmd FileType cs nnoremap <F6> :wa!<cr>:OmniSharpBuildAsync<cr>
	" Automatically add new cs files to the nearest project on save
	autocmd BufWritePost *.cs call OmniSharp#AddToProject()
	"show type information automatically when the cursor stops moving
	autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()

	"The following commands are contextual, based on the current cursor position.

	autocmd FileType cs nnoremap gd :OmniSharpGotoDefinition<cr>
	autocmd FileType cs nnoremap <F12> :OmniSharpGotoDefinition<cr>
	autocmd FileType cs nnoremap <leader>fi :OmniSharpFindImplementations<cr>
	autocmd FileType cs nnoremap <leader>ft :OmniSharpFindType<cr>
	autocmd FileType cs nnoremap <leader>fs :OmniSharpFindSymbol<cr>
	autocmd FileType cs nnoremap <leader>fu :OmniSharpFindUsages<cr>
	autocmd FileType cs nnoremap <C-k>r :OmniSharpFindUsages<cr>
	"finds members in the current buffer
	autocmd FileType cs nnoremap <leader>fm :OmniSharpFindMembers<cr>
	" cursor can be anywhere on the line containing an issue
	autocmd FileType cs nnoremap <leader>x  :OmniSharpFixIssue<cr>
	autocmd FileType cs nnoremap <leader>fx :OmniSharpFixUsings<cr>
	autocmd FileType cs nnoremap <leader>tt :OmniSharpTypeLookup<cr>
	autocmd FileType cs nnoremap <leader>dc :OmniSharpDocumentation<cr>
	autocmd FileType cs nnoremap <F1> :OmniSharpDocumentation<cr>

augroup END

" Contextual code actions (requires CtrlP or unite.vim)
nnoremap <leader><space> :OmniSharpGetCodeActions<cr>
" Run code actions with text selected in visual mode to extract method
vnoremap <leader><space> :call OmniSharp#GetCodeActions('visual')<cr>

" rename with dialog
nnoremap <leader>nm :OmniSharpRename<cr>
nnoremap <F2> :OmniSharpRename<cr>

" Force OmniSharp to reload the solution. Useful when switching branches etc.
nnoremap <leader>rl :OmniSharpReloadSolution<cr>
nnoremap <leader>cf :OmniSharpCodeFormat<cr>
" Load the current .cs file to the nearest project

nnoremap <leader>tp :OmniSharpAddToProject<cr>

" Synchronous build (blocks Vim)
"autocmd FileType cs nnoremap <F5> :wa!<cr>:OmniSharpBuild<cr>
" Builds can also run asynchronously with vim-dispatch installed
autocmd FileType cs nnoremap <leader>b :wa!<cr>:OmniSharpBuildAsync<cr>
autocmd FileType cs nnoremap <F6>b :wa!<cr>:OmniSharpBuildAsync<cr>

"Don't ask to save when changing buffers (i.e. when jumping to a type definition)
set hidden

" OmniSharp }}}

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
