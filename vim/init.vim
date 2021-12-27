call plug#begin('~/.config/nvim/plugged')

" treesitter
Plug 'RRethy/nvim-treesitter-textsubjects'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'

" lsp
Plug 'L3MON4D3/LuaSnip'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-calc'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'kosayoda/nvim-lightbulb'
Plug 'lukas-reineke/cmp-under-comparator'
Plug 'neovim/nvim-lspconfig'
Plug 'octaltree/cmp-look'
Plug 'onsails/lspkind-nvim'
Plug 'ray-x/lsp_signature.nvim'
Plug 'scalameta/nvim-metals'
Plug 'simrat39/rust-tools.nvim'
Plug 'rafamadriz/friendly-snippets'

" dap
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'

" statusline and colorscheme and icons
Plug 'glepnir/galaxyline.nvim'
Plug 'h4rr9/gruvbox.nvim'
Plug 'kyazdani42/nvim-web-devicons' 

" navigation
Plug 'ggandor/lightspeed.nvim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'kyazdani42/nvim-tree.lua'

" telescope
Plug 'gbrlsnchs/telescope-lsp-handlers.nvim'
Plug 'jvgrootveld/telescope-zoxide'
Plug 'nvim-telescope/telescope-dap.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'nvim-telescope/telescope-symbols.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-ui-select.nvim'

" git stuff
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-fugitive'

" startup
Plug 'mhinz/vim-startify'
Plug 'dstein64/vim-startuptime'

" tpope
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'

" required
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'rktjmp/lush.nvim'
Plug 'tami5/sql.nvim'

" nice things
Plug 'lukas-reineke/indent-blankline.nvim' 
Plug 'folke/zen-mode.nvim'
Plug 'mbbill/undotree'
Plug 'ojroques/nvim-bufdel'
Plug 'windwp/nvim-autopairs'
Plug 'gauteh/vim-cppman'

" comments
Plug 'scrooloose/nerdcommenter'
Plug 'kkoomen/vim-doge', {'do': { -> doge#install({ 'headless': 1 }) }}
Plug 'folke/todo-comments.nvim'

" Tex
Plug 'lervag/vimtex'
call plug#end()

let g:nvim_config_root = stdpath('config')

let g:vim_config_file_list = [
    \ 'variables.vim',
    \ 'colorscheme.vim',
    \ 'mapping.vim',
    \ 'custom.vim',
    \ 'plugin.vim',
    \ 'lsp-efm.vim',
    \ 'lsp-pylsp.vim',
    \ 'lsp-clangd.vim',
    \ 'lsp-rust-analyser.vim',
    \ 'lsp-sumneko-lua-config.vim',
    \ 'lsp-metals.vim',
    \ 'lsp-cmake.vim',
    \ 'lsp-tsserver.vim',
    \ 'treesitter-config.vim',
    \ 'telescope-config.vim',
    \ 'nvim-tree-config.vim',
    \ 'zen-config.vim',
    \ 'gitsigns-config.vim',
    \ 'dap_config.vim',
    \ ]

let g:lua_config_file_list = [
    \ 'galaxyline-config.lua',
    \ 'lsp-signature-config.lua',
    \ 'cmp-config.lua',
    \ 'luasnip-config.lua'
    \]



for f in g:vim_config_file_list
	    execute 'source ' . g:nvim_config_root . '/vim_files/' . f
    endfor
    
for f in g:lua_config_file_list
	    execute 'luafile  ' . g:nvim_config_root . '/lua/' . f
    endfor
