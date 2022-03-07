vim.cmd [[ packadd packer.nvim ]]

return require('packer').startup(function(use)
    -- packer
    use 'wbthomason/packer.nvim'

    -- treesitter
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', config = [[require 'config.treesitter']]}
    use 'RRethy/nvim-treesitter-textsubjects'
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    use 'JoosepAlviste/nvim-ts-context-commentstring'

    -- git
    use {
        'lewis6991/gitsigns.nvim',
        requires = {'nvim-lua/plenary.nvim'},
        config = function()
            require('gitsigns').setup()
        end
    }
    use {'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim'}
    use {'tpope/vim-fugitive', cmd = 'Git'}

    -- telescope
    use {'nvim-telescope/telescope.nvim', requires = {'nvim-lua/plenary.nvim'}, config = [[require 'config.telescope']]}
    use 'nvim-telescope/telescope-ui-select.nvim'
    use 'nvim-telescope/telescope-fzy-native.nvim'
    use 'gbrlsnchs/telescope-lsp-handlers.nvim'
    use 'nvim-telescope/telescope-file-browser.nvim'
    use {
        'AckslD/nvim-neoclip.lua',
        requires = {{'tami5/sqlite.lua', module = 'sqlite'}, {'nvim-telescope/telescope.nvim'}},
        config = function()
            require('neoclip').setup()
        end
    }
    use {
        'nvim-telescope/telescope-frecency.nvim',
        config = function()
            require'telescope'.load_extension('frecency')
        end,
        requires = {'tami5/sqlite.lua'}
    }

    -- completion / snippets
    use {'hrsh7th/nvim-cmp', requires = 'onsails/lspkind-nvim', config = [[require 'config.cmp']]}
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-calc'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'saadparwaiz1/cmp_luasnip'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-nvim-lua'
    use {'L3MON4D3/LuaSnip', config = [[require'config.luasnip']]}
    use 'rafamadriz/friendly-snippets'
    use 'lukas-reineke/cmp-under-comparator'

    -- lsp
    use {
        'neovim/nvim-lspconfig',
        requires = {'ray-x/lsp_signature.nvim', 'lukas-reineke/lsp-format.nvim', 'p00f/clangd_extensions.nvim'},
        config = [[require 'config.lsp']]
    }
    use 'p00f/clangd_extensions.nvim'
    use 'simrat39/rust-tools.nvim'
    use 'nvim-lua/lsp-status.nvim'
    use 'ray-x/lsp_signature.nvim'
    use 'lukas-reineke/lsp-format.nvim'
    use 'kosayoda/nvim-lightbulb'

    -- statusline / colortheme
    use 'rebelot/kanagawa.nvim'
    use {
        'feline-nvim/feline.nvim',
        requires = {'kyazdani42/nvim-web-devicons', 'rebelot/kanagawa.nvim'},
        setup = [[require 'colors']],
        config = [[require 'config.status']]
    }

    -- navigation
    use 'ggandor/lightspeed.nvim'
    use 'christoomey/vim-tmux-navigator'

    -- nice things
    use {
        'ojroques/nvim-bufdel',
        config = function()
            require('bufdel').setup {next = 'alternate'}
        end
    }
    use {
        'folke/todo-comments.nvim',
        requires = 'nvim-lua/plenary.nvim',
        config = function()
            require('todo-comments').setup {}
        end,
        cmd = 'TodoTelescope'
    }
    use {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup {}
        end
    }
    use {'kkoomen/vim-doge', run = ':call doge#install()', cmd = 'DogeGenerate'}
    use {
        'lervag/vimtex',
        config = function()
            vim.g.vimtex_view_general_viewer = 'sumatraPDF'
            vim.g.vimtex_view_general_options = '-reuse-instance @pdf'
            vim.g.vimtex_view_general_options_latexmk = '-reuse-instance'
        end,
        cmd = 'VimtexCompile'
    }
    use {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            vim.g.indent_blankline_filetype_exclude = {'alpha'}
        end
    }
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup({mappings = {extended = true}})
        end
    }

    use {'mbbill/undotree', cmd = 'UndotreeToggle'}

    use {'goolord/alpha-nvim', config = [[require 'config.alpha']]}
    use {
        'Shatur/neovim-session-manager',
        config = function()
            require'session_manager'.setup({autoload_mode = require('session_manager.config').AutoloadMode.Disabled})
        end
    }
    use 'tami5/sqlite.lua'
    use 'dstein64/vim-startuptime'

    -- tpope

    use 'tpope/vim-repeat'
    use 'tpope/vim-surround'
    use 'tpope/vim-unimpaired'
    use 'tpope/vim-eunuch'

end)
