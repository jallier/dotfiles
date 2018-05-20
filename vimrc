set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" " alternatively, pass a path where Vundle should install plugins
" "call vundle#begin('~/some/path/here')
"
" " let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'easymotion/vim-easymotion'
Bundle "myusuf3/numbers.vim"
Plugin 'tpope/vim-surround'
Plugin 'scrooloose/nerdtree'
Plugin 'Valloric/YouCompleteMe'
Plugin 'auto-pairs-gentle'
Bundle 'gabrielelana/vim-markdown'
Plugin 'bling/vim-airline'
Plugin 'kien/ctrlp.vim'
Plugin 'dbeniamine/todo.txt-vim'
Plugin 'mileszs/ack.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'stanangeloff/php.vim'
Plugin 'shawncplus/phpcomplete.vim'
Bundle 'bash-support.vim'
Plugin 'hdima/python-syntax'
Plugin 'ludovicchabant/vim-gutentags'
"
" " All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

set autoindent
au BufReadPost *.ijm set syntax=javascript

" Map moving between splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Map launching markdown in a browser. 
nnoremap <F5> :w !pandoc --css ~/dotfiles/bg.css --self-contained \| bcat<CR>

" Map running current program
nnoremap <F9> :!%:p<Enter>

" Setup ag
let g:ackprg = 'ag --vimgrep'

" Set tabs to be 4 spaces
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab

" Set the leader to be spacebar
:let mapleader = "\<Space>"

set linebreak
