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

" Searching using fzf
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

" Rust dev
Plugin 'rust-lang/rust.vim'

" Plugin 'autozimu/languageclient-neovim'
Plugin 'neoclide/coc.nvim'

" Ale
Plugin 'dense-analysis/ale'

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
" Use \1,2,3 for tab switching
nnoremap <Leader>1 1gt
nnoremap <Leader>2 2gt
nnoremap <Leader>3 3gt
nnoremap <Leader>4 4gt


" General settings
" ----------------
let $FZF_DEFAULT_COMMAND = 'ag --hidden -g ""'
nmap <C-p> :FZF<CR>
nmap <C-S-p> :Files<CR>

" Cycle buffers using Tab and Shift-Tab
nnoremap <silent> <Leader><TAB> :bn<CR>
nnoremap <silent> <Leader><S-TAB> :bp<CR>

" Clear the searching highlighting until next search using double Esc
nnoremap <silent> <Esc><Esc> :nohls<CR>

" Auto update a file if its changed externally
set autoread
" Show line numbers
set number
" Visual autocomplete for commands menu (using Tab)
set wildmenu
" Enable syntax highlighting
syntax enable
set encoding=utf-8
" Wrap git messages to 72 chars
au Filetype gitcommit set tw=72
" Dont show current mode, airline does this for us
set noshowmode
" Always show the tabline
set showtabline=2
set laststatus=2
set nowrap

set mouse=a

" Airline config
" --------------
let g:airline_theme='solarized'
let g:airline_powerline_fonts=1
let g:airline_solarized_bg='dark'
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#formatter='unique_tail'
let g:airline#extensions#tabline#buffer_nr_show=1
let g:airline_section_y=''
let g:ariline_skip_empty_sections=1

" Language server config
" ======================
set hidden
set cmdheight=2
set updatetime=300

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

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
