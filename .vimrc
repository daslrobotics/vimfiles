" Pathogen setup to point to bundle folder and load the pathogen script for
" submodules
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()

" Standard tab settings at 4 spaces instead of tab chars
set shiftwidth=4 tabstop=4 expandtab

" Boilerplate to enable custom tiletype plugins and such
filetype on
filetype plugin indent on
set autoindent 

" Define the mlint compiler for the make commant
autocmd BufEnter *.m compiler mlint

" Enable syntax based folding (this will require additional plugins for odd
" filetypes
set foldenable
set foldlevelstart=3
set foldmethod=syntax
let xml_syntax_folding=1

set ruler
" Advanced search settings
set incsearch
set hlsearch

" Hybrid tab completion at prompt acts like BASH for the first 2 tabs, then
" cycles through the results.
set wildmode=longest,list,full
set wildmenu
