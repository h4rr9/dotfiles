if not pcall(require, 'feline') then return end

local colors = {
    bg = 'none',
    fg = '#FBF1C7',
    yellow = '#D79921',
    cyan = '#689D6A',
    darkblue = '#076678',
    green = '#98971A',
    orange = '#D65D0E',
    magenta = '#B16286',
    violet = '#689D6A',
    blue = '#458588',
    red = '#CC241D'
}

local vi_mode_colors = {
    NORMAL = colors.green,
    INSERT = colors.red,
    VISUAL = colors.magenta,
    OP = colors.green,
    BLOCK = colors.blue,
    REPLACE = colors.violet,
    ['V-REPLACE'] = colors.violet,
    ENTER = colors.cyan,
    MORE = colors.cyan,
    SELECT = colors.orange,
    COMMAND = colors.green,
    SHELL = colors.green,
    TERM = colors.green,
    NONE = colors.yellow
}

local function file_osinfo()
    local os = vim.bo.fileformat:upper()
    local icon
    if os == 'UNIX' then
        icon = ' '
    elseif os == 'MAC' then
        icon = ' '
    else
        icon = ' '
    end
    return icon .. os
end

local lsp = require 'feline.providers.lsp'
local vi_mode_utils = require 'feline.providers.vi_mode'

local lsp_get_diag = function(str)
    local count = vim.lsp.diagnostic.get_count(0, str)
    return (count > 0) and ' ' .. count .. ' ' or ''
end

local comps = {
    vi_mode = {
        left = {
            provider = function()
                return '  ' .. vi_mode_utils.get_vim_mode()
            end,
            hl = function()
                local val = {
                    name = vi_mode_utils.get_mode_highlight_name(),
                    fg = vi_mode_utils.get_mode_color()
                    -- fg = colors.bg
                }
                return val
            end,
            right_sep = ' '
        },
        right = {
            -- provider = '▊',
            provider = '',
            hl = function()
                local val = {name = vi_mode_utils.get_mode_highlight_name(), fg = vi_mode_utils.get_mode_color()}
                return val
            end,
            left_sep = ' ',
            right_sep = ' '
        }

    }
}

local components = {active = {{}, {}, {}}, inactive = {{}, {}, {}}}
table.insert(components.active[1], comps.vi_mode.left)

require'feline'.setup {
    colors = {bg = 'none', fg = 'none'},
    components = components,
    vi_mode_colors = vi_mode_colors,
    force_inactive = {
        filetypes = {'packer', 'NvimTree', 'fugitive', 'fugitiveblame', 'Trouble', 'vista', 'dbui', 'qf', 'startify', 'vim-plug', 'testcases-status'},
        buftypes = {'terminal'},
        bufnames = {}
    }
}

