local gl = require('galaxyline')
local condition = require('galaxyline.condition')
local spotify_status = require('nvim-spotify').status
local gls = gl.section
gl.short_line_list = {'Trouble', 'NvimTree', 'vista', 'dbui', 'qf', 'startify', 'fugitive', 'fugitiveblame', 'vim-plug', 'testcases-status'}
spotify_status:start()

X = spotify_status.listen

local colors = {
    bg = "none",
    fg = "#FBF1C7",
    yellow = "#D79921",
    cyan = "#689D6A",
    darkblue = "#076678",
    green = "#98971A",
    orange = "#D65D0E",
    magenta = "#B16286",
    violet = "#689D6A",
    blue = "#458588",
    red = "#CC241D"
}

local function get_mode()
    local map = {
        ['n'] = 'NORMAL',
        ['no'] = 'O-PENDING',
        ['nov'] = 'O-PENDING',
        ['noV'] = 'O-PENDING',
        ['no'] = 'O-PENDING',
        ['niI'] = 'NORMAL',
        ['niR'] = 'NORMAL',
        ['niV'] = 'NORMAL',
        ['v'] = 'VISUAL',
        ['V'] = 'V-LINE',
        [''] = 'V-BLOCK',
        ['s'] = 'SELECT',
        ['S'] = 'S-LINE',
        [''] = 'S-BLOCK',
        ['i'] = 'INSERT',
        ['ic'] = 'INSERT',
        ['ix'] = 'INSERT',
        ['R'] = 'REPLACE',
        ['Rc'] = 'REPLACE',
        ['Rv'] = 'V-REPLACE',
        ['Rx'] = 'REPLACE',
        ['c'] = 'COMMAND',
        ['cv'] = 'EX',
        ['ce'] = 'EX',
        ['r'] = 'REPLACE',
        ['rm'] = 'MORE',
        ['r?'] = 'CONFIRM',
        ['!'] = 'SHELL',
        ['t'] = 'TERMINAL'
    }
    local mode_code = vim.api.nvim_get_mode().mode
    if map[mode_code] == nil then return mode_code end
    return map[mode_code]
end

local function file_readonly()
    if vim.bo.filetype == 'help' then return '' end
    local icon = ''
    if vim.bo.readonly == true then return " " .. icon .. " " end
    return ''
end

gls.left[1] = {
    RainbowRed = {
        provider = function()
            return ' '
        end,
        highlight = {colors.blue, colors.bg}
    }
}
gls.left[2] = {
    ViMode = {
        provider = function()
            -- auto change color according the vim mode
            local mode_color = {
                n = colors.red,
                i = colors.green,
                v = colors.blue,
                [''] = colors.blue,
                V = colors.blue,
                c = colors.magenta,
                no = colors.red,
                s = colors.orange,
                S = colors.orange,
                [''] = colors.orange,
                ic = colors.yellow,
                R = colors.violet,
                Rv = colors.violet,
                cv = colors.red,
                ce = colors.red,
                r = colors.cyan,
                rm = colors.cyan,
                ['r?'] = colors.cyan,
                ['!'] = colors.red,
                t = colors.red
            }

            vim.api.nvim_command('hi GalaxyViMode guifg=' .. mode_color[vim.fn.mode()] .. ' guibg=' .. colors.bg)
            return ' ' .. get_mode() .. ' '
        end,
        highlight = {colors.fg, colors.bg}
    }
}
gls.left[3] = {
    FileIcon = {
        provider = 'FileIcon',
        condition = condition.buffer_not_empty,
        highlight = {require('galaxyline.providers.fileinfo').get_file_icon_color, colors.bg}
    }
}

gls.left[4] = {
    FileName = {
        provider = function()
            local file = vim.fn.expand('%:t')
            local shortened_path = vim.fn.pathshorten(vim.fn.expand('%:.:h'))
            local parent_dir = vim.fn.expand('%:p:h:t')
            local sp_file = shortened_path .. '/' .. file
            if shortened_path == '.' then sp_file = parent_dir .. '/' .. file end
            if vim.fn.empty(file) == 1 then return '' end
            if string.len(file_readonly()) ~= 0 then return sp_file .. file_readonly() end
            local icon = ''
            if vim.bo.modifiable then if vim.bo.modified then return sp_file .. ' ' .. icon .. '  ' end end
            return sp_file .. ' '
        end,
        condition = condition.buffer_not_empty,
        highlight = {colors.magenta, colors.bg, 'bold'}
    }
}

gls.left[5] = {
    SeperatorLeft = {
        provider = function()
            return ' '
        end,
        highlight = {colors.blue, colors.bg}
    }
}

