if !get(g:, 'loaded_fugitive')
  finish
endif

augroup plugin_fugitive
    autocmd!
    autocmd BufReadPost fugitive://* setlocal bufhidden=delete
    autocmd FileType fugitive,fugitiveblame nmap <silent> <buffer> q gq
augroup END

nnoremap g<Space> :Git<Space>
nnoremap g<CR> :Git<CR>