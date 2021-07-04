" compile fast
autocmd filetype cpp nnoremap <F8> :w <bar> !g++ -std=c++17 -Wall -Wextra -O2 % -o %:r -D _STACK<CR>
" compile safe
autocmd filetype cpp nnoremap <F9> :w <bar> !g++ -std=c++17 -Wall -Wno-unused-result % -o %:r -g -fsanitize=address -fsanitize=undefined -D _DEBUG -D _STACK<CR>

function! MySplit( ex_num )
    let inp_file = expand('%:p:h') . '/in' . a:ex_num
    let out_file = expand('%:p:h') . '/out' . a:ex_num
    let output_file = expand('%:p:h') . '/out'
    let debug_file = expand('%:p:h') . '/debug'
    let cpp_file = expand('%:p')
    let inp_winnum=bufwinnr(bufnr(expand(inp_file)))
    let out_winnum=bufwinnr(bufnr(expand(out_file)))
    let cpp_winnum=bufwinnr(bufnr(expand(cpp_file)))
    let output_winnum=bufwinnr(bufnr(expand(output_file)))



    if (inp_winnum == -1 ) || (out_winnum == -1) || (output_winnum == -1)
        exe cpp_winnum . "wincmd w"

        if winnr('$') > 1
            exe "normal \<C-W>o"
        endif

        exe "vsplit " . output_file
        exe "above split " . inp_file
        exe "vsplit " . out_file
    endif

    let debug_dirty = filereadable(debug_file) && len(readfile(debug_file)) > 0
    let debug_winnum=bufwinnr(bufnr(expand(debug_file)))

    if debug_dirty && (debug_winnum == -1)
        let output_winnum_new=bufwinnr(bufnr(expand(output_file)))
        exe output_winnum_new . 'wincmd w'
        exe 'vsplit ' . debug_file
    endif

    if !debug_dirty && debug_winnum != -1
        exe debug_winnum . 'wincmd w'
        exe "normal \<C-W>c"
    endif
    exe cpp_winnum . "wincmd w"
endfunction

function! s:ExecuteWithInput(input_number)
    if expand('%:e') == 'cpp'
        let fin = expand('%:p:h') . '/in' . a:input_number
        let fout = expand('%:p:h') . '/out'
        let debug = expand('%:p:h') . '/debug'
        execute "!%:p:r < " . fin . " > " . fout . " 2> " . debug
        execute ":Split " . a:input_number
    endif

endfunction

function! s:Execute()
    execute ":!%:r"
endfunction

" provide number of inputfile (of the form in{inputnumber})
" :Run 1 (to execute test.exe < in1)
:command -nargs=1 Run call s:ExecuteWithInput(<f-args>)
:command -nargs=1 Split :call MySplit("<args>")
:command Execute call s:Execute()

cabbrev open <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Split' : 'open')<CR>
cabbrev run <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Run' : 'run')<CR>
cabbrev exe <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Exe' : 'exe')<CR>

ca Hash w !cpp -dD -P -fpreprocessed \| tr -d '[:space:]' \
 \| md5sum \| cut -c-6
