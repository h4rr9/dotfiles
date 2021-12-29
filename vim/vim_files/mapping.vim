
" Use ESC to exit insert mode in :term
tnoremap <Esc> <C-\><C-n>

"Indent block
vmap <Tab> >gv
vmap <S-Tab> <gv

"map leader key
noremap <Space> <Nop>
let mapleader = "\<Space>"

"sort
vnoremap <Leader>s :sort<CR>

" fast naviagtion
nnoremap <silent><leader>n :tabnext<cr>
nnoremap <silent><leader>p :tabprev<cr>

" tmux and vim pane navigation
" done by vim-tmux-navigator plugin

"Stop using arrow keys!!!
nnoremap <Up> <NOP>
nnoremap <Down> <NOP>
nnoremap <Left> <NOP>
nnoremap <Right> <NOP>

" LSP Mappings
nnoremap <silent> <leader>gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <leader>gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <leader>gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <leader>gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <leader>gh <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <leader>gs <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> <leader>gS <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> <leader>K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>rn :lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <leader>sd :lua vim.lsp.diagnostic.show_line_diagnostics(); vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent> <C-n> <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> <C-p> <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> <leader>ac <cmd>Telescope lsp_code_actions<CR>
nnoremap <silent> <leader>gx <cmd>TroubleToggle<CR>

" Quickfix list nav
nnoremap <leader>C :cclose<CR>

" Quick source file
nnoremap <leader><leader> <cmd>so %<cr>

" yank all
nnoremap <leader>yy :%y*<cr>

" run test cases
nnoremap <leader>rr <cmd>lua require('runner').get_results()<cr>

"smart delete buffers (nvim-bufdel)
nnoremap <leader>db <cmd>BufDel<cr>


" hacks
" Normal vim behaviour
nnoremap Y y$

" keep things centered
nnoremap n nzzzv
nnoremap N Nzzzv

nnoremap J mzJ`z

"undo breakpoints
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u

" jump list mutation
nnoremap <expr> k (v:count > 3 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 3 ? "m'" . v:count : "") . 'j'

" moving lines
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

"easy replace
nnoremap cn *``cgn
nnoremap cN *``cgN

nnoremap <silent> <leader>so :Spotify<CR>


