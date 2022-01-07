command! -bang -buffer -nargs=? EvalBlock
            \ if <bang>0 |
            \   call medieval#eval('self') |
            \ else |
            \   call medieval#eval(<q-args>) |
            \ endif

nnoremap <silent> <Plug>(medieval-eval) :<C-U>call medieval#eval()<CR>

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '') . '|delc EvalBlock'
