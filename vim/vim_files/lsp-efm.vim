lua << EOF
require "lspconfig".efm.setup {
    init_options = {documentFormatting = true},
    root_dir = vim.loop.cwd,
    settings = {
        languages = {
            python = {{formatCommand = "yapf --style=google", formatStdin = true}},
            rust = {{formatCommand = "rustfmt", formatStdin = true}},
            cpp = {{formatCommand = "clang-format -style='{BasedOnStyle: LLVM, IndentWidth: 4}'", formatStdin = true}}
        }
    }
}
EOF
