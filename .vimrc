" Sensible defaults by trope
if exists('g:loaded_sensible') || &compatible
  finish
else
  let g:loaded_sensible = 'yes'
endif

" Use :help 'option' to see the documentation for the given option.

" Disable vi compatibility, if for some reason it's on.
if &compatible
  set nocompatible
endif

" Check if an option was set from a file in $HOME.  This lets us avoid
" overriding options in the user's vimrc, but still override options in the
" system vimrc.
function! s:MaySet(option) abort
  if exists('*execute')
    let out = execute('verbose setglobal all ' . a:option . '?')
  else
    redir => out
    silent verbose execute 'setglobal all' a:option . '?'
    redir END
  endif
  return out !~# " \\(\\~[\\/]\\|Lua\\)[^\n]*$"
endfunction

if s:MaySet('backspace')
  set backspace=indent,eol,start
endif
" Disable completing keywords in included files (e.g., #include in C).  When
" configured properly, this can result in the slow, recursive scanning of
" hundreds of files of dubious relevance.
set complete-=i
if s:MaySet('smarttab')
  set smarttab
endif

set nrformats-=octal

" Make the escape key more responsive by decreasing the wait time for an
" escape sequence (e.g., arrow keys).
if !has('nvim') && &ttimeoutlen == -1
  set ttimeout
  set ttimeoutlen=100
endif

if has('reltime') && s:MaySet('incsearch')
  set incsearch
endif
" Use CTRL-L to clear the highlighting of 'hlsearch' (off by default) and call
" :diffupdate.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

if s:MaySet('laststatus')
  set laststatus=2
endif
if s:MaySet('ruler')
  set ruler
endif
if s:MaySet('wildmenu')
  set wildmenu
endif

if s:MaySet('scrolloff')
  set scrolloff=1
endif
if s:MaySet('sidescroll') && s:MaySet('sidescrolloff')
  set sidescroll=1
  set sidescrolloff=2
endif
set display+=lastline
if has('patch-7.4.2109')
  set display+=truncate
endif

if s:MaySet('listchars')
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif

" Delete comment character when joining commented lines.
if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j
endif

" Replace the check for a tags file in the parent directory of the current
" file with a check in every ancestor directory.
if has('path_extra') && (',' . &g:tags . ',') =~# ',\./tags,'
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

if s:MaySet('autoread')
  set autoread
endif

if s:MaySet('history')
  set history=1000
endif
if s:MaySet('tabpagemax')
  set tabpagemax=50
endif

" Persist g:UPPERCASE variables, used by some plugins, in .viminfo.
if !empty(&viminfo)
  set viminfo^=!
endif
" Saving options in session and view files causes more problems than it
" solves, so disable it.
set sessionoptions-=options
set viewoptions-=options

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^Eterm'
  set t_Co=16
endif

" If the running Vim lacks support for the Fish shell, use Bash instead.
if &shell =~# 'fish$' && (v:version < 704 || v:version == 704 && !has('patch276'))
  set shell=/usr/bin/env\ bash
endif

" Disable a legacy behavior that can break plugin maps.
if has('langmap') && exists('+langremap') && &langremap && s:MaySet('langremap')
  set nolangremap
endif

if !(exists('g:did_load_filetypes') && exists('g:did_load_ftplugin') && exists('g:did_indent_on'))
  filetype plugin indent on
endif
if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

if empty(mapcheck('<C-U>', 'i'))
  inoremap <C-U> <C-G>u<C-U>
endif
if empty(mapcheck('<C-W>', 'i'))
  inoremap <C-W> <C-G>u<C-W>
endif

" From `:help :DiffOrig`.
if exists(":DiffOrig") != 2
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_
        \ | diffthis | wincmd p | diffthis
endif

" Correctly highlight $() and other modern affordances in filetype=sh.
if !exists('g:is_posix') && !exists('g:is_bash') && !exists('g:is_kornshell') && !exists('g:is_dash')
  let g:is_posix = 1
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

" Enable the :Man command shipped inside Vim's man filetype plugin.
if exists(':Man') != 2 && !exists('g:loaded_man') && &filetype !=? 'man' && !has('nvim')
  runtime ftplugin/man.vim
endif

" Cyberdream theme. Made manually based on cyberdream colorscheme and catpuccin theme

set termguicolors
hi clear

if exists('syntax on')
    syntax reset
endif

let g:colors_name='cyberdream'
set t_Co=256

function! s:hi(group, guisp, guifg, guibg, gui, cterm)
  let cmd = ""
  if a:guisp != ""
    let cmd = cmd . " guisp=" . a:guisp
  endif
  if a:guifg != ""
    let cmd = cmd . " guifg=" . a:guifg
  endif
  if a:guibg != ""
    let cmd = cmd . " guibg=" . a:guibg
  endif
  if a:gui != ""
    let cmd = cmd . " gui=" . a:gui
  endif
  if a:cterm != ""
    let cmd = cmd . " cterm=" . a:cterm
  endif
  if cmd != ""
    exec "hi " . a:group . cmd
  endif
