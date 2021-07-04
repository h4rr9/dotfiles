lua << EOF
local cfg = require('lsp-signature-config').cfg

require'lspconfig'.metals.setup{
    on_attach = function(client)
        if client.resolved_capabilities.document_formatting then
            vim.api.nvim_command [[augroup Format]]
            vim.api.nvim_command [[autocmd! * <buffer>]]
            vim.api.nvim_command [[autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()]]
            vim.api.nvim_command [[augroup END]]
        end
        require'lsp_signature'.on_attach(cfg)
    end
}
EOF



"local cmd = vim.cmd
"local capabilities = vim.lsp.protocol.make_client_capabilities()
"capabilities.textDocument.completion.completionItem.snippetSupport = true
"capabilities.textDocument.codeLens =  {
  "dynamicRegistration = false,
"}

"vim.opt_global.shortmess:remove("F"):append("c")

"metals_config = require'metals'.bare_config
"metals_config.init_options.statusBarProvider = 'on'
"metals_config.settings = {
    "showImplicitArguments = true,
    "showInferredType = true,
    "excludedPackages = {
      ""akka.actor.typed.javadsl",
      ""com.github.swagger.akka.javadsl",
      ""akka.stream.javadsl",
    "},
"}
"metals_config.capabilities = capabilities

"cmd([[augroup lsp]])
"cmd([[autocmd!]])
"cmd([[autocmd FileType scala,sbt lua require("metals").initialize_or_attach(metals_config)]])
"cmd([[augroup end]])

"vim.cmd([[hi! link LspReferenceText CursorColumn]])
"vim.cmd([[hi! link LspReferenceRead CursorColumn]])
"vim.cmd([[hi! link LspReferenceWrite CursorColumn]])
