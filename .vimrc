" A sample vimrc file.
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc
" History:
"   Bram Moolenaar / Created
"   Abe Pralle / Modified 2006.08.27

"----Bram's Original Configuration------------------------------------

" Don't try too hard to be backwards-compatible with "vi".
set nocompatible

set autochdir

execute pathogen#infect()

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

set visualbell

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
  set backupdir=c:/Tmp,c:/Temp,~/Backup,.
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvs<C-R>=current_reg<CR><Esc>

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  au BufRead,BufNewFile *.rogue set filetype=rogue 
  au BufRead,BufNewFile *.bard set filetype=bard 
  au BufRead,BufNewFile *.slag set filetype=bard 
  au BufRead,BufNewFile *.orbit set filetype=orbit 
  au BufRead,BufNewFile *.m set filetype=objc
  au BufRead,BufNewFile *.mm set filetype=objcpp
  let g:alternateExtensions_{'m'} = "h"
  let g:alternateExtensions_{'mm'} = "h"
  let g:alternateExtensions_{'h'} = "m,mm,c,cpp"

  filetype indent on
  syntax on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  "autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

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


"----Abe's Modified Configuration-------------------------------------

behave xterm
set mousemodel=popup_setpos

" Prevent popup window for tab completion.
set completeopt=

" When you're doing TAB completion, fix the case of the letters
" you've already typed to match that of the word.
set infercase

" Set the font to 14pt Lucida_Console.
"set gfn=Lucida_Console:h14
set guifont=Menlo:h14

" Don't start jumping to search matches while you're still typing.
set noincsearch

" Searches for all-lower-case letters match upper-case as well.
set ignorecase

" If your search word contains upper case, match exact case for all 
" letters.
set smartcase

" Perform word wrapping.
set linebreak

" Make the tilde (~) an operator instead of a command.  This lets
" you type "~w" to change toggle the case of a word instead of
" just a single letter toggling as soon as you type "~".
set tildeop

" Set the number of spaces used for each manual and auto indent.
set shiftwidth=2

" Mixes actual 8-space TABs and single spaces to get the number of
" spaces you specify here.  For example, hitting [TAB] 3 times would
" give you 6 spaces, 4 times would give you a single TAB, and 5
" times would give you a TAB and 2 spaces.
set softtabstop=2

set tabstop=2

" Expands any tab characters you type to be the corresponding number 
" of spaces.
set et

" Sets the number of lines the cursor can be from the top or bottom
" of the screen before the screen scrolls to reveal more text.
set scrolloff=3

" take out default interpretation of octal,hex for ^A (add/increment)
set nrformats=

colors darkblue

" Set [TAB] to cycle through the auto-complete possibilities of a 
" word you're typing.  The possibilities come from other words in
" the current file and other files you're editing.
function! CleverTab()
   if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
      return "\<Tab>"
   else
      return "\<C-N>"
endfunction

inoremap <Tab> <C-R>=CleverTab()<CR>

set formatoptions=t

" When copying & pasting over a Unix terminal, you may need
" to turn off either cindent (:set nocindent), smartindent (:set nosi),
" or autoindent (:set noai).  Or you can uncomment one or all of the
" following lines.
" set nocindent
" set nosi
" set noai

" CDC = Change to Directory of Current file
command CDC lcd %:p:h

" Moves cursor to last known position when opening a file
au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \  execute 'normal! g`"zvzz' |
        \ endif

" Remove trailing whitespace from files
"autocmd FileType c,cpp,java,php,rogue autocmd BufWritePre <buffer> :%s/\s\+$//e
autocmd BufWritePre * :%s/\s\+$//e


