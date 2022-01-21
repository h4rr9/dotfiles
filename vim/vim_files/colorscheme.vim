lua << EOF
require('kanagawa').setup({
    undercurl = true,           -- enable undercurls
    commentStyle = "italic",
    functionStyle = "NONE",
    keywordStyle = "italic",
    statementStyle = "bold",
    typeStyle = "NONE",
    variablebuiltinStyle = "italic",
    specialReturn = true,       -- special highlight for the return keyword
    specialException = true,    -- special highlight for exception handling keywords 
    transparent = false,        -- do not set background color
    dimInactive = false,        -- dim inactive window `:h hl-NormalNC`
    colors = {},
    overrides = {},
})
EOF



"Theme
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

"let g:gruvbox_contrast_dark = "hard"
"let g:gruvbox_underline = 0
"let g:gruvbox_bold=1
" set sign_column to nil in base.lua

set background=dark
colorscheme kanagawa

"highlight SignColumn guibg=none
"highlight Normal guibg=none
"highlight CursorLineNR guibg=None
"highlight LineNr guifg=#5eacd3
"highlight qfFileName guifg=#aed75f
"highlight NormalFloat guibg=none
"highlight FloatBorder guifg=#ebdbb2
"highlight StatusLine guibg=none
"highlight StatusLine guifg=none

"set pumblend=10
"highlight PmenuSel blend=0

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 100})
augroup END
