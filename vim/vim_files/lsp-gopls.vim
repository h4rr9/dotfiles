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

capabilities.textDocument.completion.editsNearCursor = true
capabilities.offsetEncoding = {"utf-8"}


local capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

require'lspconfig'.gopls.setup {
    cmd = {"gopls", "serve"},
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    },
    capabilities = capabilities,
    on_attach = function(client)
        require'lsp_signature'.on_attach(cfg)
        client.resolved_capabilities.document_formatting = false
    end
  }


EOF
