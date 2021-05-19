call plug#begin('~/AppData/Local/nvim/plugged')

Plug 'wikitopian/hardmode'
Plug 'gruvbox-community/gruvbox'
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdcommenter'
Plug 'machakann/vim-highlightedyank'
Plug 'tmhedberg/SimpylFold'
Plug 'mbbill/undotree'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}
Plug 'jackguo380/vim-lsp-cxx-highlight'
Plug 'preservim/nerdtree'
Plug 'Chiel92/vim-autoformat'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'mbbill/undotree'
Plug 'itchyny/lightline.vim'

call plug#end()

filetype off
filetype plugin indent on
syntax on
set encoding=utf-8
set number
set relativenumber
set incsearch
set ignorecase
set smartcase
set nohlsearch
set tabstop=4
set softtabstop=0
set shiftwidth=4
set shiftround
set expandtab
set nobackup
set noswapfile
set nowritebackup
set nowrap
set tw=79
set fo-=t
set cursorline
set splitbelow
set splitright
set mouse+=a
set foldmethod=indent
set nofoldenable
set noshowmode
set hidden
set pastetoggle=<F2>
set clipboard=unnamed
set bs=2

" Use ESC to exit insert mode in :term
tnoremap <Esc> <C-\><C-n>

"Indent block
vmap <Tab> >gv
vmap <S-Tab> <gv

"map leader key
noremap <Space> <Nop>
let mapleader = "\<Space>"

"NerdTree
nnoremap <Leader>t :NERDTreeToggle<CR>

"move around windows
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h
map <Leader>n <esc>:tabprevious<CR>
map <Leader>m <esc>:tabnext<CR>

"Sort function to Key
vnoremap <Leader>s :sort<CR>

"Theme
let g:lightline = {
            \ 'colorscheme': 'wombat',
            \ }
syntax enable
set background=dark


let g:gruvbox_contrast_dark = 'hard'
colorscheme gruvbox

"HardMode Plugin
let g:HardMode_level = 'wannabe'
let g:HardMode_hardmodeMsg = 'Don''t use this!'
autocmd VimEnter,BufNewFile,BufReadPost * silent! call HardMode()


"Automatic loading of init.vim
autocmd! bufwritepost init.vim source %

"Highlight yank plugin options
hi HighlightedyankRegion cterm=reverse gui=reverse
let g:Highlightedyank_highlight_duration = 1000

" format on save
au BufWrite * :Autoformat

" python paths
let g:python3_host_prog='C:\Users\Hariganesh\AppData\Local\Programs\Python\Python37\python.exe'
let g:python_host_prog='C:\Users\Hariganesh\AppData\Local\Programs\Python\Python37\python.exe'

" comiple/run
autocmd filetype cpp nnoremap <F9> :w <bar> !g++ -g -D _DEBUG -std=c++14 % -o %:r -Wl,--stack,268435456<CR>

function! MySplit( ex_num )

    if expand('%:e') == 'cpp'

        let inp_file = 'in' . a:ex_num
        let out_file = 'out' . a:ex_num
        let output_file = 'out'
        let cpp_file = expand('%')
        let inp_bufnum=bufnr(expand(inp_file))
        let out_bufnum=bufnr(expand(out_file))
        let cpp_bufnum=bufnr(expand(cpp_file))
        let output_bufnum=bufnr(expand(output_file))
        let inp_winnum=bufwinnr(inp_bufnum)
        let out_winnum=bufwinnr(out_bufnum)
        let cpp_winnum=bufwinnr(cpp_bufnum)
        let output_winnum=bufwinnr(output_bufnum)

        if ( inp_winnum == -1 ) && (out_winnum == -1)
            " Jump to existing split
            exe cpp_winnum . "wincmd w"
            exe "normal \<C-W>o"
            exe "vsplit " . output_file
            exe "above split " . inp_file
            exe "vsplit " . out_file
            exe cpp_winnum . "wincmd w"
        else
            " Make new split as usual
            exe cpp_winnum . "wincmd w"
        endif
    endif
endfunction

function! s:ExecuteWithInput(input_number)
    if expand('%:e') == 'cpp'
        let fin = 'in' . a:input_number
        let fout = 'out'
        execute "!%:r < " . fin . " > " . fout
        execute ":Split " . a:input_number
    endif

endfunction

function! s:Execute()
    execute "!%:r"
endfunction

" provide number of inputfile (of the form in{inputnumber})
" :Run 1 (to execute test.exe < in1)
:command -nargs=1 Run call s:ExecuteWithInput(<f-args>)
:command -nargs=1 Split :call MySplit("<args>")
:command Execute call s:Execute()

cabbrev run Run
cabbrev exe Execute

source C:\Users\Hariganesh\AppData\Local\nvim\coc.vim
