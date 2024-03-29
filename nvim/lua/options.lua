local g = vim.g
local opt = vim.opt

-- basic
opt.mouse = 'a'
opt.title = true
opt.swapfile = false
opt.undofile = true
opt.undodir = '/home/h4rr9/.local/share/nvim/undodir'
opt.cmdheight = 1
opt.termguicolors = true
opt.showmode = false
opt.swapfile = false
opt.writebackup = false
opt.switchbuf = 'useopen'
opt.scrolloff = 25
opt.guicursor = nil
opt.shell = '/bin/bash'

-- timeout stuff
opt.updatetime = 50
opt.timeout = true
opt.timeoutlen = 500
opt.ttimeoutlen = 10

-- status, tab, number, signline
opt.ruler = false
opt.laststatus = 3 -- global statusline
opt.showtabline = 1
opt.number = true
opt.numberwidth = 1
opt.relativenumber = true
opt.signcolumn = 'yes'

-- window, buffer, tabs
opt.splitbelow = true
opt.splitright = true
opt.hidden = true
opt.fillchars.vert = '│'

-- text formatting
opt.encoding = 'utf-8'
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true
opt.showmatch = true
opt.smartcase = true
opt.whichwrap:append '<>[]hl'
opt.wrap = false
opt.shiftround = true
opt.textwidth = 79
opt.foldmethod = 'expr'
opt.foldexpr = 'nvim_treesitter#foldexpr()'
opt.foldenable = false

-- remove intro
opt.shortmess:append 'sI'

-- search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false

-- shell
opt.shell = '/usr/bin/zsh'

-- cursor
opt.cursorline = true

-- clipboard
opt.clipboard = 'unnamedplus'

-- python virtualenv
g.python3_host_prog = '/home/h4rr9/.pyenv/versions/neovim/bin/python'

-- cmp
opt.completeopt = {'menu', 'menuone', 'noselect'}
g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'}

-- disable inbuilt vim plugins
local built_ins = {
    '2html_plugin', 'getscript', 'getscriptPlugin', 'gzip', 'logipat', 'netrw', 'netrwPlugin', 'netrwSettings', 'netrwFileHandlers', 'matchit', 'tar',
    'tarPlugin', 'rrhelper', 'spellfile_plugin', 'vimball', 'vimballPlugin', 'zip', 'zipPlugin'
}

vim.api.nvim_exec([[
    let &t_Ts = "\e[9m"   " Strikethrough
    let &t_Te = "\e[29m"
    let &t_Cs = "\e[4:3m" " Undercurl
    let &t_Ce = "\e[4:0m"
]], false)

for _, plugin in pairs(built_ins) do g['loaded_' .. plugin] = 1 end
