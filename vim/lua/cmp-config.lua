-- Setup nvim-cmp.
vim.cmd [[set completeopt=menu,menuone,noselect]]
vim.cmd [[let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy'] ]]





local cmp = require 'cmp'
local lspkind = require('lspkind')

local luasnip = require("luasnip")

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end
    },
    mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, {"i", "s"}),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, {"i", "s"}),
        ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
        ['<C-e>'] = cmp.mapping({i = cmp.mapping.close(), c = cmp.mapping.close()}),
        ['<CR>'] = cmp.mapping({
            i = cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Replace, select = false}),
            c = function(fallback)
                if cmp.visible() then
                    cmp.confirm({behavior = cmp.ConfirmBehavior.Replace, select = false})
                else
                    fallback()
                end
            end
        })
    },

    sources = {{name = 'nvim_lsp'}, {name = 'nvim_lua'}, {name = 'luasnip'}, {name = 'buffer'}, {name = 'path'}, {name = 'calc'}},
    sorting = {
        comparators = {
            cmp.config.compare.offset, cmp.config.compare.exact, cmp.config.compare.score, require"cmp-under-comparator".under,
            cmp.config.compare.kind, cmp.config.compare.sort_text, cmp.config.compare.length, cmp.config.compare.order
        }
    },

    formatting = {
        format = lspkind.cmp_format({
            with_text = true, -- do not show text alongside icons
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            menu = {buffer = "[buf]", calc = "[calc]", nvim_lsp = "[lsp]", nvim_lua = "[api]", path = "[path]", luasnip = "[snips]"}
        })

    },
    experimental = {native_menu = false, ghost_text = true}
})

-- Use buffer source for `/`.
cmp.setup.cmdline('/', {completion = {autocomplete = true}, sources = {{name = 'buffer'}}})

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(':', {completion = {autocomplete = true}, sources = {{name = 'path'}, {name = 'cmdline'}}})

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

_G.tab_complete = function()
    if cmp and cmp.visible() then
        cmp.select_next_item()
    elseif luasnip and luasnip.expand_or_jumpable() then
        return t("<Plug>luasnip-expand-or-jump")
    elseif check_back_space() then
        return t "<Tab>"
    else
        cmp.complete()
    end
    return ""
end
_G.s_tab_complete = function()
    if cmp and cmp.visible() then
        cmp.select_prev_item()
    elseif luasnip and luasnip.jumpable(-1) then
        return t("<Plug>luasnip-jump-prev")
    else
        return t "<S-Tab>"
    end
    return ""
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<C-E>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("s", "<C-E>", "<Plug>luasnip-next-choice", {})

-- gray
vim.cmd [[highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#928374]]
-- blue
vim.cmd [[highlight! CmpItemAbbrMatch guibg=NONE guifg=#458588]]
vim.cmd [[highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#458588]]
-- light blue
vim.cmd [[highlight! CmpItemKindVariable guibg=NONE guifg=#83A598]]
vim.cmd [[highlight! CmpItemKindInterface guibg=NONE guifg=#83A598]]
vim.cmd [[highlight! CmpItemKindText guibg=NONE guifg=#83A598]]
-- pink
vim.cmd [[highlight! CmpItemKindFunction guibg=NONE guifg=#B16286]]
vim.cmd [[highlight! CmpItemKindMethod guibg=NONE guifg=#B16286]]
-- front
vim.cmd [[highlight! CmpItemKindKeyword guibg=NONE guifg=#EBDBB2]]
vim.cmd [[highlight! CmpItemKindProperty guibg=NONE guifg=#EBDBB2]]
vim.cmd [[highlight! CmpItemKindUnit guibg=NONE guifg=#EBDBB2]]

