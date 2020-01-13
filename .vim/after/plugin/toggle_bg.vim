" toggle_bg
" Author: Greg Anders <greg@gpanders.com>
" Date: 2019-03-27

if !get(g:, 'loaded_toggle_bg')
  finish
endif

let g:toggle_bg_dark = 'base16-eighties'
let g:toggle_bg_light = 'base16-solarized-light'

nnoremap <silent> <F5> :<C-U>ToggleBg<CR>