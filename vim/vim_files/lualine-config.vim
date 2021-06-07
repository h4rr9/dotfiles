lua << EOF
require("lualine").setup {
    options = {
        theme = 'gruvbox'
    },
    extensions = {"quickfix", "nvim-tree"}
}
EOF
