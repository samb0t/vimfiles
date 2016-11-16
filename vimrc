" GlobalVariables {{{
let g:p4w = "samb_webdevstreams"
" }}}

" LeaderMappings {{{
let mapleader=";"
" }}}

" Look and feel {{{
filetype plugin indent on
syntax on
set hlsearch
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set autoindent
set nocompatible
set ignorecase
set smartcase
set background=dark
set guioptions-=T "remove toolbar
set tabstop=4 softtabstop=4 expandtab shiftwidth=4
set nobomb "remove byte order mark
set number
set relativenumber
set foldlevel=20 " when we have folding, start open
" }}}

" Snips {{{
inoremap {<CR> {<CR>}<Esc>ko
" }}}

" Misc {{{
"set encryption to something more secure. pkzip is default
set cm=blowfish
"toggle spellcheck: use z= for suggestions [s ]s for navigation
nmap <Leader>sc :set spell! spelllang=en_us<CR>
" by default ; is find next. since ; is leader, hit it twice to find next
nnoremap ;; ;
" auto-complete tags
inoremap <// </<C-X><C-O><ESC>F<i
" use vim as calculator in insert mode
inoremap <C-A> <C-O>yiW<End>=<C-R>=<C-R>0<CR>
" generate a GUID; just type guid somewhere!
nnoremap <Leader>gu :py import uuid<CR>:s/guid/\=pyeval('str(uuid.uuid4()).upper()')/ <Bar> :noh<CR>
" generate markup vim footer
nmap <Leader>foot Go<!--<Enter>%% vim:tw=80<Enter>--><ESC>:e %<Enter>
" }}}

" FileIO {{{
set nobackup
" http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file
autocmd BufEnter * silent! lcd %:p:h
" grep open buffers function
function! BuffersList()
  let all = range(0, bufnr('$'))
  let res = []
  for b in all
    if buflisted(b)
      call add(res, bufname(b))
    endif
  endfor
  return res
endfunction
function! GrepBuffers (expression)
  exec 'vimgrep/'.a:expression.'/ '.join(BuffersList())
endfunction
nmap <Leader>gb :call GrepBuffers("") <Bar> cw<Left><Left><Left><Left><Left><Left><Left>

" http://vim.wikia.com/wiki/Find_in_files_within_Vim
" Search for word under cursor in subdirectories
nmap <C-S-f> :execute "vimgrep /" . expand("<cword>") . "/j **" <Bar> cw<CR>
" edit file's current directory
nmap <Leader>ed :e %:h<CR>
" Open vimgrep and put the cursor in the right position
nmap <leader>gd :vimgrep // %:h/**/*.* <Bar> cw<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
nmap <leader>gf :vimgrep // % <Bar> cw<Left><Left><Left><Left><Left><Left><Left><Left>
"copies current filepath to clipboard
nmap <Leader>pa :let @* = expand("%:p")<CR>
" copy entire file contents to the clipboard
nmap <Leader>yf gg"*yG
" make a copy of the current file
nmap <Leader>cp :!copy "%" "%:h\"<Left>
"open current file for edit in p4
nmap <Leader>p4 :execute "!p4 -c " . g:p4w . " edit %"<CR>
nmap <Leader>p4a :execute "!p4 -c " . g:p4w . " add %"<CR>
"create new line, but remain in normal
nmap <Leader>o o<ESC>
nmap <Leader>O O<ESC>
"semicolon at end of line
nmap <Leader>A A;<ESC>
"shortcut for using the built-in :make
nnoremap <F5> :w<CR> :silent make<CR>
"Paste today's date
nnoremap <Leader>dt "=strftime("%m/%d/%y")<CR>p
"open file in new browser tab
nmap <Leader>ch :silent !chrome chrome:\\newtab "%"<CR>
" }}}

" :windo diffthis {{{
nnoremap <Leader>dg :diffget<CR>
nnoremap <Leader>dp :diffput<CR>
" }}}

" Filetypes {{{
au BufRead,BufNewFile *.config,*.sfdb,*.vssettings,*.csproj,*.proj,*.manifest set filetype=xml
au BufRead,BufNewFile *.md set encoding=utf-8 filetype=markdown fileencoding=utf-8
"cwm is an extension I made up for confluence wiki markup syntax
au BufRead,BufNewFile *.cwm set filetype=confluencewiki
au BufRead,BufNewFile *.cshtml set filetype=html
au BufRead,BufNewFile *.apxc set filetype=apex
au BufRead,BufNewFile *.csx set filetype=cs
set fileencodings=iso-2022-jp,euc-jp,cp932,utf8,default,latin1
" }}}

" OS Specific {{{
fun! SetRelativeNumber(on)
	if exists('b:conque_on')
		return
	endif
	if (a:on)
		exe "set relativenumber"
	else
		exe "set norelativenumber"
	endif
endfun
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
	autocmd InsertEnter * call SetRelativeNumber(0)
	autocmd InsertLeave * call SetRelativeNumber(1)
	let $vimfiles = '~\vimfiles'
	let $ts = '~\Dropbox\AutoSync\Tagspaces'
	let $sites = 'c:\webdevstreams\SonicFoundry\Site'
	let $sf = 'c:\bin\sfdc\workspace'
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
" }}}

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

" ResizeFont {{{
nmap <Leader>+ :silent! let &guifont = substitute(
 \ &guifont,
 \ ':h\zs\d\+',
 \ '\=eval(submatch(0)+1)',
 \ '')<CR>
nmap <Leader>- :silent! let &guifont = substitute(
 \ &guifont,
 \ ':h\zs\d\+',
 \ '\=eval(submatch(0)-1)',
 \ '')<CR>
" }}}

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
"
" Functions {{{
" If the current file name contains a jira issue, open in browser
function! OpenInJira()
	let issueNo = matchlist(expand('%'),'\(join-\|ops-\|evp-\)\(\d\+\)')
	if empty(issueNo)
		echo("no")
	else
		exec "silent ! start /B http://jira.sonicfoundry.net:8080/browse/" . issueNo[0]
	endif
endfunction

nmap <Leader>is :call OpenInJira()<CR>

" Convert markdown to Confluence-style markdown. Not complete yet.
nmap <Leader>con :%s/^####/h4./ge <Bar> %s/{{\([^}}]*\)`/{{\1}}/ge <Bar> %s/^###/h3./e <Bar> %s/^##/h2./e <Bar> %s/^#/h1./e <Bar> %s/^    -/--/ge <Bar> %s/        -/---/ge <Bar> %s/            -/----/ge <Bar> %s/`\(.\{-}\)`/{{\1}}/ge <Bar> g/^\d/norm O <CR> 
" like :on :only, except it actually deletes each buffer but the current
function! Buflist()
    redir => bufnames
    silent ls
    redir END
    let list = []
    for i in split(bufnames, "\n")
		let buf = matchlist(i, '^\s\{-\}\(\d\+\)')
        echo buf
		if len(buf) > 1
			call add(list, buf[1])
		endif
    endfor
    return list
endfunction

function! Bdeleteonly()
    let list = filter(Buflist(), 'v:val != bufnr("%")')
    for buffer in list
		try
			exec "bdelete ".buffer
		catch
			call setqflist([{"text": v:exception}])
		endtry
    endfor
endfunction
command! Bdon :silent call Bdeleteonly()
command! Bdonly :silent call Bdeleteonly()

" }}}

" Todo {{{
" Make todo
nnoremap <Leader>td i[ ]<space>
" Mark line as done
nnoremap <Leader>tx :s/\(\s*[-+*]\?\s*\)\[ \]/\1[x]/ <Bar> :noh<cr>
" Mark line as undone
nnoremap <Leader>tu :s/\(\s*[-+*]\?\s*\)\[x\]/\1[ ]/ <Bar> :noh<cr>
" Grep for todos
nnoremap <Leader>gt :vimgrep /\[ \]/ % <Bar> cw<CR>
" }}}

" Unite {{{

" (see http://usevim.com/2013/06/19/unite/)
" Also, http://bling.github.io/blog/2013/06/02/unite-dot-vim-the-plugin-you-didnt-know-you-need/

" search file dir and immediately fuzzy find
nnoremap <Leader>f :Unite -start-insert file_rec<CR>

" search yank history
let g:unite_source_history_yank_enable = 1
nnoremap <Leader>y :Unite history/yank<cr>

" quick buffer switching
nnoremap <Leader>ls :Unite -quick-match buffer<cr>

" Unite }}}

" OmniSharp (Most from https://github.com/OmniSharp/omnisharp-vim examples) {{{
" Code documentation to be split below rather than above
set splitbelow

"let g:OmniSharp_server_type = 'roslyn'

augroup omnisharp_commands

	autocmd!

	"run vim-dispatch builds async
	autocmd FileType cs nnoremap <leader>bu :wa!<cr>:OmniSharpBuildAsync<cr>
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
autocmd FileType cs nnoremap <F6> :wa!<cr>:OmniSharpBuildAsync<cr>

" (Experimental - uses vim-dispatch or vimproc plugin) - Start the omnisharp server for the current solution
nnoremap <leader>ss :OmniSharpStartServer<cr>
nnoremap <leader>sp :OmniSharpStopServer<cr>

"Don't ask to save when changing buffers (i.e. when jumping to a type definition)
set hidden

" OmniSharp }}}

" vim-force.com {{{
" see :help force.com
" requires JRE, tooling-force.com, sbt, UnxUtils (Just tee.exe/touch.exe)
if has ("win32")
	let g:apex_backup_folder = 'C:\bin\sfdc\backups\'
	let g:apex_temp_folder = 'C:\bin\temp'
	let g:apex_properties_folder = 'C:\bin\sfdc\properties\'
	let g:apex_tooling_force_dot_com_path = 'C:\bin\sfdc\tooling-force.com-0.3.3.0.jar'
	let g:apex_binary_tee = 'C:\bin\UnxUtils\tee.exe'
	let g:apex_binary_touch = 'C:\bin\UnxUtils\touch.exe'
	let g:apex_workspace_path = 'C:\bin\sfdc\workspace\'
else
	let g:apex_backup_folder = '/bin/sfdc/backups/'
	let g:apex_temp_folder = '/bin/temp'
	let g:apex_properties_folder = '/bin/sfdc/properties/'
	let g:apex_tooling_force_dot_com_path = '/bin/sfdc/tooling-force.com-0.3.3.0.jar'
	let g:apex_workspace_path = '/bin/sfdc/workspace/'
endif
" }}}

" PlantUML {{{
if has ("win32")
	let g:plantuml_executable_script = 'java -jar C:\bin\java\plantuml.jar'
else
	let g:plantuml_executable_script = 'java -jar /bin/java/plantuml.jar'
endif
function! CompileUml()
	" exe ":silent !p4 -c " . g:p4w . " edit *.png"
	exe ":silent make ""\"".expand("%:p")."\""
endfunction
au BufWritePost *.uml call CompileUml()
" }}}

" LESS {{{
"requires node.js and lessc
function! CompileLess()
	execute ":silent !p4 -c " . g:p4w . " edit *.css *.map"
	:!lessc % %:t:r.css --source-map=%:t:r.css.map
	:!lessc % %:t:r.min.css -x
endfunction
au BufWritePost *.less call CompileLess()
" }}}

" SuperTab {{{
let g:SuperTabDefaultCompletionType = "context"
" }}}

" ConqueShell {{{
let g:ConqueTerm_FastMode = 1
" conceal isn't doing its job, so just ditch colors for now
" let g:ConqueTerm_Color = 2
" let g:ConqueTerm_ColorMode = 'conceal'
nnoremap <Leader>ps :new<CR>:ConqueTerm powershell <CR>
nnoremap <Leader>sh :new<CR>:ConqueTerm bash <CR>
" }}}

" Renumber {{{
vnoremap <Leader>nu :call Renumber()<CR>
" }}}

" syntastic {{{
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_cs_checkers = ['syntax']
" }}}

" {{{ vimwiki
let g:vimwiki_folding = 'expr'
let g:vimwiki_list = [{'path': '~/Dropbox/AutoSync/TagSpaces/', 'syntax': 'markdown', 'ext': '.md'},
					 \ {'path': '~/my_site/', 'syntax': 'markdown', 'ext': '.md'}]
" shift cells in a table with ease
nmap <Leader>vwh di\F<Bar>Pi<ESC>
nmap <Leader>vwj di\jpi<ESC>
nmap <Leader>vwk di\kpi<ESC>
nmap <Leader>vwl di\f<Bar>pi<ESC>
" }}}

" Plugins {{{
call pathogen#infect()
call pathogen#helptags()

" Load installed MatchIt plugin
" % to find matching tags in markup
source $VIMRUNTIME/macros/matchit.vim
" }}}

" Post-pathogen infect {{{
if has("gui_running")
	colorscheme lucius
else
	colorscheme darkblue
endif
" Airline - add 'indent' to track mixed indentation
let g:airline#extensions#whitespace#checks = [ 'trailing' ]
" }}}

" vim:fdm=marker:foldlevel=0
