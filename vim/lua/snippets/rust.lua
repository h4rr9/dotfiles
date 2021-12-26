local ls = require "luasnip"


local i = ls.insert_node
local f = ls.function_node
local t = ls.text_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

local same = function(index)
    return f(function(args)
        return args[1]
    end, {index})
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

    test = fmt([[
      #[test]
      fn {}(){}{{
          {}
      }}
    ]], {
        i(1, "testname"), c(2, {
            t "", t " -> Result<()> "
            -- fmt(" -> {}<()> ", { i(nil, "Result") }),
        }), i(0)
    }),

    eq = fmt("assert_eq!({}, {});{}", {i(1), i(2), i(0)}),

    enum = {t {"#[derive(Debug, PartialEq)]", "enum "}, i(1, "Name"), t {" {", "  "}, i(0), t {"", "}"}},

    struct = {t {"#[derive(Debug, PartialEq)]", "struct "}, i(1, "Name"), t {" {", "    "}, i(0), t {"", "}"}},

    pd = fmt([[println!("{}: {{:?}}", {});]], {same(1), i(1)})
    -- _pd = {
    --   t [[println!("{:?}", ]],
    --   i(1),
    --   t [[);]],
    -- },
}
return snippets

