local ok, _ = pcall(require, 'telescope')
if ok then
    local actions = require('telescope.actions')

    require('telescope').setup {
        defaults = {
            vimgrep_arguments = {'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case'},
            prompt_prefix = '> ',
            selection_caret = '> ',
            entry_prefix = '  ',
            initial_mode = 'insert',
            selection_strategy = 'reset',
            sorting_strategy = 'ascending',
            layout_strategy = 'horizontal',
            scroll_strategy = 'cycle',
            layout_config = {
                prompt_position = 'top',
                width = 0.75,
                height = 0.75,
                preview_cutoff = 120,
                horizontal = {prompt_position = 'top', preview_width = 0.55, results_width = 0.8},
                vertical = {mirror = false}
            },
            file_ignore_patterns = {'node_modules'},
            generic_sorter = require'telescope.sorters'.get_generic_fuzzy_sorter,
            path_display = {'truncate'},
            winblend = 0,
            border = {},
            borderchars = {
                {'─', '│', '─', '│', '┌', '┐', '┘', '└'},
                prompt = {'─', '│', ' ', '│', '┌', '┐', '│', '│'},
                results = {'─', '│', '─', '│', '├', '┤', '┘', '└'},
                preview = {'─', '│', '─', '│', '┌', '┐', '┘', '└'}
            },
            color_devicons = true,
            use_less = true,
            set_env = {['COLORTERM'] = 'truecolor'}, -- default = nil,
            file_sorter = require('telescope.sorters').get_fzy_sorter,
            file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
            grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
            qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
            buffer_previewer_maker = require('telescope.previewers').buffer_previewer_maker,
            mappings = {i = {['<C-[>'] = actions.close}},
            extensions = {
                fzy_native = {override_generic_sorter = true, override_file_sorter = true},
                lsp_handlers = {code_action = {telescope = require('telescope.themes').get_dropdown({})}},
                ['ui-select'] = {require('telescope.themes').get_cursor {}}
            }
        }
    }

    require('telescope').load_extension('ui-select')
    require('telescope').load_extension('fzy_native')
    require('telescope').load_extension('lsp_handlers')
    require('telescope').load_extension('neoclip')
    require('telescope').load_extension('file_browser')
    require('telescope').load_extension('frecency')
    require('telescope').load_extension('media_files')
end

local M = {}

M.project_files = function()
    local opts = {find_command = {'rg', '--files', '--hidden', '-g', '!.git'}}
    local t_ok = pcall(require'telescope.builtin'.git_files, opts)
    if not t_ok then require'telescope.builtin'.find_files(opts) end
end

M.search_dotfiles = function()
    require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({
        path_display = {'shorten'},
        prompt_title = '< VimRC >',
        cwd = '~/.config/nvim'
    }))
end

M.search_cp = function()
    require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({prompt_title = '< cp >', cwd = '~/cp'}))
end

return M

