lua << EOF

local cfg = require('lsp-signature-config').cfg
require'lspconfig'.tsserver.setup{
    on_attach = function(client)
        require'lsp_signature'.on_attach(cfg)
        client.resolved_capabilities.document_formatting = false
    end
}
EOF
