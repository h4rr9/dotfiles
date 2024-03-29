-- Ui highlight color groups
--
-- This file contains the highlight group definitions for both:
--   - feline (statusline)
--   - tabby (tabline)
--
-- The colors are pulled from the current applied colorscheme.  This requires
-- that your colorscheme defines the highlight groups queried as well as
-- neovim's vim.g.terminal_color_* (s).
--
-- There is an autocmd that regenerates the highlight group colors on
-- colorscheme change.
local function fromhl(hl)
    local result = {}
    local list = vim.api.nvim_get_hl_by_name(hl, true)
    for k, v in pairs(list) do
        local name = k == 'background' and 'bg' or 'fg'
        result[name] = string.format('#%06x', v)
    end
    return result
end

local function term(num, default)
    local key = 'terminal_color_' .. num
    return vim.g[key] and vim.g[key] or default
end

local function colors_from_theme()
    return {
        bg = fromhl('StatusLine').bg or '#2E3440',
        alt = fromhl('CursorLine').bg or '#475062',
        fg = fromhl('StatusLine').fg or '#8FBCBB',
        hint = fromhl('DiagnosticHint').bg or '#658594',
        info = fromhl('DiagnosticInfo').bg or '#6A9589',
        warn = fromhl('DiagnosticWarn').bg or '#FF9E3B',
        err = fromhl('DiagnosticError').bg or '#E82424',
        black = term(0, '#090618'),
        red = term(1, '#C34043'),
        green = term(2, '#76946A'),
        yellow = term(3, '#C0A36E'),
        blue = term(4, '#7E9CD8'),
        magenta = term(5, '#957FB8'),
        cyan = term(6, '#6A9589'),
        white = term(7, '#C8C093')
    }
end

vim.cmd [[colorscheme kanagawa]]

local c = colors_from_theme()
local sfg = vim.o.background == 'dark' and c.black or c.white
local sbg = vim.o.background == 'dark' and c.white or c.black
local ct = {tabl = fromhl('TabLine'), norm = fromhl('Normal'), sel = fromhl('TabLineSel'), fill = fromhl('TabLineFill')}
local groups = {
    FlnViBlack = {fg = c.white, bg = c.black, bold = true},
    FlnViRed = {fg = c.bg, bg = c.red, bold = true},
    FlnViGreen = {fg = c.bg, bg = c.green, bold = true},
    FlnViYellow = {fg = c.bg, bg = c.yellow, bold = true},
    FlnViBlue = {fg = c.bg, bg = c.blue, bold = true},
    FlnViMagenta = {fg = c.bg, bg = c.magenta, bold = true},
    FlnViCyan = {fg = c.bg, bg = c.cyan, bold = true},
    FlnViWhite = {fg = c.bg, bg = c.white, bold = true},

    FlnBlack = {fg = c.black, bg = c.white, bold = true},
    FlnRed = {fg = c.red, bg = c.bg, bold = true},
    FlnGreen = {fg = c.green, bg = c.bg, bold = true},
    FlnYellow = {fg = c.yellow, bg = c.bg, bold = true},
    FlnBlue = {fg = c.blue, bg = c.bg, bold = true},
    FlnMagenta = {fg = c.magenta, bg = c.bg, bold = true},
    FlnCyan = {fg = c.cyan, bg = c.bg, bold = true},
    FlnWhite = {fg = c.white, bg = c.bg, bold = true},

    -- Diagnostics
    FlnHint = {fg = c.black, bg = c.hint, bold = true},
    FlnInfo = {fg = c.black, bg = c.info, bold = true},
    FlnWarn = {fg = c.black, bg = c.warn, bold = true},
    FlnError = {fg = c.black, bg = c.err, bold = true},
    FlnStatus = {fg = sfg, bg = sbg, bold = true},
    FlnAltStatus = {fg = sbg, bg = sfg, bold = true},
    FlnSigStatus = {fg = c.red, bg = sbg, bold = true},

    -- Dianostic Seperators
    FlnBgHint = {fg = ct.sel.bg, bg = c.hint},
    FlnHintInfo = {fg = c.hint, bg = c.info},
    FlnInfoWarn = {fg = c.info, bg = c.warn},
    FlnWarnError = {fg = c.warn, bg = c.err},
    FlnErrorStatus = {fg = c.err, bg = sbg},
    FlnStatusBg = {fg = sbg, bg = c.bg},

    FlnAlt = {fg = sbg, bg = ct.sel.bg},
    FlnFileInfo = {fg = c.fg, bg = c.alt},
    FlnAltSep = {fg = c.bg, bg = ct.sel.bg},
    FlnGitBranch = {fg = c.yellow, bg = c.bg},
    FlnGitSeperator = {fg = c.bg, bg = c.alt},

    -- Git diagnostic
    FlnGitAdd = {fg = fromhl('GitSignsAdd').fg, bg = c.bg, bold = true},
    FlnGitChange = {fg = fromhl('GitSignsChange').fg, bg = c.bg, bold = true},
    FlnGitRemove = {fg = fromhl('GitSignsDelete').fg, bg = c.bg, bold = true}

}

local colors = require'kanagawa.colors'.setup()
local my_colors = {bg = colors.bg_dim, bg_dim = colors.bg}
require'kanagawa'.setup({colors = my_colors, overrides = groups, globalStatus = true, dimInactive = true})
vim.cmd [[colorscheme kanagawa]]

