call plug#begin('~/.config/nvim/plugged')

Plug 'SirVer/ultisnips'
Plug 'folke/zen-mode.nvim'
Plug 'gbrlsnchs/telescope-lsp-handlers.nvim'
Plug 'glepnir/galaxyline.nvim'
Plug 'hrsh7th/nvim-compe'
Plug 'jiangmiao/auto-pairs'
Plug 'jvgrootveld/telescope-zoxide'
Plug 'kosayoda/nvim-lightbulb'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'kyazdani42/nvim-web-devicons' 
Plug 'lewis6991/gitsigns.nvim'
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
Plug 'ojroques/nvim-bufdel'
Plug 'onsails/lspkind-nvim'
Plug 'ray-x/lsp_signature.nvim'
Plug 'rktjmp/lush.nvim'
Plug 'scrooloose/nerdcommenter'
Plug 'simrat39/rust-tools.nvim'
Plug 'tami5/sql.nvim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'windwp/nvim-autopairs'
call plug#end()

let g:nvim_config_root = stdpath('config')

let g:vim_config_file_list = [
    \ 'variables.vim',
    \ 'colorscheme.vim',
    \ 'mapping.vim',
    \ 'custom.vim',
    \ 'plugin.vim',
    \ 'compe-config.vim',
    \ 'lsp-pylsp.vim',
    \ 'lsp-clangd.vim',
    \ 'lsp-rust-analyser.vim',
    \ 'lsp-sumneko-lua-config.vim',
    \ 'lsp-efm.vim',
    \ 'treesitter-config.vim',
    \ 'telescope-config.vim',
    \ 'nvim-tree-config.vim',
    \ 'zen-config.vim',
    \ 'gitsigns-config.vim',
    \ ]

let g:lua_config_file_list = [
    \ 'galaxyline-config.lua',
    \ 'lsp-signature-config.lua'
    \]



for f in g:vim_config_file_list
	    execute 'source ' . g:nvim_config_root . '/vim_files/' . f
    endfor
    
for f in g:lua_config_file_list
	    execute 'luafile  ' . g:nvim_config_root . '/lua/' . f
    endfor
