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
capabilities.offsetEncoding = {"utf-8", "utf-16"}


local function switch_source_header_splitcmd(bufnr, splitcmd)
  bufnr = require'lspconfig'.util.validate_bufnr(bufnr)
  local clangd_client = require'lspconfig'.util.get_active_client_by_name(bufnr, 'clangd')
  local params = {uri = vim.uri_from_bufnr(bufnr)}
  if clangd_client then
    clangd_client.request("textDocument/switchSourceHeader", params, function(err, result)
      if err then
        error(tostring(err))
      end
      if not result then
        print("Corresponding file can’t be determined")
        return
      end
      vim.api.nvim_command(splitcmd .. " " .. vim.uri_to_fname(result))
    end, bufnr)
  else
    print 'textDocument/switchSourceHeader is not supported by the clangd server active on the current buffer'
  end
end

capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

require "lspconfig".clangd.setup {
    cmd = {
        "clangd",
        "--background-index",
        "--pch-storage=memory",
        "--clang-tidy",
        "--suggest-missing-includes",
        "--header-insertion=iwyu",
    },
    capabilities = capabilities,
    commands = {
    	ClangdSwitchSourceHeader = {
    		function() switch_source_header_splitcmd(0, "edit") end;
    		description = "Open source/header in current buffer";
    	},
    	ClangdSwitchSourceHeaderVSplit = {
    		function() switch_source_header_splitcmd(0, "vsplit") end;
    		description = "Open source/header in a new vsplit";
    	},
    	ClangdSwitchSourceHeaderSplit = {
    		function() switch_source_header_splitcmd(0, "split") end;
    		description = "Open source/header in a new split";
    	}
    },
--    root_dir = function()
 --       return vim.loop.cwd()
  --  end,
    on_attach = function(client)
        require'lsp_signature'.on_attach(cfg)
        client.resolved_capabilities.document_formatting = false

        vim.api.nvim_set_keymap("n", "<leader>Gh", "<cmd>ClangdSwitchSourceHeader<CR>",{noremap=true, silent=true})
        vim.api.nvim_set_keymap("n", "<leader>Gvh", "<cmd>ClangdSwitchSourceHeaderVSplit<CR>",{noremap=true, silent=true})

    end
}
EOF

