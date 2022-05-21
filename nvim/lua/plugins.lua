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
    use 'nvim-telescope/telescope-media-files.nvim'
    use 'nvim-telescope/telescope-fzy-native.nvim'
    use 'gbrlsnchs/telescope-lsp-handlers.nvim'
    use 'nvim-telescope/telescope-symbols.nvim'
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
    use {
        'petertriho/cmp-git',
        requires = 'nvim-lua/plenary.nvim',
        config = function()
            require('cmp_git').setup()
        end
    }
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
    use 'https://git.sr.ht/~p00f/clangd_extensions.nvim'
    use 'simrat39/rust-tools.nvim'

    use 'nvim-lua/lsp-status.nvim'
    use 'ray-x/lsp_signature.nvim'
    use 'lukas-reineke/lsp-format.nvim'
    use 'kosayoda/nvim-lightbulb'
    use 'jose-elias-alvarez/nvim-lsp-ts-utils'

    -- statusline / colortheme
    use {'rebelot/kanagawa.nvim', config = [[require 'config.colors']]}
    use {'feline-nvim/feline.nvim', after = 'kanagawa.nvim', requires = {'kyazdani42/nvim-web-devicons'}, config = [[require 'config.status']]}
    use {'SmiteshP/nvim-gps', requires = 'nvim-treesitter/nvim-treesitter'}

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
    use 'wellle/targets.vim'
    use {
        'folke/todo-comments.nvim',
        requires = 'nvim-lua/plenary.nvim',
        config = function()
            require('todo-comments').setup {}
        end
    }
    use {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup {}
        end
    }
    use {
        'kkoomen/vim-doge',
        run = ':call doge#install()',
        cmd = 'DogeGenerate',
        setup = function()
            vim.g.doge_mapping_comment_jump_forward = '<C-j>'
            vim.g.doge_mapping_comment_jump_backward = '<C-k>'
        end
    }
    use {
        'lervag/vimtex',
        config = function()
            vim.g.vimtex_view_general_viewer = 'sumatraPDF'
            vim.g.vimtex_view_general_options = '-reuse-instance @pdf'
            vim.g.vimtex_view_general_options_latexmk = '-reuse-instance'
        end,
        ft = 'tex'
    }
    use {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            vim.opt.list = true
            vim.opt.listchars:append('eol:↴')
            vim.g.indent_blankline_filetype_exclude = {'alpha', 'man'}
            require'indent_blankline'.setup {show_end_of_line = true, show_current_context = true, show_current_context_start = true}
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
    use {
        'max397574/better-escape.nvim',
        config = function()
            require('better_escape').setup()
        end
    }
    use 'andymass/vim-matchup'
    use {
        'folke/twilight.nvim',
        config = function()
            require('twilight').setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }

    -- markdown
    use {'renerocksai/calendar-vim', cmd = {'Calendar', 'CalendarVR', 'CalendarH', 'CalendarT', 'CalendarSearch'}}
    use {'iamcco/markdown-preview.nvim', ft = {'markdown', 'telekasten'}, run = ':call mkdp#util#install()'}
    use {'mzlogin/vim-markdown-toc', ft = {'markdown', 'telekasten'}}
    use {'dhruvasagar/vim-table-mode', ft = {'markdown', 'telekasten'}}
    use {'mickael-menu/zk-nvim', config = [[require 'config.zk']]}

    -- tpope
    use 'tpope/vim-repeat'
    use 'tpope/vim-surround'
    use 'tpope/vim-unimpaired'
    use 'tpope/vim-eunuch'

end)