endfunction

let s:bg = "#16181a"
let s:bg_alt = "#1e2124"
let s:bg_highlight = "#3c4048"
let s:fg = "#ffffff"
let s:grey = "#7b8496"
let s:blue = "#5ea1ff"
let s:green = "#5eff6c"
let s:cyan = "#5ef1ff"
let s:red = "#ff6e5e"
let s:yellow = "#f1ff5e"
let s:magenta = "#ff5ef1"
let s:pink = "#ff5ea0"
let s:orange = "#ffbd5e"
let s:purple = "#bd5eff"

call s:hi("Boolean", "NONE", s:orange, "NONE", "NONE", "NONE")
call s:hi("Constant", "NONE", s:orange, "NONE", "NONE", "NONE")
call s:hi("Float", "NONE", s:orange, "NONE", "NONE", "NONE")
call s:hi("Label", "NONE", s:orange, "NONE", "NONE", "NONE")
call s:hi("Number", "NONE", s:orange, "NONE", "NONE", "NONE")

call s:hi("Character", "NONE", s:cyan, "NONE", "NONE", "NONE")
call s:hi("Operator", "NONE", s:cyan, "NONE", "NONE", "NONE")
call s:hi("StatusLine", "NONE", s:cyan, "NONE", "NONE", "NONE")

call s:hi("ColorColumn", "NONE", "NONE", s:bg_alt, "NONE", "NONE")
call s:hi("CursorColumn", "NONE", "NONE", s:bg_alt, "NONE", "NONE")
call s:hi("CursorLine", "NONE", "NONE", s:bg_alt, "NONE", "NONE")
call s:hi("PmenuSbar", "NONE", "NONE", s:bg_alt, "NONE", "NONE")
call s:hi("TabLineFill", "NONE", "NONE", s:bg_alt, "NONE", "NONE")
call s:hi("debugPC", "NONE", "NONE", s:bg_alt, "NONE", "NONE")

call s:hi("Comment", "NONE", s:bg_highlight, "NONE", "NONE", "NONE")
call s:hi("Conceal", "NONE", s:bg_highlight, "NONE", "NONE", "NONE")
call s:hi("Ignore", "NONE", s:bg_highlight, "NONE", "NONE", "NONE")
call s:hi("LineNr", "NONE", s:bg_highlight, "NONE", "NONE", "NONE")
call s:hi("NonText", "NONE", s:bg_highlight, "NONE", "NONE", "NONE")

call s:hi("Conditional", "NONE", s:red, "NONE", "NONE", "NONE")
call s:hi("Error", "NONE", s:red, "NONE", "NONE", "NONE")
call s:hi("Exception", "NONE", s:red, "NONE", "NONE", "NONE")
call s:hi("Repeat", "NONE", s:red, "NONE", "NONE", "NONE")

call s:hi("Cursor", "NONE", s:bg, s:pink, "NONE", "NONE")
call s:hi("CursorIM", "NONE", s:bg, s:pink, "NONE", "NONE")
call s:hi("lCursor", "NONE", s:bg, s:pink, "NONE", "NONE")

call s:hi("CursorLineNR", "NONE", s:purple, "NONE", "NONE", "NONE")

call s:hi("Debug", "NONE", s:pink, "NONE", "NONE", "NONE")
call s:hi("Define", "NONE", s:pink, "NONE", "NONE", "NONE")
call s:hi("Delimiter", "NONE", s:pink, "NONE", "NONE", "NONE")
call s:hi("Identifier", "NONE", s:pink, "NONE", "NONE", "NONE")
call s:hi("Include", "NONE", s:pink, "NONE", "NONE", "NONE")
call s:hi("Keyword", "NONE", s:pink, "NONE", "NONE", "NONE")
call s:hi("Macro", "NONE", s:pink, "NONE", "NONE", "NONE")
call s:hi("PreCondit", "NONE", s:pink, "NONE", "NONE", "NONE")
call s:hi("PreProc", "NONE", s:pink, "NONE", "NONE", "NONE")
call s:hi("Special", "NONE", s:pink, "NONE", "NONE", "NONE")
call s:hi("SpecialChar", "NONE", s:pink, "NONE", "NONE", "NONE")
call s:hi("SpecialComment", "NONE", s:pink, "NONE", "NONE", "NONE")
call s:hi("Tag", "NONE", s:pink, "NONE", "NONE", "NONE")

call s:hi("DiffAdd", "NONE", s:bg, s:green, "NONE", "NONE")
call s:hi("SpellRare", "NONE", s:bg, s:green, "NONE", "NONE")

call s:hi("DiffChange", "NONE", s:bg, s:yellow, "NONE", "NONE")
call s:hi("SpellCap", "NONE", s:bg, s:yellow, "NONE", "NONE")

