call plug#begin('~/.config/nvim/plugged')

Plug 'SirVer/ultisnips'
Plug 'folke/zen-mode.nvim'
Plug 'gbrlsnchs/telescope-lsp-handlers.nvim'
Plug 'hoob3rt/lualine.nvim'
Plug 'hrsh7th/nvim-compe'
Plug 'jiangmiao/auto-pairs'
Plug 'jvgrootveld/telescope-zoxide'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'kyazdani42/nvim-web-devicons' 
Plug 'mbbill/undotree'
Plug 'mhinz/vim-startify'
Plug 'neovim/nvim-lspconfig'
Plug 'npxbr/gruvbox.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope-frecency.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'nvim-telescope/telescope-symbols.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'onsails/lspkind-nvim'
Plug 'rktjmp/lush.nvim'
Plug 'scrooloose/nerdcommenter'
Plug 'tami5/sql.nvim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'windwp/nvim-autopairs'
Plug 'kosayoda/nvim-lightbulb'
Plug 'lewis6991/gitsigns.nvim'
Plug 'ojroques/nvim-bufdel'
call plug#end()

let g:nvim_config_root = stdpath('config')

let g:vim_config_file_list = [
    \ 'variables.vim',
    \ 'colorscheme.vim',
    \ 'mapping.vim',
    \ 'custom.vim',
    \ 'plugin.vim',
    \ 'compe-config.vim',
    \ 'lsp-pyright.vim',
    \ 'lsp-clangd.vim',
    \ 'lsp-rust-analyser.vim',
    \ 'lsp-sumneko-lua-config.vim',
    \ 'lsp-efm.vim',
    \ 'treesitter-config.vim',
    \ 'telescope-config.vim',
    \ 'lualine-config.vim',
    \ 'nvim-tree-config.vim',
    \ 'zen-config.vim',
    \ 'gitsigns-config.vim',
    \ ]

let g:lua_config_file_list = [
   "\ 'runner/init.lua'
    \]



for f in g:vim_config_file_list
	    execute 'source ' . g:nvim_config_root . '/vim_files/' . f
    endfor
    
for f in g:lua_config_file_list
	    execute 'luafile  ' . g:nvim_config_root . '/lua_files/' . f
    endfor
