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
        layout_defaults = {
            horizontal = {
                mirror = false
            },
            vertical = {
                mirror = false
            }
        },
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
        file_sorter = require('telescope.sorters').get_fzy_sorter,
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

search_dotfiles = function()
    require("telescope.builtin").find_files(
        {
            prompt_title = "< VimRC >",
            cwd = "~/AppData/Local/nvim"
        }
    )
end

vim.api.nvim_set_keymap("n", "<leader>vrc", ":lua search_dotfiles()<CR>", {noremap = true, silent = true})
EOF


nnoremap <silent><leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>
nnoremap <silent><leader>pg :lua require('telescope.builtin').git_files()<CR>
nnoremap <silent><Leader>pf :lua require('telescope.builtin').find_files()<CR>

nnoremap <silent><leader>pw :lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>
nnoremap <silent><leader>pb :lua require('telescope.builtin').buffers()<CR>
nnoremap <silent><leader>vh :lua require('telescope.builtin').help_tags()<CR>
nnoremap <silent> <leader>P :lua require('telescope').extensions.frecency.frecency()<CR>
