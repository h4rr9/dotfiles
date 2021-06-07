"Theme
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

"let g:nord_contrast = 1
"let g:nord_borders = 1
"let g:nord_disable_background = 0
"let g:nord_cursorline_transparent = 0

let g:gruvbox_contrast_dark = "hard"
let g:gruvbox_bold = 0
let g:gruvbox_underline = 0
let g:gruvbox_invert_selection = 0

set background=dark
colorscheme gruvbox


highlight ColorColumn ctermbg=0 guibg=blue
hi SignColumn guibg=none
highlight Normal guibg=none
hi CursorLineNR guibg=None
highlight LineNr guifg=#5eacd3
highlight qfFileName guifg=#aed75f

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 100})
augroup END
