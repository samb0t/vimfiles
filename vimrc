" GlobalVariables {{{
" }}}

" LeaderMappings {{{
let mapleader=";"
" }}}

" Look and feel {{{
set fileformat=unix
set fileformats=unix
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
set guioptions-=m "remove menubar
set guioptions-=r "remove right scroll
set guioptions-=L "remove left scroll
set tabstop=4 softtabstop=4 expandtab shiftwidth=4
set nobomb "remove byte order mark
set number
set relativenumber
set foldlevel=20 " when we have folding, start open
set laststatus=2 " always show status line
set splitbelow " open splits to the bottom
set clipboard=unnamed " y is "+y by default for easier copy/paste
set ttimeoutlen=2 " helps escape from insert faster when in terminal
set modelines=1
set modeline
" linenum in netrw
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'
" }}}

" Snips {{{
inoremap {<CR> {<CR>}<Esc>ko
" }}}

" Misc {{{
inoremap kj <ESC>
cnoremap kj <ESC>
vnoremap kj <ESC>
xnoremap kj <ESC>

"set encryption to something more secure. pkzip is default

if !has('nvim')
    set cm=blowfish
    if !has('gui_running')
        set term=xterm
    endif
else
    tnoremap kj <C-\><C-n>
endif
" by default ; is find next. since ; is leader, hit it twice to find next
nnoremap ;; ;
" remap the black hole register to quick delete stuff you don't want in the default
nnoremap "" "_
" auto-complete tags
inoremap <// </<C-X><C-O><ESC>F<i
" use vim as calculator in insert mode
inoremap <C-L> <C-O>yiW<End>=<C-R>=<C-R>0<CR>
" generate a GUID; just type guid somewhere!
nnoremap <Leader>gu :py import uuid<CR>:s/guid/\=pyeval('str(uuid.uuid4()).upper()')/ <Bar> :noh<CR>

command! Gitautocommit :!git add -A && git commit -m 'gitautocommit' && git push

command! Deltrailing :%s/\s\+$//e
" }}}

" FileIO {{{
set nobackup

"function for getting the root of a project dir via the tags file
function! TagDir () 
    return fnamemodify(join(tagfiles(), ','), ':p:h')
endfunction

" Make :grep use ripgrep
if executable('rg')
    set grepprg=rg\ --color=never\ --vimgrep
endif
command! -nargs=1 Ngrep grep --smart-case "<args>" -g "*.md"
nnoremap <leader>gn :Ngrep 
command! -nargs=1 Agrep grep --smart-case "<args>" -g "*.*"
nnoremap <leader>ga :Agrep 

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
nmap <leader>gf :vimgrep // % <Bar> cw<Left><Left><Left><Left><Left><Left><Left><Left>
" highlight lines that do NOT contain a word
nmap <Leader>not /^\(.*.*\)\@!.*$<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
set wildignore+=**/target/**,**/node_modules/**
"copies current filepath to clipboard
if has("win32") || has("win16")
nmap <Leader>pa :let @* = expand("%:p")<CR>
else
nmap <Leader>pa :let @+ = expand("%:p")<CR>
endif
" copy entire file contents to the clipboard
nmap <Leader>yf gg"*yG
" make a copy of the current file
nmap <Leader>cp :!cp "%" "%:h/"<Left>
"create new line, but remain in normal
nmap <Leader>o o<ESC>
nmap <Leader>O O<ESC>
"semicolon at end of line
nmap <Leader>A A;<ESC>
"Paste today's date
nnoremap <Leader>dt "=strftime("%m-%d-%y")<CR>p
"Add a week to a mm-dd-yy date
nnoremap <Leader>week 
    \:py3 from datetime import datetime<CR>
    \:py3 from datetime import timedelta<CR>
    \:s/\d\d-\d\d-\d\d/\=py3eval('(datetime.strptime(vim.eval("submatch(0)"), "%m-%d-%y") +
    \timedelta(weeks=1)).strftime("%m-%d-%y")')/
"toggle spellcheck: use z= for suggestions [s ]s for navigation
" nmap <Leader>sp :set spell! spelllang=en_us <Bar> hi SpellBad cterm=underline <CR>
"pretty print json:
command! JsonFormat %!python3 -m json.tool

nmap <Leader>sp :set spell! <CR>
"open file in new browser tab
nmap <Leader>ch :silent !chrome chrome:\\newtab expand("%:p")<CR>

function! OpenInFirefox()
    silent execute "!firefox " . expand("%:p") " > /dev/null 2>&1 & disown"
    redraw!
endfunction
nmap <Leader>ff :call OpenInFirefox()<CR>
"increment decrement ints to not interfere with tmux
nnoremap <C-z> <C-a>
nnoremap <C-x> <C-x>
" }}}

" :windo diffthis {{{
nnoremap <Leader>dg :diffget<CR>
nnoremap <Leader>dp :diffput<CR>
nnoremap <Leader>diff :set diffopt+=iwhite <Bar> :set diffopt+=icase <Bar> :set diffopt+=iwhiteall <Bar> :windo diffthis <CR>
nnoremap <Leader>ndif :windo diffoff<CR>
" }}}

" Filetypes {{{
au BufRead,BufNewFile *.config,*.sfdb,*.vssettings,*.csproj,*.proj,*.manifest set filetype=xml
au BufRead,BufNewFile *.md set encoding=utf-8 filetype=vimwiki fileencoding=utf-8 tw=80

fun s:vwikisyn()
    syn match pluses "^+.*+\s\+$"
    syn match header "^[A-Z- ]\+[: ]\+$"
    syn match details "\[.*\]\s\+$"
    syn match dry /is able to\|in order to\|so that\|red flag/
    hi def link pluses String
    hi def link header Identifier
    hi def link details Statement
    hi def link dry Error
endfun

augroup vwiki_syn
  autocmd!
  autocmd Syntax vimwiki call s:vwikisyn()
augroup end

au BufEnter,BufNew *.md nnoremap <Leader>pd :let @+ ='<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css"> ' .system("pandoc -t html " .  shellescape(expand("%:p")))<CR>
au BufRead,BufNewFile *.cshtml set filetype=html
au BufRead,BufNewFile *.csx set filetype=cs
au BufRead,BufNewFile *.mmd set filetype=sequence
"set fileencodings=iso-2022-jp,euc-jp,cp932,utf8,default,latin1
au FileType gitcommit set tw=80
" }}}

" OS Specific {{{
fun! SetRelativeNumber(on)
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
	" }}}
	au GUIEnter * simalt ~x
	set guioptions-=m  "remove menu bar
	set guifontwide=NSimSun
	autocmd InsertEnter * call SetRelativeNumber(0)
	autocmd InsertLeave * call SetRelativeNumber(1)
	let $vimfiles = '~\vimfiles'
    let $sf = 'c:\bin\sfdc\workspace'
else
	" FileIOXnix {{{
	if !isdirectory($HOME . "/.vimbackups")
		call mkdir($HOME . "/.vimbackups", "p", 0700)
	endif
	" }}}
	autocmd InsertEnter * :set number
	autocmd InsertLeave * :set relativenumber
	let $vimfiles = '~/.vim'
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
nmap <Leader>2 :silent! let &guifont = substitute(
 \ &guifont,
 \ ':h\zs\d\+',
 \ '\=eval(submatch(0)+1)',
 \ '')<CR>
nmap <Leader>1 :silent! let &guifont = substitute(
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

" Functions {{{

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

function! UnquoteSql()
    exe '%s/^.\{-}"//'
    exe '%s/"\s\{-}+//'
    exe '%s/"\s\{-};//'
endfunction
command! Unq :silent call UnquoteSql()

"requires sqlformat on the cli
nnoremap <Leader>sql vip!sqlformat -r -k upper -s -<CR>

function! PrintFormattedFileName()
  let filename = expand('%:t:r')
  let formatted_filename = substitute(filename, '-', ' ', 'g')
  let formatted_filename = substitute(formatted_filename, '\v(\w)(\w*)', '\u\1\L\2', 'g')
  let cursor_position = getpos('.')
  call setline(cursor_position[1], getline(cursor_position[1]) . '# ' . formatted_filename)
endfunction
command! Fn :silent call PrintFormattedFileName()

" If you forget to open somthing as su, force a save anyways
command! W :w !sudo tee %
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
" Remove todo
nnoremap <Leader>tr :s/\[ \] // <Bar> :noh<CR>
" }}}

" {{{ Tags
" grep ctags
" First run: ctags -R .
set tags=./tags;/
set wildmenu " for listing possible options with `:tag /SomeTag`
" }}} Tags

" {{{ FindFiles

" Look for a tags file, implying project-level search or provide
" base directory as second arg
function! Fd (expression,...)
    let l:basedir = TagDir()
    if a:0 > 0
        let l:basedir = a:1
    endif
    exec "call setqflist(map(systemlist('fd \"".a:expression."\" ".l:basedir."'), {_, p -> {'filename': p}}))"
    exec "copen"
endfunction 

nnoremap <Leader>fd :call Fd("")<Left><Left>

function! Rg (expression,...)
    let l:basedir = TagDir()
    if a:0 > 0
        let l:basedir = a:1
        echo l:basedir
    endif

    echo l:basedir
    let l:output = system("rg --vimgrep --smart-case '".a:expression."' ".l:basedir."")
    let l:list = split(l:output, "\n")
    let l:ql = []
    for l:item in l:list
      let sit = split(l:item, ":")
      call add(l:ql,
          \ {"filename": sit[0], "lnum": sit[1], "col": sit[2], "text": sit[3]})
    endfor
    call setqflist(l:ql, 'r')
    exec "copen"
endfunction 

nnoremap <Leader>rg :call Rg("")<Left><Left>

" }}} FindFiles

" Java {{{
function! RunJava()
	exe ":! javac %"
	exe ":! java %:r"
endfunction

autocmd FileType java command! Run :call RunJava()
" /Java }}}

" PlantUML {{{
if has ("win32")
	let g:plantuml_executable_script = 'java -jar C:\bin\java\plantuml.jar'
else
	let g:plantuml_executable_script = 'plantuml'
endif
function! CompileUml()
	exe ":silent make ""\"".expand("%:p")."\""
endfunction
au BufWritePost *.uml call CompileUml()
let s:makecommand=g:plantuml_executable_script." %"

" define a sensible makeprg for plantuml files
autocmd Filetype plantuml let &l:makeprg=s:makecommand
" }}}

" Mermaid.js (make is overwriting plantuml settings) {{{
let g:mermaid_executable_script = "~/node_modules/.bin/mmdc"
let s:makemermaid=g:mermaid_executable_script." -i % -o %:r.png -b white -C %:r.css"
autocmd Filetype sequence let &l:makeprg=s:makemermaid
function! CompileMmd()
	exe ":silent make ""\"".expand("%:p")."\""
endfunction
au BufWritePost *.mmd call CompileMmd()

" LilyPond
function! CompileLilyPond()
    exe ":!lilypond --pdf %"
endfunction
au BufWritePost *.ly call CompileLilyPond()
" }}}

" LESS {{{
"requires node.js and lessc
function! CompileLess()
	:!lessc % %:t:r.css --source-map=%:t:r.css.map
	:!lessc % %:t:r.min.css -x
endfunction
au BufWritePost *.less call CompileLess()
" }}}

" SuperTab {{{
let g:SuperTabDefaultCompletionType = "context"
" }}}

" Renumber {{{
vnoremap <Leader>nu :call Renumber()<CR>
" }}}

" ale {{{
let g:ale_fixers = {
            \   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'yaml': ['yamllint'],
\   'markdown': ['markdownlint'],
\}
let g:ale_markdown_markdownlint_options = '-c ~/.markdownlint.json'
" }}}

" {{{ vimwiki
let g:vimwiki_folding = 'expr'
let g:vimwiki_list = [{'path': '~/wiki/', 'syntax': 'markdown', 'ext': '.md'}]

" makes tabstop possible with ultisnips; otherwise vimwiki steals tab for table navigation
let g:vimwiki_table_mappings = 0
" let g:vimwiki_list = [{'path': '~/Documents', 'syntax': 'markdown', 'ext': '.md'}]
" shift cells in a table with ease
nmap <Leader>vwh di\F<Bar>Pi<ESC>bb
nmap <Leader>vwj mz"ydi\a<ESC>j"zdi\<ESC>"ypba<ESC>k"zpba<ESC>`zj
nmap <Leader>vwk mz"ydi\a<ESC>k"zdi\<ESC>"ypba<ESC>j"zpba<ESC>`zk
nmap <Leader>vwl di\f<Bar>pi<ESC>ww
" }}}

" {{{ GitHub Copilot
nnoremap <leader>gc :Copilot panel<CR>
" }}}

" external variables {{{
try
    source ~/sqlplusconf.vim
catch
endtry
try
    source ~/forte.vim
catch
endtry
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
	colorscheme solarized
    set encoding=utf-8
    set guifont=
    set lines=999
    set columns=999
    let g:airline_theme='solarized'
else
    set termencoding=utf-8
    set encoding=utf-8
    inoremap <Char-0x07F> <BS>
    nnoremap <Char-0x07F> <BS>
    set t_Co=256
    let &t_AB="\e[48;5;%dm"
    let &t_AF="\e[38;5;%dm"
    try
        let &t_Cs = "\e[4:3m"
        let &t_Ce = "\e[4:0m"
    catch
    endtry
    let g:solarized_termcolors=256
    let g:solarized_termtrans=1
    set background=dark
    let g:airline_theme='solarized'
    colorscheme solarized
    highlight clear SpellBad
    highlight SpellBad cterm=underline
    highlight LineNr ctermbg=none
    highlight CopilotSuggestion ctermfg=DarkGray
endif

" Airline - add 'indent' to track mixed indentation
let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#checks = [ 'trailing' ]
let g:airline#extensions#whitespace#symbol = '!'
" }}}

" vim:fdm=marker:foldlevel=0:tw=0
