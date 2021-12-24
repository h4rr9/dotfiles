lua << EOF
USER = vim.fn.expand('$USER')

local sumneko_root_path = ""
local sumneko_binary = ""

local cfg = require('lsp-signature-config').cfg

sumneko_root_path = "/home/" .. USER .. "/.config/nvim/lua-language-server"
sumneko_binary = "/home/" .. USER .. "/.config/nvim/lua-language-server/bin/Linux/lua-language-server"

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

require'lspconfig'.sumneko_lua.setup {
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = vim.split(package.path, ';')
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                enable = true,
                globals = {'vim'}
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {[vim.fn.expand('$VIMRUNTIME/lua')] = true, [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true}
            }
        }
    },
    on_attach = function(client)
        require'lsp_signature'.on_attach(cfg)
        client.resolved_capabilities.document_formatting = false
    end,
    capabilities=capabilities
}
EOF
