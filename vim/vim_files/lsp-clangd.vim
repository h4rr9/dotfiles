lua << EOF
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cfg = require('lsp-signature-config').cfg

capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        "documentation",
        "detail",
        "additionalTextEdits"
    }
}
local function switch_source_header_splitcmd(bufnr, splitcmd)
    bufnr = require "lspconfig".util.validate_bufnr(bufnr)
    local params = {uri = vim.uri_from_bufnr(bufnr)}
    vim.lsp.buf_request(
        bufnr,
        "textDocument/switchSourceHeader",
        params,
        function(err, _, result)
            if err then
                error(tostring(err))
            end
            if not result then
                print("Corresponding file can’t be determined")
                return
            end
            vim.api.nvim_command(splitcmd .. " " .. vim.uri_to_fname(result))
        end
    )
end

require "lspconfig".clangd.setup {
    cmd = {
        "clangd",
        "--background-index",
        "--pch-storage=memory",
        "--clang-tidy",
        "--suggest-missing-includes"
    },
    capabilities = capabilities,
    commands = {
        ClangdSwitchSourceHeader = {
            function()
                switch_source_header_splitcmd(0, "edit")
            end,
            description = "Open source/header in current buffer"
        },
        ClangdSwitchSourceHeaderVSplit = {
            function()
                switch_source_header_splitcmd(0, "vsplit")
            end,
            description = "Open source/header in a new vsplit"
        },
        ClangdSwitchSourceHeaderSplit = {
            function()
                switch_source_header_splitcmd(0, "split")
            end,
            description = "Open source/header in a new split"
        }
    },
    root_dir = function()
        return vim.loop.cwd()
    end,
    on_attach = function(client)
        require'lsp_signature'.on_attach(cfg)
        client.resolved_capabilities.document_formatting = false
    end
}
EOF

autocmd BufWritePre *.cpp lua vim.lsp.buf.formatting_sync(nil, 100)
autocmd BufWritePre *.h lua vim.lsp.buf.formatting_sync(nil, 100)
