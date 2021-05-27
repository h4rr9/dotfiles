lua << EOF
require'lspconfig'.rust_analyzer.setup({
    settings = {
        ["rust-analyzer"] = {
            assist = {
                importGranularity = "module",
                importPrefix = "by_self",
            },
            cargo = {
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            },
        }
    },
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
    end
})
EOF


autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 100)
