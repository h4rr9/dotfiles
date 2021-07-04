lua << EOF
local cfg = require("lsp-signature-config").cfg

require "lspconfig".pylsp.setup {
    cmd = {"pylsp"},
    filetypes = {"python"},
    --root_dir = function()
     --   return vim.loop.cwd()
    --end,
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        require "lsp_signature".on_attach(cfg)
    end
}
EOF
