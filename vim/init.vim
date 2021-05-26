call plug#begin('~/.config/nvim/plugged')

Plug 'SirVer/ultisnips'
Plug 'eddyekofo94/gruvbox-flat.nvim'
Plug 'glepnir/lspsaga.nvim'
Plug 'hoob3rt/lualine.nvim'
Plug 'hrsh7th/nvim-compe'
Plug 'jiangmiao/auto-pairs'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'mbbill/undotree'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope-frecency.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'onsails/lspkind-nvim'
Plug 'scrooloose/nerdcommenter'
Plug 'shinchu/lightline-gruvbox.vim'
Plug 'tami5/sql.nvim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'windwp/nvim-autopairs'

call plug#end()

let g:nvim_config_root = stdpath('config')

let g:config_file_list = [
    \ 'variables.vim',
    \ 'colorscheme.vim',
    \ 'mapping.vim',
    \ 'custom.vim',
    \ 'plugin.vim',
    \ 'compe-config.vim',
    \ 'lsp-pyright.vim',
    \ 'lsp-clangd.vim',
    \ 'treesitter-config.vim',
    \ 'telescope-config.vim',
    \ 'lualine-config.vim',
    \ 'nvim-tree-config.vim'
    \ ]





for f in g:config_file_list
	    execute 'source ' . g:nvim_config_root . '/vim_files/' . f
    endfor
    
