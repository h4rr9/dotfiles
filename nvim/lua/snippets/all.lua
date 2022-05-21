local ls = require 'luasnip'

local sn = ls.snippet_node
local i = ls.insert_node
local f = ls.function_node
local t = ls.text_node
local c = ls.choice_node
local d = ls.dynamic_node
local fmt = require('luasnip.extras.fmt').fmt
local partial = require('luasnip.extras').partial

local snippets = {
    time = partial(vim.fn.strftime, '%H:%M:%S'),
    date = partial(vim.fn.strftime, '%Y-%m-%d'),
    shrug = t('¯\\_(ツ)_/¯'),
    angry = t('(╯°□°）╯︵ ┻━┻'),
    happy = t('ヽ(´▽`)/'),
    sad = t('(－‸ლ)'),
    confused = t('(｡･ω･｡)')
}

return snippets

