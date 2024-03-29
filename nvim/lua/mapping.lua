-- leader key
vim.keymap.set('n', ' ', '<Nop>')
vim.g.mapleader = ' '

-- indent block
vim.keymap.set('v', '<Tab>', '>gv')
vim.keymap.set('v', '<S-Tab>', '<gv')

-- quick exit from insert mode
vim.keymap.set('i', 'jj', '<Esc>')
-- this is a comment

-- sort
vim.keymap.set('v', '<leader>s', '<cmd>sort<cr>')

-- navigation

vim.keymap.set('n', '<Up>', '<Nop>')
vim.keymap.set('n', '<Down>', '<Nop>')
vim.keymap.set('n', '<Left>', '<Nop>')
vim.keymap.set('n', '<Right>', '<Nop>')

-- lsp mappings
vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition)
vim.keymap.set('n', '<leader>gD', vim.lsp.buf.declaration)
vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references)
vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation)
vim.keymap.set('n', '<leader>gh', vim.lsp.buf.signature_help)
vim.keymap.set('n', '<leader>gs', vim.lsp.buf.document_symbol)
vim.keymap.set('n', '<leader>gS', vim.lsp.buf.workspace_symbol)
vim.keymap.set('n', '<leader>K', vim.lsp.buf.hover)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>ac', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>bf', function()
    vim.lsp.buf.format { async = true }
end)

vim.keymap.set('n', '<leader>sd', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_next)
vim.keymap.set('n', ']d', vim.diagnostic.goto_prev)

-- quickfix list
vim.keymap.set('n', '<leader>C', '<cmd>cclose<cr>')

-- quick source
vim.keymap.set('n', '<leader><leader>', '<cmd>so %<cr>')

-- yank maps
vim.keymap.set('n', '<leader>yy', '<cmd>%y*<cr>')
vim.keymap.set('n', 'Y', 'y$')

-- smart delete buffer
vim.keymap.set('n', '<leader>db', '<cmd>BufDel<cr>')

-- search
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- text movement

vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('v', 'J', [[:m '>+1<cr>gv=gv]])
vim.keymap.set('v', 'K', [[:m '<-2<cr>gv=gv]])

-- easy replace
vim.keymap.set('n', 'cn', '*``cgn')
vim.keymap.set('n', 'cN', '*``cgN')

-- undo breakpoints

-- jump list mutation
vim.keymap.set('i', ',', ',<c-g>u')
vim.keymap.set('i', '.', '.<c-g>u')
vim.keymap.set('i', '!', '!<c-g>u')
vim.keymap.set('i', '?', '?<c-g>u')

-- neogen
vim.keymap.set('n', '<leader>nf', function()
    require('neogen').generate { type = "func" }
end)
vim.keymap.set('n', '<leader>nc', function()
    require('neogen').generate { type = "class" }
end)
vim.keymap.set('n', '<leader>nF', function()
    require('neogen').generate { type = "file" }
end)
vim.keymap.set('n', '<leader>nt', function()
    require('neogen').generate { type = "type" }
end)
-- telescope

vim.keymap.set('n', '<leader>fne', require 'config.telescope'.search_dotfiles)
vim.keymap.set('n', '<leader>fcp', require 'config.telescope'.search_cp)
vim.keymap.set('n', '<leader>fs', function()
    require('telescope.builtin').grep_string({ search = vim.fn.input('Grep for >') })
end)
vim.keymap.set('n', '<leader>fgf', function()
    require('telescope.builtin').git_files({ show_untracked = false, recurse_submodules = true })
end)
vim.keymap.set('n', '<leader>fgb', require('telescope.builtin').git_branches)
vim.keymap.set('n', '<leader>fgc', require('telescope.builtin').git_commits)
vim.keymap.set('n', '<leader>ff', require 'config.telescope'.project_files)
vim.keymap.set('n', '<leader>fif', require('telescope.builtin').current_buffer_fuzzy_find)
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers)
vim.keymap.set('n', '<leader>fp', require('telescope').extensions.neoclip.neoclip)
vim.keymap.set('n', '<leader>fe', require('telescope').extensions.file_browser.file_browser)
vim.keymap.set('n', '<leader>fr', require('telescope').extensions.frecency.frecency)
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').oldfiles)

-- gitsigns

vim.keymap.set('n', ']c', '&diff ? \']c\' : \'<cmd>Gitsigns next_hunk<CR>\'', { expr = true })
vim.keymap.set('n', '[c', '&diff ? \'[c\' : \'<cmd>Gitsigns prev_hunk<CR>\'', { expr = true })
vim.keymap.set({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
vim.keymap.set('n', '<leader>hS', require 'gitsigns'.stage_buffer)
vim.keymap.set('n', '<leader>hu', require 'gitsigns'.undo_stage_hunk)
vim.keymap.set('n', '<leader>hR', require 'gitsigns'.reset_buffer)
vim.keymap.set('n', '<leader>hp', require 'gitsigns'.preview_hunk)
vim.keymap.set('n', '<leader>hb', function()
    require 'gitsigns'.blame_line { full = true }
end)
vim.keymap.set('n', '<leader>htb', require 'gitsigns'.toggle_current_line_blame)
vim.keymap.set('n', '<leader>hd', require 'gitsigns'.diffthis)
vim.keymap.set('n', '<leader>hD', function()
    require 'gitsigns'.diffthis('~')
end)
vim.keymap.set('n', '<leader>td', require 'gitsigns'.toggle_deleted)

-- runner
vim.keymap.set('n', '<leader>rr', require('runner').get_results)

-- luasnip
vim.keymap.set({ 'i', 's' }, '<C-j>', function()
    if require 'luasnip'.jumpable(1) then require('luasnip').jump(1) end
end)
vim.keymap.set({ 'i', 's' }, '<C-k>', function()
    if require 'luasnip'.jumpable(-1) then require('luasnip').jump(-1) end
end)

vim.keymap.set({ 'i', 's' }, '<C-l>', function()
    if require('luasnip').choice_active() then require('luasnip').change_choice(1) end
end)
vim.keymap.set({ 'i', 's' }, '<C-h>', function()
    if require('luasnip').choice_active() then require('luasnip').change_choice(-1) end
end)

-- telekasten
vim.keymap.set('n', '<leader>zf', function()
    require('telekasten').find_notes()
end)
vim.keymap.set('n', '<leader>zd', function()
    require('telekasten').find_daily_notes()
end)
vim.keymap.set('n', '<leader>zg', function()
    require('telekasten').search_notes()
end)
vim.keymap.set('n', '<leader>zz', function()
    require('telekasten').follow_link()
end)
vim.keymap.set('n', '<leader>z', function()
    require('telekasten').panel()
end)
