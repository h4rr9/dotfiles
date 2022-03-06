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

            vim.api.nvim_set_keymap('n', '<leader>Gh', '<cmd>ClangdSwitchSourceHeader<CR>', {noremap = true, silent = true})
            vim.api.nvim_set_keymap('n', '<leader>Gvh', '<cmd>ClangdSwitchSourceHeaderVSplit<CR>', {noremap = true, silent = true})

        end
    },
    extensions = {inlay_hints = {parameter_hints_prefix = ' ⇚ ', other_hints_prefix = ' » ', max_len_align_padding = 20}}
}

-- sumneko lua

USER = vim.fn.expand('$USER')

local sumneko_root_path = '/home/' .. USER .. '/.config/nvim/lua-language-server'
local sumneko_binary = '/home/' .. USER .. '/.config/nvim/lua-language-server/bin/Linux/lua-language-server'

require('lspconfig').sumneko_lua.setup {
    cmd = {sumneko_binary, '-E', sumneko_root_path .. '/main.lua'},
    settings = {
        Lua = {
            runtime = {version = 'LuaJIT', path = vim.split(package.path, ';')},
            diagnostics = {enable = true, globals = {'vim'}},
            workspace = {library = {[vim.fn.expand('$VIMRUNTIME/lua')] = true, [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true}}
        }
    },
    on_attach = function(client)
        require'lsp_signature'.on_attach(cfg)
        client.resolved_capabilities.document_formatting = false
    end,
    capabilities = capabilities
}

-- rust

require('rust-tools').setup({
    tools = {
        runnables = {use_telescope = true},
        inlay_hints = {
            show_parameter_hints = true,
            parameter_hints_prefix = ' ⇚ ',
            other_hints_prefix = ' » ',
            max_len_align = true,
            max_len_align_padding = 20
        }
    },
    server = {
        settings = {
            ['rust-analyzer'] = {
                assist = {importGranularity = 'module', importPrefix = 'by_crate'},
                cargo = {loadOutDirsFromCheck = true},
                procMacro = {enable = true},
                checkOnSave = {
                    allFeatures = true,
                    overrideCommand = {'cargo', 'clippy', '--workspace', '--message-format=json', '--all-targets', '--all-features'}
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
    capabilities = capabilities,
    on_attach = function(client)
        require'lsp_signature'.on_attach(cfg)
        client.resolved_capabilities.document_formatting = false
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
    on_attach = function()
        require'lsp_signature'.on_attach(cfg)
    end,
    capabilities = capabilities,
    single_file_support = true
}

-- efm

require'lspconfig'.efm.setup {
    init_options = {documentFormatting = true},
    root_dir = function()
        return vim.loop.cwd()
    end,
    filetypes = {'c', 'cpp', 'lua', 'python', 'rust', 'javascript', 'typescript', 'go'},
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
            go = {{formatCommand = 'gofmt', formatStdin = true}}
        }
    },
    on_attach = require'lsp-format'.on_attach
}
