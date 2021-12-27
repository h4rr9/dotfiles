local ls = require("luasnip")
-- some shorthands...
local s = ls.s
local t = ls.text_node
local i = ls.insert_node
local types = require("luasnip.util.types")

local shortcut = function(val)
    if type(val) == "string" then return {t {val}, i(0)} end

    if type(val) == "table" then for k, v in ipairs(val) do if type(v) == "string" then val[k] = t {v} end end end

    return val
end

local make = function(tbl)
    local result = {}
    for k, v in pairs(tbl) do table.insert(result, (s({trig = k, desc = v.desc}, shortcut(v)))) end

    return result
end

ls.config.set_config({
    history = true,
    -- Update more often, :h events for more info.
    updateevents = "TextChanged,TextChangedI",
    ext_opts = {[types.choiceNode] = {active = {virt_text = {{"choiceNode", "Comment"}}}}},
    -- treesitter-hl has 100, use something higher (default is 200).
    ext_base_prio = 300,
    -- minimal increase in priority.
    ext_prio_increase = 1,
    enable_autosnippets = true
})

local snippets = {}

snippets.cpp = make(require("snippets.cpp"))
snippets.lua = make(require("snippets.lua"))
snippets.rust = make(require("snippets.rust"))

require("luasnip/loaders/from_vscode").lazy_load()

ls.snippets = snippets

