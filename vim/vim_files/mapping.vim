
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

"Navigation keys
map <Leader>N <esc>:tabnext<CR>
map <Leader>P <esc>:tabprevious<CR>
map <c-h> <c-w>h
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l

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
nnoremap <silent> <leader>K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>rn :lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <leader>sd :lua vim.lsp.diagnostic.show_line_diagnostics(); vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent> <C-n> <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> <C-p> <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent><leader>ac <cmd>lua vim.lsp.buf.code_action()<CR>

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

" Quickfix list nav
nnoremap <leader>n :cnext<CR>
nnoremap <leader>p :cprev<CR>
nnoremap <leader>C :cclose<CR>


" Quick source file
nnoremap <leader><leader> <cmd>luafile %<cr>

" yank all
nnoremap <leader>yy :%y*<cr>

" run test cases
nnoremap <leader>rr <cmd>lua require('runner').get_results()<cr>
