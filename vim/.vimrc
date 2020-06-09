
call plug#begin('~/.config/nvim/bundle')


Plug 'wikitopian/hardmode'
Plug 'gruvbox-community/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdcommenter'
Plug 'machakann/vim-highlightedyank'
Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins' }
Plug 'tmhedberg/SimpylFold'
Plug 'mbbill/undotree'
Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'christoomey/vim-tmux-navigator'
Plug 'neoclide/coc.nvim', {'branch' : 'release'}

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
set splitbelow
set splitright
set mouse+=a

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


"Airline theme
let g:airline_theme='minimalist'


"Highlight yank plugin options
hi HighlightedyankRegion cterm=reverse gui=reverse
let g:Highlightedyank_highlight_duration = 1000

"fzf keymaps
map <C-p> <Esc><Esc>:Files!<CR>
inoremap <C-f> <Esc><Esc>:BLines!<CR>

" auto change dir for tabs
function! OnTabEnter(path)
  if isdirectory(a:path)
    let dirname = a:path
  else
    let dirname = fnamemodify(a:path, ":h")
  endif
  execute "tcd ". dirname
endfunction()

autocmd TabNewEntered * call OnTabEnter(expand("<amatch>"))

source $HOME/.config/nvim/plug-config/coc.vim
