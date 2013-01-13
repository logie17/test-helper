"=============================================================================
" File:        test-helper.vim
" Author:      Logan Bell (loganbell@gmail.com)
" Version:     0.1
"=============================================================================

if exists('loaded_test_helper') || &cp
  finish
endif
let loaded_test_helper=1

function! s:TestHelper(filename) 
    function! s:CreateEntriesFromDir(recursive)
        normal! mk
        let line=line('.')
        let name = inputdialog('Is this the path you wish to execute?')
        if strlen(name) == 0
            return
        endif
    
        if exists(':TestHelper') != 2
            command -nargs=? -complete=file TestHelper call <SID>TestHelper('<args>')
        endif
    endfunction
    nnoremap <buffer> <silent> <LocalLeader>c :call <SID>CreateEntriesFromDir(1)<CR>
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

nnoremap <script> <Plug>ToggleTestHelper :call <SID>DoToggleTestHelper()<CR>
if !hasmapto('<Plug>ToggleTestHelper')
    nmap <silent> <F11> <Plug>ToggleTestHelper
endif

finish
