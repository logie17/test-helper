"=============================================================================
" File:        test-helper.vim
" Author:      Logan Bell (loganbell@gmail.com)
" Version:     0.1
"=============================================================================

"if exists('loaded_test_helper') || &cp
"  finish
"endif
"let loaded_test_helper=1

function! s:TestHelper(filename) 
    let g:file_map = {}
    if !exists("g:testh_running") || (bufwinnr(g:testh_running) == -1) 
        silent! 99wincmd h
        if bufwinnr(g:testh_running) == -1
            vertical split
            let v:errmsg="nothing"
            silent! bnext
            if 'nothing' != v:errmsg
                enew
            endif
        endif
        return
    endif

    function! s:CreateEntriesFromDir(recursive)
        normal! mk
        let line=line('.')
        let name = inputdialog('Is this the path you wish to execute? ', expand('%:p'))
        if strlen(name) == 0
            return
        endif
        let g:file_map[expand('%:p')] = name
    endfunction

    nnoremap <buffer> <silent> <LocalLeader>E :call <SID>CreateEntriesFromDir(1)<CR>

    let bufname=escape(substitute(expand('%:p', 0), '\\', '/', 'g'), ' ')
    let g:testh_running = bufnr(bufname.'\>')

    if g:testh_running == -1
        call confirm('This is weird', "&OK", 1)
        unlet g:testh_running
    endif

endfunction
if exists(':TestHelper') != 2
    command! -nargs=? -complete=file TestHelper call <SID>TestHelper('<args>')
endif

" Toggle the window where we keep our list?
if !exists("*<SID>DoToggleTestMaps()") 
    function! s:DoToggleTestHelper()
        if !exists('g:testh_running') || bufwinnr(g:testh_running) == -1
            Test_Helper
        else
            let g:testh_window = winnr()
            Test_Helper
            hide
            if(winnr() != g:testh_window)
                wincmd p
            endif
            unlet g:testh_window
        endif
    endfunction
endif 

Test_Helper
nnoremap <script> <Plug>ToggleTestHelper :call <SID>DoToggleTestHelper()<CR>
"if !hasmapto('<Plug>ToggleTestHelper')
    nmap <silent> <C-H> <Plug>ToggleTestHelper
"endif

finish
