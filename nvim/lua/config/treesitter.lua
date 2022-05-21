require'nvim-treesitter.configs'.setup {
    highlight = {enable = true},
    textobjects = {
        move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {[']m'] = '@function.outer', [']]'] = '@class.outer'},
            goto_next_end = {[']M'] = '@function.outer', [']['] = '@class.outer'},
            goto_previous_start = {['[m'] = '@function.outer', ['[['] = '@class.outer'},
            goto_previous_end = {['[M'] = '@function.outer', ['[]'] = '@class.outer'}
        },
        select = {
            enable = true,
            keymaps = {
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['aC'] = '@class.outer',
                ['iC'] = '@class.inner',
                ['ica'] = '@call.inner',
                ['aca'] = '@call.outer',
                ['il'] = '@loop.inner',
                ['al'] = '@loop.outer',
                ['ico'] = '@conditional.inner',
                ['acn'] = '@conditional.outer',
                ['acm'] = '@comment.outer',
                ['ib'] = '@block.inner',
                ['ab'] = '@block.outer'
            }

        }
    },
    textsubjects = {
        enable = true,
        prev_selection = ',',
        keymaps = {['.'] = 'textsubjects-smart', [';'] = 'textsubjects-container-outer', ['i;'] = 'textsubjects-container-inner'}
    },
    context_commentstring = {enable = true},
    matchup = {enable = true}
}

