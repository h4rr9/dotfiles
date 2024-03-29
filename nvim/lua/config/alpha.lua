local alpha = require 'alpha'
local leader = 'SPC'
local if_nil = vim.F.if_nil

local default_header = {type = 'text', val = require 'alpha.fortune'(), opts = {position = 'center', hl = 'Label'}}

local footer = {type = 'text', val = '', opts = {position = 'center', hl = 'Number'}}

local function button(sc, txt, keybind, keybind_opts)
    local sc_ = sc:gsub('%s', ''):gsub(leader, '<leader>')

    local opts = {position = 'center', shortcut = sc, cursor = 5, width = 50, align_shortcut = 'right', hl_shortcut = 'Keyword'}
    if keybind then
        keybind_opts = if_nil(keybind_opts, {noremap = true, silent = true, nowait = true})
        opts.keymap = {'n', sc_, keybind, keybind_opts}
    end

    local function on_press()
        vim.api.nvim_feedkeys(sc, 't', false)
    end

    return {type = 'button', val = txt, on_press = on_press, opts = opts}
end

local buttons = {
    type = 'group',
    val = {
        button('e', '  New file', '<cmd>ene <CR>'), button('f', '  Find file', '<cmd>Telescope find_files<cr>'),
        button('h', '  Recently opened files', '<cmd>Telescope oldfiles<cr>'), button('r', '  Frecency/MRU', '<cmd>Telescope frecency<cr>'),
        button('s', '  Open last session', '<cmd>SessionManager load_last_session<cr>'),
        button('S', '⤿  Browse sessions', '<cmd>SessionManager! load_session<cr>'), button('q', '⎋  Quit nvim', '<cmd>qa<cr>')
    },
    opts = {spacing = 1}
}

local section = {header = default_header, buttons = buttons, footer = footer}

local config = {
    layout = {{type = 'padding', val = 10}, section.header, {type = 'padding', val = 5}, section.buttons, section.footer},
    opts = {margin = 5, noautocmd = true}
}

vim.cmd [[autocmd User AlphaReady echo 'ready']]

alpha.setup(config)
