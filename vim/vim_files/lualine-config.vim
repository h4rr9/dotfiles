lua << EOF
require("lualine").setup {
    options = {
        theme = "gruvbox-flat"
    },
    extensions = {"quickfix", "nvim-tree"}
}
EOF
