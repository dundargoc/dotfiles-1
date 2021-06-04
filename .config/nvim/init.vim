augroup init | execute 'autocmd!' | augroup END

autocmd init ColorScheme * highlight Comment gui=italic cterm=italic

silent! colorscheme base16-eighties

highlight link TrailingWhitespace Error

set breakindent
set confirm
set cursorline
set foldlevelstart=99
set hidden
set ignorecase
set inccommand=nosplit
set lazyredraw
set linebreak
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set matchpairs+=<:>
set pumheight=10
set scrolloff=2
set shell=/bin/sh
set showmatch
set sidescrolloff=5
set smartcase
set noswapfile
set tagcase=match
set undofile
set updatetime=100
set virtualedit+=block
set wildignore+=*.pyc,__pycache__,.DS_Store,*~,#*#
set wildignorecase
set wildmode=longest:full,full

let &colorcolumn = '+' . join(range(1, 256), ',+')

setglobal path=.,,
setglobal include=
setglobal includeexpr=
setglobal define=
setglobal isfname+=@-@

set grepformat^=%f:%l:%c:%m
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case
else
  set grepprg=grep\ --line-number\ --recursive\ -I\ $*\ /dev/null
endif

" Enable indent-heuristic to make vimdiff more closely match git diff
set diffopt+=indent-heuristic

" Set undo points when deleting
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" Make * and # work in visual mode
xnoremap * y/\V<C-R>"<CR>
xnoremap # y?\V<C-R>"<CR>

nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap Q <Nop>
nnoremap gQ <Nop>
nnoremap <Space>w :w<CR>
nnoremap <Space>b :ls<CR>:b<Space>
nnoremap <C-W><Space>b :ls<CR>:sb<Space>
nnoremap <Space>e :e %:p:h/<Tab>
nnoremap <C-W><Space>e :sp %:p:h/<Tab>
nnoremap <silent> <C-L> :<C-U>nohlsearch<Bar>diffupdate<Bar>syn sync minlines=50<CR><C-L>
vnoremap <silent> <C-L> :<C-U>nohlsearch<Bar>diffupdate<Bar>syn sync minlines=50<CR>gv<C-L>

" Format whole buffer with formatprg without changing cursor position
" See :h restore-position
nnoremap gq<CR> mzHmygggqG`yzt`z

" Unimpaired style mappings
nnoremap <expr> [a ":\<C-U>" . v:count1 . "prev\<CR>"
nnoremap <expr> ]a ":\<C-U>" . v:count1 . "next\<CR>"
nnoremap <expr> [b ":\<C-U>" . v:count1 . "bprev\<CR>"
nnoremap <expr> ]b ":\<C-U>" . v:count1 . "bnext\<CR>"
nnoremap <expr> [l ":\<C-U>" . v:count1 . "lprev\<CR>"
nnoremap <expr> ]l ":\<C-U>" . v:count1 . "lnext\<CR>"
nnoremap <expr> [<C-L> ":\<C-U>" . v:count1 . "lolder\<CR>"
nnoremap <expr> ]<C-L> ":\<C-U>" . v:count1 . "lnewer\<CR>"
nnoremap <expr> [q ":\<C-U>" . v:count1 . "cprev\<CR>"
nnoremap <expr> ]q ":\<C-U>" . v:count1 . "cnext\<CR>"
nnoremap <expr> [<C-Q> ":\<C-U>" . v:count1 . "colder\<CR>"
nnoremap <expr> ]<C-Q> ":\<C-U>" . v:count1 . "cnewer\<CR>"
nnoremap <expr> [t ":\<C-U>" . v:count1 . "tprev\<CR>"
nnoremap <expr> ]t ":\<C-U>" . v:count1 . "tnext\<CR>"
nnoremap [A :<C-U>first<CR>
nnoremap ]A :<C-U>last<CR>
nnoremap [B :<C-U>bfirst<CR>
nnoremap ]B :<C-U>blast<CR>
nnoremap [L :<C-U>lfirst<CR>
nnoremap ]L :<C-U>llast<CR>
nnoremap [Q :<C-U>cfirst<CR>
nnoremap ]Q :<C-U>clast<CR>
nnoremap [T :<C-U>tfirst<CR>
nnoremap ]T :<C-U>tlast<CR>
nnoremap <expr> [e ":\<C-U>.move --" . v:count1 . "\<CR>"
nnoremap <expr> ]e ":\<C-U>.move +" . v:count1 . "\<CR>"
xnoremap <expr> [e ":move --" . v:count1 . "\<CR>gv"
xnoremap <expr> ]e ":move +" . (v:count1 + line("'>") - line("'<")) . "\<CR>gv"
nnoremap [<Space> :<C-U>put! =repeat(nr2char(10), v:count1)<CR><CR>:']+1<CR>
nnoremap ]<Space> :<C-U>put =repeat(nr2char(10), v:count1)<CR><CR>:'[-1<CR>
nnoremap <expr> yon ':setlocal ' . (&number ? 'no' : '') . "number\<CR>"
nnoremap <expr> yor ':setlocal ' . (&relativenumber ? 'no' : '') . "relativenumber\<CR>"
nnoremap <expr> yol ':setlocal ' . (&list ? 'no' : '') . "list\<CR>"
nnoremap <expr> yoc ':setlocal ' . (&cursorline ? 'no' : '') . "cursorline\<CR>"
nnoremap <expr> yo<Bar> ':setlocal ' . (&cursorcolumn ? 'no' : '') . "cursorcolumn\<CR>"
nnoremap <expr> yod ':' . (&diff ? 'diffoff' : 'diffthis') . "\<CR>"
nnoremap <expr> yos ':setlocal ' . (&spell ? 'no' : '') . "spell\<CR>"

nnoremap m<CR> :make<CR>
nnoremap m<Space> :make<Space>
nnoremap m? :set makeprg?<CR>

nnoremap <Bslash>ev :edit $MYVIMRC<CR>

function! Sort(type, ...) abort
    '[,']sort
    call setpos('.', getpos("''"))
endfunction
nnoremap <silent> gs m':set operatorfunc=Sort<CR>g@
xnoremap <silent> gs :sort<CR>

cnoremap <expr> <C-P> wildmenumode() ? "\<C-P>" : "\<Up>"
cnoremap <expr> <C-N> wildmenumode() ? "\<C-N>" : "\<Down>"
cnoremap <expr> <C-J> pumvisible() ? "\<Down>\<Tab>" : "\<C-J>"
cnoremap <expr> <C-K> pumvisible() ? "\<Up>\<Tab>" : "\<C-K>"

augroup init

autocmd BufWinEnter * if &previewwindow | nnoremap <buffer> q <C-W>q | endif

autocmd TextYankPost * lua vim.highlight.on_yank {higroup="Visual", timeout=150, on_visual=true}

if argc() == 0 && filereadable('Session.vim')
  if v:vim_did_enter
    source Session.vim
  else
    autocmd VimEnter * nested source Session.vim
  endif
endif

augroup END
