" Use solarized dark theme
syntax enable
set background=dark
colorscheme solarized

set nocompatible
set gdefault
set incsearch
set title
set showcmd

set tabstop=4
set softtabstop=4
set expandtab				" tabs are spaces
set number
set wildmenu				" visual autocomplete for commands menu
au Filetype gitcommit set tw=72		" for git messages, wrap text to 72 chars


" yaml config
au! BufNewFile,BufReadPost *.{yml,yaml} set filetype=yaml
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab


