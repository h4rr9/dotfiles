
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

"Highlight yank
nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>

"CtrlP mappings

nnoremap <C-p> :CtrlP<CR>
nnoremap <C-S-p> :CtrlPMRUFiles<CR>


"Navigation keys
map <Leader>m <esc>:tabnext<CR>
map <Leader>n <esc>:tabprevious<CR>
map <c-h> <c-w>h
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l

"Stop using arrow keys!!!
nnoremap <Up> <NOP>
nnoremap <Down> <NOP>
nnoremap <Left> <NOP>
nnoremap <Right> <NOP>
