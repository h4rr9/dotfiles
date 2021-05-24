call plug#begin('~/AppData/Local/nvim/plugged')

Plug 'gruvbox-community/gruvbox'
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdcommenter'
Plug 'neoclide/coc-yank'
Plug 'mbbill/undotree'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}
Plug 'jackguo380/vim-lsp-cxx-highlight'
Plug 'ryanoasis/vim-devicons'
Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'itchyny/lightline.vim'
Plug 'shinchu/lightline-gruvbox.vim'
Plug 'tpope/vim-surround'
Plug 'windwp/nvim-autopairs'
Plug 'ctrlpvim/ctrlp.vim'
call plug#end()

let g:nvim_config_root = stdpath('config')
let g:config_file_list = ['variables.vim',
    \ 'colorscheme.vim',
    \ 'mapping.vim',
    \ 'custom.vim',
    \ 'coc.vim',
    \ 'plugin.vim'
    \ ]


for f in g:config_file_list
    execute 'source ' . g:nvim_config_root . '\.vim\' . f
endfor
