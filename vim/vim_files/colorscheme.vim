"Theme
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

let g:gruvbox_contrast_dark = "hard"
let g:gruvbox_underline = 0
let g:gruvbox_invert_selection = 0

set background=dark
colorscheme gruvbox

hi SignColumn guibg=none
highlight Normal guibg=none
hi CursorLine guibg=#3c3836
hi CursorLineNR guibg=None
highlight LineNr guifg=#5eacd3
highlight qfFileName guifg=#aed75f
hi NormalFloat guibg=none
hi FLoatBorder guifg=#ffffff

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 100})
augroup END
