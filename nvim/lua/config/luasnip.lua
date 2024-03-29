local ls = require('luasnip')
local s = ls.s
local t = ls.text_node
local i = ls.insert_node
local types = require('luasnip.util.types')

local shortcut = function(val)
    if type(val) == 'string' then return {t {val}, i(0)} end

    if type(val) == 'table' then for k, v in ipairs(val) do if type(v) == 'string' then val[k] = t {v} end end end

    return val
end

local make = function(tbl)
    local result = {}
    for k, v in pairs(tbl) do table.insert(result, (s({trig = k, desc = v.desc}, shortcut(v)))) end

    return result
end

ls.config.set_config({
    history = true,
    updateevents = 'TextChanged,TextChangedI',
    ext_opts = {[types.choiceNode] = {active = {virt_text = {{'<- Current Choice', 'SpecialComment'}}}}},
    ext_base_prio = 300,
    ext_prio_increase = 1,
    enable_autosnippets = true
})

ls.add_snippets('cpp', make(require('snippets.cpp')))
ls.add_snippets('lua', make(require('snippets.lua')))
ls.add_snippets('rust', make(require('snippets.rust')))
ls.add_snippets('all', make(require('snippets.all')))

require('luasnip/loaders/from_vscode').lazy_load()

require'luasnip'.filetype_extend('telekasten', {'markdown'})

