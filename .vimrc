runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
set shiftwidth=4 tabstop=4 expandtab
filetype on
filetype plugin indent on
set autoindent 
autocmd BufEnter *.m compiler mlint
let g:xml_syntax_folding = 1

set foldmethod=indent
set foldlevel=99
set ruler
"Search features
set incsearch
set hlsearch
set ignorecase smartcase
