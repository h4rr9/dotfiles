lua << EOF
vim.lsp.handlers["textDocument/formatting"] = function(err, _, result, _, bufnr)
    if err ~= nil or result == nil then
        return
    end
    if not vim.api.nvim_buf_get_option(bufnr, "modified") then
        local view = vim.fn.winsaveview()
        vim.lsp.util.apply_text_edits(result, bufnr)
        vim.fn.winrestview(view)
        if bufnr == vim.api.nvim_get_current_buf() then
            vim.api.nvim_command("noautocmd :update")
        end
    end
end

local on_attach = function(client)
    if client.resolved_capabilities.document_formatting then
        vim.api.nvim_command [[augroup Format]]
        vim.api.nvim_command [[autocmd! * <buffer>]]
        vim.api.nvim_command [[autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting_sync()]]
        vim.api.nvim_command [[augroup END]]
    end
end

require "lspconfig".efm.setup {
    init_options = {documentFormatting = true},
    root_dir = function()
        return vim.loop.cwd()
    end,
    filetypes = {"c", "cpp", "lua", "python", "rust", "javascript", "typescript", "go"},
    settings = {
        languages = {
            python = {{formatCommand = "black --quiet --line-length 79 -", formatStdin = true}},
            rust = {{formatCommand = "rustfmt", formatStdin = true}},
            cpp = {{formatCommand = "clang-format -style='{BasedOnStyle: LLVM, IndentWidth: 4}'", formatStdin = true}},
            c = {{formatCommand = "clang-format -style='{BasedOnStyle: LLVM, IndentWidth: 4}'", formatStdin = true}},
            lua = {
                {
                    formatCommand = "lua-format -i --no-keep-simple-function-one-line --no-break-after-operator --column-limit=150 --break-after-table-lb --double-quote-to-single-quote",
                    formatStdin = true
                }
            },
            javascript = {
                {
                    formatCommand = "prettier --config ~/.config/nvim/.prettierrc ${INPUT}",
                    formatStdin = true
                },
                {
                    lintCommand = "eslint -f unix --stdin --stdin-filename ${INPUT}",
                    lintIgnoreExitCode = true,
                    lintStdin = true,
                    lintFormats = {"%f:%l:%c: %m"}
                }
            },
            typescript = {
                {
                    formatCommand = "prettier --config ~/.config/nvim/.prettierrc ${INPUT}",
                    formatStdin = true
                },
                {
                    lintCommand = "eslint -f unix --stdin --stdin-filename ${INPUT}",
                    lintIgnoreExitCode = true,
                    lintStdin = true,
                    lintFormats = {"%f:%l:%c: %m"}
                }
            },
            go = {{formatCommand = "gofmt", formatStdin = true}}
        }
    },
    on_attach = on_attach
}
EOF
