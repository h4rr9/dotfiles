call plug#begin('~/AppData/Local/nvim/plugged')

Plug 'gruvbox-community/gruvbox'
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdcommenter'
Plug 'mbbill/undotree'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'hrsh7th/nvim-compe'
Plug 'neovim/nvim-lspconfig'
Plug 'glepnir/lspsaga.nvim'
Plug 'ryanoasis/vim-devicons'
Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'itchyny/lightline.vim'
Plug 'shinchu/lightline-gruvbox.vim'
Plug 'tpope/vim-surround'
Plug 'windwp/nvim-autopairs'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'SirVer/ultisnips'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-frecency.nvim'
Plug 'tami5/sql.nvim'
Plug 'onsails/lspkind-nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
call plug#end()

let g:nvim_config_root = stdpath('config')
let g:config_file_list = ['variables.vim',
    \ 'colorscheme.vim',
    \ 'mapping.vim',
    \ 'custom.vim',
    \ 'plugin.vim',
    \ 'compe-config.vim',
    \ 'lsp-pyright.vim',
    \ 'lsp-clangd.vim',
    \ 'saga-config.vim',
    \ 'treesitter-config.vim',
    \ 'telescope-config.vim'
    \ ]


for f in g:config_file_list
    execute 'source ' . g:nvim_config_root . '\vim_files\' . f
endfor

" :TODO remove this later
