lua << EOF
require'lspconfig'.pyright.setup{}
EOF

autocmd BufWritePre *.py lua vim.lsp.buf.formatting_sync(nil, 100)
