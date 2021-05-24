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
set foldenable
set foldlevelstart=10
set foldnestmax=10
set noshowmode
set hidden
set pastetoggle=<F2>
set clipboard=unnamed
set bs=2
set switchbuf+=useopen
set termguicolors

"Ctrlp settings
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_working_path_mode = 0

if executable('rg')
  set grepprg=rg\ --color=never
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
else
  let g:ctrlp_clear_cache_on_exit = 0
endif



"python paths
let g:python3_host_prog='C:\Users\Hariganesh\AppData\Local\Programs\Python\Python37\python.exe'
let g:python_host_prog='C:\Users\Hariganesh\AppData\Local\Programs\Python\Python37\python.exe'
