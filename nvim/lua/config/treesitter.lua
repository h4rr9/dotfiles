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
        select = {enable = true, keymaps = {['af'] = '@function.outer', ['if'] = '@function.inner', ['ac'] = '@class.outer', ['ic'] = '@class.inner'}}
    },
    textsubjects = {
        enable = true,
        prev_selection = ',',
        keymaps = {['.'] = 'textsubjects-smart', [';'] = 'textsubjects-container-outer', ['i;'] = 'textsubjects-container-inner'}
    },
    context_commentstring = {enable = true}
}
