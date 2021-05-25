"Theme
let g:lightline = {}
let g:lightline.colorscheme = 'gruvbox'
let g:gruvbox_italic=1
let g:gruvbox_contrast_dark = 'hard'

if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif


let g:gruvbox_invert_selection='0'
colorscheme gruvbox
set background=dark


augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 100})
augroup END
