lua << EOF
require "lspconfig".efm.setup {
    init_options = {documentFormatting = true},
    root_dir = vim.loop.cwd,
    settings = {
        languages = {
            python = {{formatCommand = "yapf --style=google", formatStdin=true}},
        }
    }
}
EOF
