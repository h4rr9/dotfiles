local ls = require 'luasnip'

local snippet_from_nodes = ls.sn

local i = ls.insert_node
local t = ls.text_node
local d = ls.dynamic_node
local c = ls.choice_node
local fmt = require('luasnip.extras.fmt').fmt

local newline = function(text)
    return t {'', text}
end

local require_var = function(args, _)
    local text = args[1][1] or ''
    local split = vim.split(text, '.', {plain = true})

    local options = {}
    for len = 0, #split - 1 do table.insert(options, t(table.concat(vim.list_slice(split, #split - len, #split), '_'))) end

    return snippet_from_nodes(nil, {c(1, options)})
end

local snippets = {
    ignore = '--stylua: ignore',

    lf = {desc = 'table function', 'local ', i(1), ' = function(', i(2), ')', newline '  ', i(0), newline 'end'},

    fn = {'function(', i(1), ')', i(0), newline 'end'},

    req = fmt([[local {} = require("{}")]], {d(2, require_var, {1}), i(1)})

}

return snippets

