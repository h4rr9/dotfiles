lua << EOF


local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        "documentation",
        "detail",
        "additionalTextEdits"
    }
}
capabilities.textDocument.completion.editsNearCursor = true
capabilities.offsetEncoding = {"utf-8"}


capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local cfg = require('lsp-signature-config').cfg
require'lspconfig'.tsserver.setup{
    capabilities = capabilities,
    on_attach = function(client)
        require'lsp_signature'.on_attach(cfg)
        client.resolved_capabilities.document_formatting = false
    end
}
EOF
