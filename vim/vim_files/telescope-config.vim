lua << EOF
local actions = require("telescope.actions")

require("telescope").setup {
    defaults = {
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case"
        },
        prompt_position = "bottom",
        prompt_prefix = "> ",
        selection_caret = "> ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "descending",
        layout_strategy = "horizontal",
        scroll_strategy = "cycle",
        layout_config = {
            width = 0.8,
            height = 0.85,
            horizontal = {
                preview_width = 0.6
            },
            vertical = {
                width = 0.9,
                height = 0.95,
                preview_height = 0.5
            },
            flex = {
                horizontal = {
                    preview_width = 0.9
                }
            }
        },
        layout_defaults = {
            horizontal = {
                mirror = false
            },
            vertical = {
                mirror = false
            }
        },
        borderchars = {"─", "│", "─", "│", "╭", "╮", "╯", "╰"},
        file_sorter = require "telescope.sorters".get_fuzzy_file,
        file_ignore_patterns = {},
        generic_sorter = require "telescope.sorters".get_generic_fuzzy_sorter,
        shorten_path = true,
        winblend = 0,
        width = 0.75,
        preview_cutoff = 120,
        results_height = 1,
        results_width = 0.8,
        border = {},
        borderchars = {"─", "│", "─", "│", "╭", "╮", "╯", "╰"},
        color_devicons = true,
        use_less = true,
        set_env = {["COLORTERM"] = "truecolor"}, -- default = nil,
        file_sorter = require("telescope.sorters").get_fzy_sorter,
        file_previewer = require "telescope.previewers".vim_buffer_cat.new,
        grep_previewer = require "telescope.previewers".vim_buffer_vimgrep.new,
        qflist_previewer = require "telescope.previewers".vim_buffer_qflist.new,
        mappings = {
            i = {
                ["<C-[>"] = actions.close
            }
        },
        extensions = {
            fzy_native = {
                override_generic_sorter = false,
                override_file_sorter = true
            }
        }
    }
}

require("telescope").load_extension("fzy_native")
require'telescope'.load_extension('zoxide')

search_dotfiles = function()
    require("telescope.builtin").find_files(
        {
            shorten_path = false,
            prompt_title = "< VimRC >",
            cwd = "~/.config/nvim",
            previewer = false,
        }
    )
end

search_cp = function()
    require("telescope.builtin").find_files(
        {
            shorten_path = false,
            prompt_title = "< cp >",
            cwd = "~/cp",
            layout_strategy = "horizontal",
            previewer = false,

        }
    )
end

vim.api.nvim_set_keymap("n", "<leader>fne", ":lua search_dotfiles()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>fcp", ":lua search_cp()<CR>", {noremap = true, silent = true})
EOF


nnoremap <silent><leader>fs :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>
nnoremap <silent><leader>fg :lua require('telescope.builtin').git_files()<CR>
nnoremap <silent><Leader>ff :lua require('telescope.builtin').find_files()<CR>
nnoremap <silent><Leader>fe :lua require('telescope.builtin').file_browser()<CR>
nnoremap <silent><Leader>fif :lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>

nnoremap <silent><leader>fb :lua require('telescope.builtin').buffers()<CR>
nnoremap <silent> <leader>F :lua require('telescope').extensions.frecency.frecency()<CR>
nnoremap <silent> <leader>fcd :lua require('telescope').extensions.zoxide.list({show_score = false})<CR>
