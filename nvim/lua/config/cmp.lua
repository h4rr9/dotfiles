-- Setup nvim-cmp.
local cmp = require 'cmp'
local lspkind = require('lspkind')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end
    },
    window = {completion = cmp.config.window.bordered(), documentation = cmp.config.window.bordered()},
    mapping = cmp.mapping.preset.insert({
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
    }),

    sources = cmp.config.sources({
        {name = 'orgmode'}, {name = 'nvim_lsp'}, {name = 'cmp_git'}, {name = 'nvim_lua'}, {name = 'luasnip'}, {name = 'buffer'}, {name = 'path'},
        {name = 'calc'}
    }),
    sorting = {
        comparators = {
            cmp.config.compare.offset, cmp.config.compare.exact, cmp.config.compare.score, require'cmp-under-comparator'.under,
            cmp.config.compare.kind, cmp.config.compare.sort_text, cmp.config.compare.length, cmp.config.compare.order
        }
    },

    formatting = {
        format = lspkind.cmp_format({
            with_text = true,
            maxwidth = 50,
            menu = {buffer = '[buf]', calc = '[calc]', nvim_lsp = '[lsp]', nvim_lua = '[api]', path = '[path]', luasnip = '[snips]'}
        })

    },
    experimental = {ghost_text = true}

})

cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({map_char = {tex = ''}}))

cmp.setup.cmdline('/', {completion = {autocomplete = true}, sources = {{name = 'buffer'}}, view = {entries = {name = 'wildmenu', separator = '|'}}})
cmp.setup.cmdline(':', {completion = {autocomplete = true}, sources = {{name = 'path'}, {name = 'cmdline'}}})
