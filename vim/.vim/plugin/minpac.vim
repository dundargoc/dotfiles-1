function! s:PackInit()
  packadd minpac

  if exists('*minpac#init')
    call minpac#init()

    call minpac#add('gpanders/vim-man', {'type': 'opt'})
    call minpac#add('gpanders/vim-oldfiles')

    " Tim Pope plugin suite
    call minpac#add('tpope/vim-unimpaired')
    call minpac#add('tpope/vim-fugitive')
    call minpac#add('tpope/vim-surround')
    call minpac#add('tpope/vim-repeat')
    call minpac#add('tpope/vim-commentary')
    call minpac#add('tpope/vim-dispatch')
    call minpac#add('tpope/vim-projectionist')
    call minpac#add('tpope/vim-rsi')
    call minpac#add('tpope/vim-eunuch')
    call minpac#add('tpope/vim-characterize')
    call minpac#add('tpope/vim-abolish')
    call minpac#add('tpope/vim-speeddating')
    call minpac#add('tpope/vim-scriptease')

    " Better directory browser
    call minpac#add('justinmk/vim-dirvish')

    " Like f or t but uses 2 characters, e.g. ssn to jump to 'sneak'
    call minpac#add('justinmk/vim-sneak')

    " More, better, and up-to-date language packs (ftplugins, syntax files, etc)
    call minpac#add('sheerun/vim-polyglot')

    " Align lines to a character, e.g. =, ;, :, etc.
    call minpac#add('junegunn/vim-easy-align')

    " Distraction-free writing
    call minpac#add('junegunn/goyo.vim')

    " Show change signs in the gutter for git files
    call minpac#add('airblade/vim-gitgutter')

    " Auto generate tags files
    call minpac#add('ludovicchabant/vim-gutentags')

    " Make working with REPLs so much better
    call minpac#add('jpalardy/vim-slime')

    " Note taking and knowledge tracking
    call minpac#add('vimwiki/vimwiki', {'rev': 'dev'})

    " Quickfix window improvements
    call minpac#add('romainl/vim-qf')

    " Populate results of :ilist and :dlist in quickfix window
    call minpac#add('romainl/vim-qlist')

    " Code snippets
    call minpac#add('SirVer/ultisnips')

    " Language specific
    " Python
    call minpac#add('davidhalter/jedi-vim')
    call minpac#add('drgarcia1986/python-compilers.vim')

    " LaTeX
    call minpac#add('lervag/vimtex')

    " Language Server Client
    " call minpac#add('neoclide/coc.nvim', {'branch': 'v0.0.64', 'type': 'opt', 'do': 'call coc#util#install()'})
    " Asynchronous linting
    call minpac#add('w0rp/ale', {'type': 'opt'})

    " Colorschemes
    call minpac#add('romainl/flattened', {'type': 'opt'})
    call minpac#add('romainl/Apprentice', {'type': 'opt'})
    call minpac#add('danielwe/base16-vim', {'type': 'opt'})
  endif
endfunction

let s:file = expand('<sfile>:p')
command! PackUpdate execute 'source ' . s:file | call <SID>PackInit() | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  execute 'source ' . s:file | call <SID>PackInit() | call minpac#clean()
