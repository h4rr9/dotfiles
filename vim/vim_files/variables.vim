filetype plugin indent on
syntax on

set encoding=utf-8
set number
set relativenumber
set incsearch
set ignorecase
set smartcase
set nohlsearch
set tabstop=4
set softtabstop=0
set shiftwidth=4
set shiftround
set expandtab
set nobackup
set noswapfile
set nowritebackup
set nowrap
set tw=79
set fo-=t
set splitbelow
set splitright
set mouse+=a
set foldmethod=indent
set foldenable
set foldlevelstart=10
set foldnestmax=10
set noshowmode
set hidden
set pastetoggle=<F2>
set bs=2
set switchbuf+=useopen
set shortmess+=c
set undodir=~/.vim/undodir
set undofile
set scrolloff=8
set signcolumn=auto:2
set guicursor=
set cursorline
" set shell
set shell=/bin/bash

set updatetime=50

"python paths
let g:python3_host_prog='/usr/bin/python3'
let g:python_host_prog='/usr/bin/python'

let g:clipboard = {
  \ 'name': 'win32yank',
  \ 'copy': {
  \    '+': 'win32yank.exe -i --crlf',
  \    '*': 'win32yank.exe -i --crlf',
  \  },
  \ 'paste': {
  \    '+': 'win32yank.exe -o --lf',
  \    '*': 'win32yank.exe -o --lf',
  \ },
  \ 'cache_enabled': 0,
  \ }
set clipboard=unnamed
