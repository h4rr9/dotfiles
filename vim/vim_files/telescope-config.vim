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
        prompt_prefix = "> ",
        selection_caret = "> ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        scroll_strategy = "cycle",
        layout_config = {
            prompt_position = "top",
            width = 0.75,
            height = 0.75,
            preview_cutoff = 120,
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
        path_display = {},
        winblend = 0,
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
                override_generic_sorter = true,
                override_file_sorter = true
            },
		lsp_handlers = {
			code_action = {
				telescope = require('telescope.themes').get_dropdown({}),
			},
		},
  ["ui-select"] = {
      require("telescope.themes").get_dropdown {
        -- even more opts
      }
    }
        }
    }
}

require("telescope").load_extension("ui-select")
require('telescope').load_extension('fzy_native')
require'telescope'.load_extension('zoxide')
require('telescope').load_extension('lsp_handlers')
require('telescope').load_extension('neoclip')

search_dotfiles = function()
    require("telescope.builtin").find_files(
        require("telescope.themes").get_dropdown(
            {
                path_display = {'shorten'},
                prompt_title = "< VimRC >",
                cwd = "~/.config/nvim"
            }
        )
    )
end

search_cp = function()
    require("telescope.builtin").find_files(
        require("telescope.themes").get_dropdown(
            {
                prompt_title = "< cp >",
                cwd = "~/cp"
            }
        )
    )



end

vim.api.nvim_set_keymap("n", "<leader>fne", [[:lua search_dotfiles()<CR>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>fcp", [[:lua search_cp()<CR>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>fs", [[:lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep for >")})<CR>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>fgf", [[:lua require('telescope.builtin').git_files()<CR>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>fgb", [[:lua require('telescope.builtin').git_branches()<CR>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>fgc", [[:lua require('telescope.builtin').git_commits()<CR>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>ff", [[:lua require('telescope.builtin').find_files({find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<CR>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>fe", [[:lua require('telescope.builtin').file_browser()<CR>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>fif", [[:lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>fb", [[:lua require('telescope.builtin').buffers()<CR>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>fcd", [[:lua require('telescope').extensions.zoxide.list({show_score = false})<CR>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>fp", [[:lua require('telescope').extensions.neoclip.neoclip()<CR>')]], {noremap = true, silent = true})



EOF
