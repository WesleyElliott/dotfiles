syntax enable                   " enable syntax processing
set tabstop=4                   " number of visual spaces for TAB
set softtabstop=4               " number of spaces in TAB when editing
set expandtab                   " tabs are spaces
set number                      " show line numbers
set wildmenu                    " visual autocomplete for commands menu (use TAB to see)
au Filetype gitcommit set tw=72 " for git messages, wrap text to 72 chars

" yml config
au! BufNewFile,BufReadPost *.{yml,yaml} set filetype=yaml
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
