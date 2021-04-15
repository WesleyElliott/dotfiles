" Setup Vunlder - plugin managements
set nocompatible
filetype off

" Set runtime path to include Vundler and init
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Plugins
" -------

" File tree explorer
Plugin 'scrooloose/nerdtree'

" Status bar
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" End of plugins. All plugins should be above!
call vundle#end()
filetype plugin indent on

" Custom keybinds
" ---------------

" Toggle NERDTree using \f
nnoremap <Leader>f :NERDTreeToggle<Enter>
" Use arrow keys for moving lines
nnoremap <M-S-Up> :m .-2<CR>==
nnoremap <M-S-Down> :m .+1<CR>==
inoremap <M-S-UP> <Esc>:m .-2<CR>==gi
inoremap <M-S-Down> <Esc>:m .+1<CR>==gi


" General settings
" ----------------

" Auto update a file if its changed externally
set autoread
" Show line numbers
set number                                       
" Visual autocomplete for commands menu (using Tab)
set wildmenu
" Enable syntax highlighting
syntax on
set encoding=utf-8
" Wrap git messages to 72 chars
au Filetype gitcommit set tw=72

" Airline config
" --------------
let g:airline_theme='solarized'
let g:airline_powerline_fonts=1
let g:airline_solarized_bg='dark'

" Colors
" ------
set background=dark
colorscheme solarized

" Text and indentation
" --------------------

" Number of visual spaces for tab: 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4
set softtabstop=4
" Tabs are spacing
set expandtab
" Auto and smart indent
set ai
set si
" Use smart tabs
set smarttab
" A modern backspace behavior
set backspace=indent,eol,start

" Custom startup
" --------------

" Start tree view if we open the directory
if argc() == 1 && argv(0) == '.'
    au VimEnter * NERDTree
    " Auto switch the editor pane
    au VimEnter * wincmd w
endif
