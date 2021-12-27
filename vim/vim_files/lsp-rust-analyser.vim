lua << EOF
local cfg = require("lsp-signature-config").cfg

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

local opts = {
    tools = {
        autoSetHints = true,

        hover_with_actions = true,
        runnables = {
            use_telescope = false

        },
        inlay_hints = {
            show_parameter_hints = true,
            parameter_hints_prefix = " ⇚ ",
            other_hints_prefix = " » ",
            max_len_align = true,
            max_len_align_padding = 20,
            right_align = false,
            right_align_padding = 7
        },
        hover_actions = {
            -- the border that is used for the hover window
            -- see vim.api.nvim_open_win()
            border = {
                {"╭", "FloatBorder"},
                {"─", "FloatBorder"},
                {"╮", "FloatBorder"},
                {"│", "FloatBorder"},
                {"╯", "FloatBorder"},
                {"─", "FloatBorder"},
                {"╰", "FloatBorder"},
                {"│", "FloatBorder"}
            }
        }
    },
    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = {
        settings = {
            ["rust-analyzer"] = {
                assist = {
                    importGranularity = "module",
                    importPrefix = "by_crate"
                },
                cargo = {
                    loadOutDirsFromCheck = true
                },
                procMacro = {
                    enable = true
                },
                checkOnSave = {
                    allFeatures = true,
                    overrideCommand = {
                        "cargo",
                        "clippy",
                        "--workspace",
                        "--message-format=json",
                        "--all-targets",
                        "--all-features"
                    }
                }
            }
        },
        on_attach = function(client)
            require "lsp_signature".on_attach(cfg)
            client.resolved_capabilities.document_formatting = false
        end,
        capabilities = capabilities
    } -- rust-analyer options
}

require("rust-tools").setup(opts)
EOF


autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 100)
