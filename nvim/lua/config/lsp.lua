local util = require('lspconfig').util

-- clangd

local capabilities = vim.lsp.protocol.make_client_capabilities()

local cfg = {
    doc_lines = 2,
    floating_window = true,
    hint_enable = true,
    hint_prefix = '↗️ ',
    hint_scheme = 'String',
    max_width = 120,
    handler_opts = {border = 'single'}
}

capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {properties = {'documentation', 'detail', 'additionalTextEdits'}}
capabilities.textDocument.completion.editsNearCursor = true
capabilities.offsetEncoding = {'utf-16'}

local function switch_source_header_splitcmd(bufnr, splitcmd)
    bufnr = require'lspconfig'.util.validate_bufnr(bufnr)
    local clangd_client = require'lspconfig'.util.get_active_client_by_name(bufnr, 'clangd')
    local params = {uri = vim.uri_from_bufnr(bufnr)}
    if clangd_client then
        clangd_client.request('textDocument/switchSourceHeader', params, function(err, result)
            if err then error(tostring(err)) end
            if not result then
                print('Corresponding file can’t be determined')
                return
            end
            vim.api.nvim_command(splitcmd .. ' ' .. vim.uri_to_fname(result))
        end, bufnr)
    else
        print 'textDocument/switchSourceHeader is not supported by the clangd server active on the current buffer'
    end
end

capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

require('clangd_extensions').setup {
    server = {
        cmd = {'clangd', '--background-index', '--pch-storage=memory', '--clang-tidy', '--suggest-missing-includes', '--header-insertion=iwyu'},
        capabilities = capabilities,
        commands = {
            ClangdSwitchSourceHeader = {
                function()
                    switch_source_header_splitcmd(0, 'edit')
                end,
                description = 'Open source/header in current buffer'
            },
            ClangdSwitchSourceHeaderVSplit = {
                function()
                    switch_source_header_splitcmd(0, 'vsplit')
                end,
                description = 'Open source/header in a new vsplit'
            },
            ClangdSwitchSourceHeaderSplit = {
                function()
                    switch_source_header_splitcmd(0, 'split')
                end,
                description = 'Open source/header in a new split'
            }
        },
        on_attach = function(client)
            require'lsp_signature'.on_attach(cfg)
            client.resolved_capabilities.document_formatting = false

            vim.keymap.set('n', '<leader>Gh', '<cmd>ClangdSwitchSourceHeader<cr>', {buffer = true})
            vim.keymap.set('n', '<leader>Gvh', '<cmd>ClangdSwitchSourceHeaderVSplit<cr>', {buffer = true})

        end
    },
    extensions = {inlay_hints = {parameter_hints_prefix = ' ⇚ ', other_hints_prefix = ' » ', max_len_align_padding = 20}}
}

-- sumneko lua

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

require'lspconfig'.sumneko_lua.setup {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = runtime_path
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'}
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file('', true)
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {enable = false},
            IntelliSense = {traceLocalSet = true, traceReturn = true, traceBeSetted = true, traceFieldInject = true},
            hint = {enable = true}
        },

        on_attach = function(client)
            require'lsp_signature'.on_attach(cfg)
            client.resolved_capabilities.document_formatting = false

        end,
        capabilities = capabilities
    }
}

-- rust

require('rust-tools').setup({
    tools = {
        runnables = {use_telescope = true},
        inlay_hints = {show_parameter_hints = true, parameter_hints_prefix = ' ⇚ ', other_hints_prefix = ' » ', max_len_align = false}
    },
    server = {
        settings = {
            assist = {allowMergingIntoGlobImports = false, importGranularity = 'module'},
            cargo = {allFeatures = true},
            checkOnSave = {
                command = 'clippy',
                extraArgs = {
                    '--workspace', '--all-targets', '--all-features', '--', '--warn', 'rust_2018_idioms', '--warn', 'clippy::pedantic', '--warn',
                    'clippy::pattern_type_mismatch', -- Too noisy because it warns the whole function.
                    '--allow', 'clippy::too_many_lines'
                }
            },
            diagnostics = {
                warningsAsHelp = {'clippy::pedantic', 'clippy::pattern_type_mismatch'},
                warningsAsInfo = {
                    -- I am not a big fan of this lint.
                    'clippy::type_complexity'
                }
            }
        },
        on_attach = function(client)
            require'lsp_signature'.on_attach(cfg)
            client.resolved_capabilities.document_formatting = false
        end,
        capabilities = capabilities
    }
})

-- python

require'lspconfig'.pylsp.setup {
    cmd = {'pylsp'},
    filetypes = {'python'},
    root_dir = function(fname)
        local root_files = {'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile'}
        return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
    end,
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        require'lsp_signature'.on_attach(cfg)
    end,
    capabilities = capabilities
}

-- golang

require'lspconfig'.gopls.setup {
    cmd = {'gopls', 'serve'},
    settings = {gopls = {analyses = {unusedparams = true}, staticcheck = true}},
    capabilities = capabilities,
    on_attach = function(client)
        require'lsp_signature'.on_attach(cfg)
        client.resolved_capabilities.document_formatting = false
    end
}