gls.left[6] = {DiffAdd = {provider = 'DiffAdd', condition = condition.hide_in_width, icon = '  ', highlight = {colors.green, colors.bg}}}
gls.left[7] = {DiffModified = {provider = 'DiffModified', condition = condition.hide_in_width, icon = ' 柳', highlight = {colors.orange, colors.bg}}}
gls.left[8] = {DiffRemove = {provider = 'DiffRemove', condition = condition.hide_in_width, icon = '  ', highlight = {colors.red, colors.bg}}}

gls.left[9] = {
    GitIcon = {
        provider = function()
            return '  '
        end,
        condition = condition.check_git_workspace,
        separator_highlight = {'NONE', colors.bg},
        highlight = {colors.violet, colors.bg, 'bold'}
    }
}
gls.left[10] = {GitBranch = {provider = 'GitBranch', condition = condition.check_git_workspace, highlight = {colors.violet, colors.bg}}}


gls.left[11] = {
    SeperatorLeft = {
        provider = function()
            return ' '
        end,
        highlight = {colors.blue, colors.bg}
    }
}

gls.left[12] = {DiagnosticError = {provider = 'DiagnosticError', icon = '  ', highlight = {colors.red, colors.bg}}}
gls.left[13] = {DiagnosticWarn = {provider = 'DiagnosticWarn', icon = '  ', highlight = {colors.yellow, colors.bg}}}

gls.left[14] = {DiagnosticHint = {provider = 'DiagnosticHint', icon = '  ', highlight = {colors.cyan, colors.bg}}}

gls.left[15] = {DiagnosticInfo = {provider = 'DiagnosticInfo', icon = '  ', highlight = {colors.blue, colors.bg}}}

gls.left[16] = {
    ShowLspClient = {
        provider = function()
            local msg = "No Active Lsp"
            local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
            local clients = vim.lsp.get_active_clients()
            if next(clients) == nil then return msg end
            for _, client in ipairs(clients) do
                if not string.find(client.name, "efm") then
                    local filetypes = client.config.filetypes
                    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then return client.name end
                end
            end
            return msg
        end,
        condition = function()
            local tbl = {['dashboard'] = true, [''] = true}
            if tbl[vim.bo.filetype] then return false end
            return true
        end,
        icon = '  LSP : ',
        highlight = {colors.fg, colors.bg, 'bold'}
    }
}

gls.left[17] = {
    MetalsStatus = {
        provider = function()
            return "  " .. (vim.g["metals_status"] or "")
        end,
        highlight = {colors.fg, colors.bg}
    }
}

gls.right[1] = {
    SpotifyStatusSymbol = {
        provider = function()
            return "  " .. string.sub(spotify_status.listen(), 1, 4)
        end,
        highlight = {colors.red, colors.bg}
    }
}

gls.right[2] = {
    SpotifyStatusText = {
        provider = function()
            return " " .. string.sub(spotify_status.listen(), 4) .. " "
        end,
        highlight = {colors.fg, colors.bg, 'bold'}
    }
}

gls.right[3] = {
    SeperatorRight = {
        provider = function()
            return ' '
        end,
        highlight = {colors.blue, colors.bg}
    }
}

gls.right[4] = {LineInfo = {provider = 'LineColumn', separator_highlight = {'NONE', colors.bg}, highlight = {colors.fg, colors.bg}}}

gls.right[5] = {PerCent = {provider = 'LinePercent', separator_highlight = {'NONE', colors.bg}, highlight = {colors.fg, colors.bg, 'bold'}}}

gls.right[6] = {
    FileEncode = {
        provider = function()
            local encode = vim.bo.fenc ~= '' and vim.bo.fenc or vim.o.enc
            return encode
        end,
        condition = condition.hide_in_width,
        separator = ' ',
        separator_highlight = {'NONE', colors.bg},
        highlight = {colors.green, colors.bg}
    }
}

gls.right[7] = {
    FileFormat = {
        provider = function()
            return vim.bo.fileformat
        end,
        condition = condition.hide_in_width,
        separator = ' ',
        separator_highlight = {'NONE', colors.bg},
        highlight = {colors.green, colors.bg}
    }
}

gls.right[13] = {
    RainbowBlue = {
        provider = function()
            return ' '
        end
    }
}

gls.short_line_left[1] = {
    BufferType = {provider = 'FileTypeName', separator = ' ', separator_highlight = {'NONE', colors.bg}, highlight = {colors.blue, colors.bg, 'bold'}}
}

gls.short_line_left[2] = {SFileName = {provider = 'SFileName', condition = condition.buffer_not_empty, highlight = {colors.fg, colors.bg, 'bold'}}}

gls.short_line_right[1] = {BufferIcon = {provider = 'BufferIcon', highlight = {colors.fg, colors.bg}}}
