" Don't try to be backwards compatible
set nocompatible

" Load file-type specific plugins and indent definitions
filetype plugin indent on

" Backup files
if isdirectory($HOME . '/.vim/backup') == 0
  :silent !mkdir -p ~/.vim/backup >/dev/null 2>&1
endif
set backupdir-=.
set backupdir+=.
set backupdir-=~/
set backupdir^=~/.vim/backup/
set backupdir^=./.vim-backup/
set backup

" Swap files
if isdirectory($HOME . '/.vim/swap') == 0
  :silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=./.vim-swap//
set directory+=~/.vim/swap//
set directory+=~/tmp//
set directory+=.

" Persistent undo
if exists("+undofile")
  if isdirectory($HOME . '/.vim/undo') == 0
    :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
  endif
  set undodir=./.vim-undo//
  set undodir+=~/.vim/undo//
  set undofile
endif

set viminfo+=n~/.vim/viminfo
set autoread
set ttyfast

" Reduce Esc delay
set ttimeout
set ttimeoutlen=20
set notimeout

" Mouse support
set ttymouse=sgr
set mouse=a

" Use system clipboard
set clipboard=unnamed

" Line numbers
set number

" Wild menu
set wildmenu
set wildmode=longest,list,full
set wildignore+=*/.hg/*,*/.svn/*,*/tmp/cache/*,*/target/*,*/.idea/*,*.class

" 2-space tabs
set softtabstop=2
set shiftwidth=2
set tabstop=2
set expandtab

" Highlight search results
set hlsearch
