local ls = require 'luasnip'

local sn = ls.snippet_node
local i = ls.insert_node
local f = ls.function_node
local t = ls.text_node
local c = ls.choice_node
local d = ls.dynamic_node
local fmt = require('luasnip.extras.fmt').fmt

local same = function(index)
    return f(function(args)
        return args[1]
    end, {index})
end

local arg_node = function(index)
    return c(index, {sn(nil, {i(1, 'arg'), t ' : ', i(2, 'Type')}), i(nil, 'arg')})
end

local arg_list
arg_list = function()
    return sn(nil, {c(1, {t(''), sn(nil, {t(', '), arg_node(1), d(2, arg_list)})})});
end

local snippets = {
    main = fmt([[
    fn main() {{
    }}
    ]], {}),

    modtest = fmt([[
      #[cfg(test)]
      mod test {{
          use super::*;
          {}
      }}
    ]], i(0)),

    fn = fmt([[
    fn {}({}{}) {} {{
        {}
    }}
    ]], {i(1, 'fn_name'), arg_node(2), d(3, arg_list), c(4, {sn(nil, {t '-> ', i(1, 'RetType')}), t ''}), i(0, 'unimplemented!()')}),

    test = fmt([[
      #[test]
      fn {}(){}{{
          {}
      }}
    ]], {
        i(1, 'testname'), c(2, {
            t '', t ' -> Result<()> '
            -- fmt(" -> {}<()> ", { i(nil, "Result") }),
        }), i(0)
    }),

    eq = fmt('assert_eq!({}, {});{}', {i(1), i(2), i(0)}),

    enum = {t {'#[derive(Debug, PartialEq)]', 'enum '}, i(1, 'Name'), t {' {', '  '}, i(0), t {'', '}'}},

    struct = {t {'#[derive(Debug, PartialEq)]', 'struct '}, i(1, 'Name'), t {' {', '    '}, i(0), t {'', '}'}},

    pd = fmt([[println!("{}: {{:?}}", {});]], {same(1), i(1)})
    -- _pd = {
    --   t [[println!("{:?}", ]],
    --   i(1),
    --   t [[);]],
    -- },
}
return snippets

