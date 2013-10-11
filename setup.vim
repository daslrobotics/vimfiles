" Pathogen setup to point to bundle folder and load the pathogen script for
" submodules
let g:SuperTabDefaultCompletionType = "<c-n>"
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()

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
set foldmethod=syntax
"set foldenable
set foldlevelstart=4
"let xml_syntax_folding=1

"Search features
set incsearch
set hlsearch
"Use bash-style tab completion
" Hybrid tab completion at prompt acts like BASH for the first 2 tabs, then
" cycles through the results.
set wildmode=longest,list,full
set wildmenu
set iskeyword+=.

"Python mode keywords
let g:pymode_lint_onfly = 1
let g:pymode_lint_cwindow = 1
let g:pymode_lint_ignore = "E2,E501"
let g:pymode_lint_checker="pyflakes"