call s:hi("DiffDelete", "NONE", s:bg, s:red, "NONE", "NONE")
call s:hi("SpellBad", "NONE", s:bg, s:red, "NONE", "NONE")

call s:hi("DiffText", "NONE", s:bg, s:blue, "NONE", "NONE")
call s:hi("SpellLocal", "NONE", s:bg, s:blue, "NONE", "NONE")

call s:hi("Directory", "NONE", s:blue, "NONE", "NONE", "NONE")
call s:hi("Function", "NONE", s:blue, "NONE", "NONE", "NONE")
call s:hi("MoreMsg", "NONE", s:blue, "NONE", "NONE", "NONE")
call s:hi("Question", "NONE", s:blue, "NONE", "NONE", "NONE")
call s:hi("Type", "NONE", s:blue, "NONE", "NONE", "NONE")

call s:hi("EndOfBuffer", "NONE", "NONE", "NONE", "NONE", "NONE")

call s:hi("ErrorMsg", "NONE", s:red, "NONE", "bolditalic", "bolditalic")

call s:hi("FoldColumn", "NONE", s:bg_highlight, s:bg, "NONE", "NONE")
call s:hi("debugBreakpoint", "NONE", s:bg_highlight, s:bg, "NONE", "NONE")

call s:hi("Folded", "NONE", s:blue, s:bg_alt, "NONE", "NONE")

call s:hi("IncSearch", "NONE", s:bg_alt, s:pink, "NONE", "NONE")

call s:hi("MatchParen", "NONE", s:orange, "NONE", "bold", "bold")

call s:hi("ModeMsg", "NONE", s:cyan, "NONE", "bold", "bold")

call s:hi("Normal", "NONE", s:fg, "NONE", "NONE", "NONE")

call s:hi("Pmenu", "NONE", s:bg_highlight, s:bg_alt, "NONE", "NONE")

call s:hi("PmenuSel", "NONE", s:fg, s:bg_alt, "bold", "bold")

call s:hi("PmenuThumb", "NONE", "NONE", s:bg_highlight, "NONE", "NONE")
call s:hi("WildMenu", "NONE", "NONE", s:bg_highlight, "NONE", "NONE")

call s:hi("QuickFixLine", "NONE", "NONE", s:bg_alt, "bold", "bold")
call s:hi("Visual", "NONE", "NONE", s:bg_alt, "bold", "bold")
call s:hi("VisualNOS", "NONE", "NONE", s:bg_alt, "bold", "bold")

call s:hi("Search", "NONE", s:pink, s:bg_alt, "bold", "bold")

call s:hi("SignColumn", "NONE", s:bg_alt, s:bg, "NONE", "NONE")

call s:hi("SpecialKey", "NONE", s:grey, "NONE", "NONE", "NONE")

call s:hi("Statement", "NONE", s:magenta, "NONE", "NONE", "NONE")

call s:hi("StatusLineNC", "NONE", s:bg_alt, s:bg_alt, "NONE", "NONE")
call s:hi("StatusLineTermNC", "NONE", s:bg_alt, s:bg_alt, "NONE", "NONE")
call s:hi("TabLine", "NONE", s:bg_alt, s:bg_alt, "NONE", "NONE")

call s:hi("StatusLineTerm", "NONE", s:fg, s:bg_alt, "NONE", "NONE")

call s:hi("StorageClass", "NONE", s:yellow, "NONE", "NONE", "NONE")
call s:hi("Structure", "NONE", s:yellow, "NONE", "NONE", "NONE")
call s:hi("Typedef", "NONE", s:yellow, "NONE", "NONE", "NONE")
call s:hi("WarningMsg", "NONE", s:yellow, "NONE", "NONE", "NONE")

call s:hi("String", "NONE", s:green, "NONE", "NONE", "NONE")

call s:hi("TabLineSel", "NONE", s:green, s:bg_alt, "NONE", "NONE")

call s:hi("Terminal", "NONE", s:fg, s:bg, "NONE", "NONE")

call s:hi("Title", "NONE", s:blue, "NONE", "bold", "bold")

call s:hi("Todo", "NONE", s:bg, s:pink, "bold", "bold")

call s:hi("Underlined", "NONE", s:fg, s:bg, "underline", "underline")

call s:hi("VertSplit", "NONE", s:bg_alt, "NONE", "NONE", "NONE")

" Set terminal colors for playing well with plugins like fzf
let g:terminal_ansi_colors = [
  \ s:bg_alt, s:red, s:green, s:yellow, s:blue, s:pink, s:cyan, s:grey,
  \ s:bg_alt, s:red, s:green, s:yellow, s:blue, s:pink, s:cyan, s:grey
\ ]

" pheenty's extra settings

set number
set relativenumber
autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber
set mouse=a
set cursorline
set clipboard=unnamedplus