-- cmake

require'lspconfig'.cmake.setup {
    on_attach = function(client)
        if client.resolved_capabilities.document_formatting then
            vim.api.nvim_command [[augroup Format]]
            vim.api.nvim_command [[autocmd! * <buffer>]]
            vim.api.nvim_command [[autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()]]
            vim.api.nvim_command [[augroup END]]
        end
    end
}

-- tsserver

require'lspconfig'.tsserver.setup {
    init_options = require('nvim-lsp-ts-utils').init_options,

    capabilities = capabilities,
    on_attach = function(client)
        require'lsp_signature'.on_attach(cfg)
        client.resolved_capabilities.document_formatting = false

        local ts_utils = require('nvim-lsp-ts-utils')
        ts_utils.setup({})
        ts_utils.setup_client(client)

        vim.keymap.set('n', '<leader>GS', ':TSLspOrganize<CR>', {buffer = true})
        vim.keymap.set('n', '<leader>GR', ':TSLspRenameFile<CR>', {buffer = true})
        vim.keymap.set('n', '<leader>GI', ':TSLspImportAll<CR>', {buffer = true})
    end

}

-- latex

require'lspconfig'.texlab.setup {
    cmd = {'texlab'},
    filetypes = {'tex', 'bib'},
    root_dir = function(fname)
        return util.root_pattern '.latexmkrc'(fname) or util.find_git_ancestor(fname)
    end,
    settings = {
        texlab = {
            auxDirectory = '.',
            bibtexFormatter = 'texlab',
            build = {
                args = {'-pdf', '-interaction=nonstopmode', '-synctex=1', '%f'},
                executable = 'latexmk',
                forwardSearchAfter = false,
                onSave = false
            },
            chktex = {onEdit = false, onOpenAndSave = false},
            diagnosticsDelay = 300,
            formatterLineLength = 80,
            forwardSearch = {args = {}},
            latexFormatter = 'latexindent',
            latexindent = {modifyLineBreaks = false}
        }
    },
    on_attach = function(client)
        require'lsp-format'.on_attach(client)
        require'lsp_signature'.on_attach(cfg)
    end,
    capabilities = capabilities,
    single_file_support = true
}

-- html

require'lspconfig'.html.setup {capabilities = capabilities}

--[[ -- markdown
require'lspconfig'.zeta_note.setup {
    cmd = {'/home/h4rr9/.local/bin/zeta-note'},
    capabilities = capabilities,
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        require'lsp_signature'.on_attach(cfg)
    end
} ]]

-- haskell

require'lspconfig'.hls.setup {
    capabilities = capabilities,
    on_attach = function(client)
        require'lsp_signature'.on_attach(cfg)
        client.resolved_capabilities.document_formatting = false
    end
}

-- efm

require'lspconfig'.efm.setup {
    init_options = {documentFormatting = true},
    root_dir = function()
        return vim.loop.cwd()
    end,
    filetypes = {'c', 'cpp', 'lua', 'python', 'rust', 'javascript', 'typescript', 'go', 'haskell'},
    settings = {
        languages = {

            python = {{formatCommand = 'yapf --style=\'{column_limit: 79}\'', formatStdin = true}},
            rust = {{formatCommand = 'rustfmt', formatStdin = true}},
            cpp = {{formatCommand = 'clang-format -style=\'{BasedOnStyle: LLVM, IndentWidth: 4}\'', formatStdin = true}},
            c = {{formatCommand = 'clang-format -style=\'{BasedOnStyle: LLVM, IndentWidth: 4}\'', formatStdin = true}},
            lua = {
                {
                    formatCommand = 'lua-format -i --no-keep-simple-function-one-line --no-break-after-operator --column-limit=150 --break-after-table-lb --double-quote-to-single-quote',
                    formatStdin = true
                }
            },
            javascript = {
                {formatCommand = 'prettier --config ~/.config/nvim/.prettierrc ${INPUT}', formatStdin = true},
                {
                    lintCommand = 'eslint -f unix --stdin --stdin-filename ${INPUT}',
                    lintIgnoreExitCode = true,
                    lintStdin = true,
                    lintFormats = {'%f:%l:%c: %m'}
                }
            },
            typescript = {
                {formatCommand = 'prettier --config ~/.config/nvim/.prettierrc ${INPUT}', formatStdin = true},
                {
                    lintCommand = 'eslint -f unix --stdin --stdin-filename ${INPUT}',
                    lintIgnoreExitCode = true,
                    lintStdin = true,
                    lintFormats = {'%f:%l:%c: %m'}
                }
            },
            html = {
                {
                    formatCommand = 'prettier --config ~/.config/nvim/.prettierrc   ${--tab-width:tabWidth} ${--single-quote:singleQuote} --parser html  ${INPUT}',
                    formatStdin = true
                }
            },
            go = {{formatCommand = 'gofmt', formatStdin = true}},
            haskell = {{formatCommand = 'ormolu', formatStdin = true}}

        }
    },
    on_attach = require'lsp-format'.on_attach
}
