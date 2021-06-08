lua << EOF
-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir
local lualine = require("lualine")
local get_mode = require("lualine.utils.mode").get_mode

-- Color table for highlights
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

local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
    end,
    hide_in_width = function()
        return vim.fn.winwidth(0) > 80
    end,
    check_git_workspace = function()
        local filepath = vim.fn.expand("%:p:h")
        local gitdir = vim.fn.finddir(".git", filepath .. ";")
        return gitdir and #gitdir > 0 and #gitdir < #filepath
    end
}

-- Config
local config = {
    options = {
        -- Disable sections and component separators
        component_separators = "",
        section_separators = "",
        theme = {
            -- We are going to use lualine_c an lualine_x as left and
            -- right section. Both are highlighted by c theme .  So we
            -- are just setting default looks o statusline
            normal = {c = {fg = colors.fg, bg = colors.bg}},
            inactive = {c = {fg = colors.fg, bg = colors.bg}}
        }
    },
    sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        -- These will be filled later
        lualine_c = {},
        lualine_x = {}
    },
    inactive_sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_v = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {}
    },
    extensions = {"quickfix", "nvim-tree"}
}

-- Inserts a component in lualine_c at left section
local function ins_left_active(component)
    table.insert(config.sections.lualine_c, component)
end

local function ins_left_inactive(component)
    table.insert(config.inactive_sections.lualine_c, component)
end
-- Inserts a component in lualine_x ot right section
local function ins_right_active(component)
    table.insert(config.sections.lualine_x, component)
end

local function ins_right_inactive(component)
    table.insert(config.inactive_sections.lualine_x, component)
end

local padding_left= {
    function()
        return " "
    end,
    color = {fg = colors.blue}, -- Sets highlighting of component
    left_padding = 0 -- We don't need space before this
}

ins_left_active(padding_left)
ins_left_inactive(padding_left)

local mode = {
    -- mode component
    function()
        -- auto change color according to neovims mode
        local mode_color = {
            n = colors.red,
            i = colors.green,
            v = colors.blue,
            [""] = colors.blue,
            V = colors.blue,
            c = colors.magenta,
            no = colors.red,
            s = colors.orange,
            S = colors.orange,
            [""] = colors.orange,
            ic = colors.yellow,
            R = colors.violet,
            Rv = colors.violet,
            cv = colors.red,
            ce = colors.red,
            r = colors.cyan,
            rm = colors.cyan,
            ["r?"] = colors.cyan,
            ["!"] = colors.red,
            t = colors.red
        }
        vim.api.nvim_command("hi! LualineMode guifg=" .. mode_color[vim.fn.mode()] .. " guibg=" .. colors.bg)
        return " " .. get_mode()
    end,
    color = "LualineMode",
    left_padding = 0
}

ins_left_active(mode)
ins_left_inactive(mode)

local file_size = {
    -- filesize component
    function()
        local function format_file_size(file)
            local size = vim.fn.getfsize(file)
            if size <= 0 then
                return ""
            end
            local sufixes = {"b", "k", "m", "g"}
            local i = 1
            while size > 1024 do
                size = size / 1024
                i = i + 1
            end
            return string.format("%.1f%s", size, sufixes[i])
        end
        local file = vim.fn.expand("%:p")
        if string.len(file) == 0 then
            return ""
        end
        return format_file_size(file)
    end,
    condition = conditions.buffer_not_empty
}

ins_left_active(file_size)
ins_left_inactive(file_size)

local file_name= {
    "filename",
    condition = conditions.buffer_not_empty,
    color = {fg = colors.magenta, gui = "bold"}
}

ins_left_active(file_name)
ins_left_inactive(file_name)

local diagnostics ={
    "diagnostics",
    sources = {"nvim_lsp"},
    symbols = {error = " ", warn = " ", info = " "},
    color_error = colors.red,
    color_warn = colors.yellow,
    color_info = colors.cyan
}

ins_left_active(diagnostics)

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it's any number greater then 2
local middle = {
    function()
        return "%="
    end
}

ins_left_active(middle)
ins_left_inactive(middle)

local lsp = {
    -- Lsp server name .
    function()
        local msg = "No Active Lsp"
        local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
        local clients = vim.lsp.get_active_clients()
        if next(clients) == nil then
            return msg
        end
        for _, client in ipairs(clients) do
            if not string.find(client.name, "efm") then
                local filetypes = client.config.filetypes
                if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                    return client.name
                end
            end
        end
        return msg
    end,
    icon = " LSP:",
    color = {fg = colors.fg, gui = "bold"}
}

ins_left_active(lsp)

-- filetype icon
local file_type = {
    "filetype",
    colored = true
}

ins_right_active(file_type)
ins_right_inactive(file_type)

-- Add components to right sections
local location =  {"location", color = {gui = "bold"}}
ins_right_active(location)
ins_right_inactive(location)

local progress =  {"progress", color = {fg = colors.fg, gui = "bold"}}
ins_right_active(progress)
ins_right_inactive(progress)


local encoding = {
    "o:encoding", -- option component same as &encoding in viml
    condition = conditions.hide_in_width,
    color = {fg = colors.green}
}

ins_right_active(encoding)
ins_right_inactive(encoding)

local file_format =  {
    "fileformat",
    upper = true,
    icons_enabled = true, -- I think icons are cool but Eviline doesn't have them. sigh
    color = {fg = colors.green}
}

ins_right_active(file_format)
ins_right_inactive(file_format)

local branch =  {
    "branch",
    icon = "",
    condition = conditions.check_git_workspace,
    color = {fg = colors.violet, gui = "bold"}
}
ins_right_active(branch)

local diff = {
    "diff",
    -- Is it me or the symbol for modified us really weird
    symbols = {added = " ", modified = "柳 ", removed = " "},
    color_added = colors.green,
    color_modified = colors.orange,
    color_removed = colors.red,
    condition = conditions.hide_in_width
}
ins_right_active(diff)

local padding_right=  {
    function()
        return " "
    end,
    color = {fg = colors.blue},
    right_padding = 0
}
ins_right_active(padding_right)
ins_right_inactive(padding_right)

-- Now don't forget to initialize lualine
lualine.setup(config)
EOF
