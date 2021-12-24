lua << EOF
local cfg = require("lsp-signature-config").cfg
local util = require('lspconfig').util
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

require 'lspconfig'.pylsp.setup {
    cmd = {"pylsp"},
    filetypes = {"python"},
    root_dir = function(fname)
          local root_files = {
            'pyproject.toml',
            'setup.py',
            'setup.cfg',
            'requirements.txt',
            'Pipfile',
          }
          return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
        end,
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        require 'lsp_signature'.on_attach(cfg)
    end,
    capabilities=capabilities
}
EOF


