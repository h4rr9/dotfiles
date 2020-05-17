call plug#begin('~/.config/nvim/bundle')


Plug 'wikitopian/hardmode'
Plug 'gruvbox-community/gruvbox'


call plug#end()


" basics
filetype off
filetype plugin indent on
syntax on 
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
set cursorline


"Better Copy Paste
set pastetoggle=<F2>
set clipboard=unnamed


"Normal backspace
set bs=2


"Indent block
vmap <Tab> >gv
vmap <S-Tab> <gv


"map leader key
noremap <Space> <Nop>
let mapleader = "\<Space>"


"Quick Exit
noremap <Leader>e :wq!<CR> "current tab
noremap <Leader>E :wqa!<CR> "all tabs


"move around windows
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h


"move around tabs
map <Leader>n <esc>:tabprevious<CR>
map <Leader>m <esc>:tabnext<CR>

"Sort function to Key
vnoremap <Leader>s :sort<CR>


"Theme
syntax enable
set background=dark
let g:gruvbox_contrast_dark = 'hard'
colorscheme gruvbox


"HardMode Plugin
let g:HardMode_level = 'wannabe'
let g:HardMode_hardmodeMsg = 'Don''t use this!'
autocmd VimEnter,BufNewFile,BufReadPost * silent! call HardMode()


"Automatic loading of init.vim
autocmd! bufwritepost init.vim source %
