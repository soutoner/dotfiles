" -- Vundle
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo

" Vim Colorschemes
Plugin 'flazz/vim-colorschemes'
" Vim fugitive (git integration)
Plugin 'tpope/vim-fugitive'
" NERD Tree
Plugin 'scrooloose/nerdtree'
" Vim auto-save
Plugin 'vim-scripts/vim-auto-save'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on

" -- General configs
syntax on
colorscheme codeschool
set guifont=Inconsolata\ 16 
set splitright
" Set line number
set number
" Tab specific option
set tabstop=8                   "A tab is 8 spaces
set expandtab                   "Always uses spaces instead of tabs
set softtabstop=4               "Insert 4 spaces when tab is pressed
set shiftwidth=4                "An indent is 4 spaces
set shiftround                  "Round indent to nearest shiftwidth multiple

" -- NERDTree configs
map <F2> :NERDTreeToggle<CR>
" CDC = Change to Directory of Current file
command CDC cd %:p:h

" -- Vim auto-save configs
let g:auto_save = 1  " enable AutoSave on Vim startup
let g:auto_save_no_updatetime = 1  " do not change the 'updatetime' option
"let g:auto_save_in_insert_mode = 0  " do not save while in insert mode
