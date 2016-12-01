"""""""" Setup tab options """""""
set tabstop=4
set shiftwidth=4
set expandtab "Use spaces instead of tabs

"""""""Setup text""""""""""
" Pathogen stuff
execute pathogen#infect()
Helptags

set gfn=Monaco:h15

" Setup editing appearance
set rnu " relative line numbers!
set ruler "Displayer line and column at bottom
set cursorline " Highlight current cursorline
set hlsearch " Highlight search results

" Editing behaviors
"map j gj
"map k gk
set autoindent

" Set to autoread when a file is changed from the outside
set autoread

" Setup colorscheme
syntax enable
set background=light
colorscheme solarized


" Neocomplcache
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_disable_auto_complete = 1
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<TAB>" : "\<C-x>\<C-u>"
function! s:check_back_space()"{{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~ '\s'
endfunction"}}

" Ctags setup
:set tags=./tags,tags;$HOME
:nnoremap <silent><Leader><C-]> <C-w><C-]><C-w>T

filetype plugin on
set ofu=syntaxcomplete#Complete

" Highlight text beyond point
" highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" match OverLength /\%81v.\+/

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Latex-Suite settings
" REQUIRED. This makes vim invoke Latex-Suite when you open a tex file.
filetype plugin on

" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
set shellslash

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: This enables automatic indentation as you type.
filetype indent on

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults
" to " 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" TagBar setup
nmap <Leader>t :TagbarToggle<CR>

" CtrlP
set wildignore=*.pyc
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_switch_buffer = 'Et'
let g:ctrlp_extensions = ['tag']
let g:ctrlp_custom_ignore = '\v(node_modules|bower_components|build|\.compiled-static)$'

" Unite
let g:unite_source_history_yank_enable = 1
call unite#filters#matcher_default#use(['matcher_fuzzy'])
" nnoremap <leader>t :<C-u>Unite -no-split -buffer-name=files   -start-insert file_rec/async:!<cr>
nnoremap <leader>f :<C-u>Unite file -start-insert<cr>
nnoremap <leader>r :<C-u>Unite -start-insert file_rec/async:!<CR>
nnoremap <leader>d :<C-u>Unite buffer-name=files -path=expand('%:h') -start-insert<cr>
nnoremap <leader>m :<C-u>Unite -buffer-name=mru     -start-insert file_mru<cr>
nnoremap <leader>o :<C-u>Unite -buffer-name=outline -start-insert outline<cr>
nnoremap <leader>y :<C-u>Unite -buffer-name=yank    history/yank<cr>
nnoremap <leader>e :<C-u>Unite -buffer-name=buffer  buffer<cr>
nnoremap <leader>c :<C-u>Unite -buffer-name=codesearch -start-insert codesearch<cr>
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
  " Overwrite settings.
  imap <silent><buffer><expr> <C-s>     unite#do_action('split')
  imap <silent><buffer><expr> <C-v>     unite#do_action('vsplit')
  imap <silent><buffer><expr> <C-t>     unite#do_action('tabswitch')
  imap <silent><buffer><expr> <C-l>     unite#do_action('right')
  imap <silent><buffer><expr> <C-h>     unite#do_action('left')
endfunction

" Codesearch unite
let g:unite_source_codesearch_command = '/Users/adamjmiller/go/bin/csearch'
let g:unite_source_codesearch_max_candidates = 100

" Deal with CScope mapping and autoloading
source ~/vim_settings/vim_files/cscope_maps.vim
function! LoadCscope()
  let db = findfile("cscope.out", ".;")
  if (!empty(db))
    let path = strpart(db, 0, match(db, "/cscope.out$"))
    set nocscopeverbose " suppress 'duplicate connection' error
    exe "cs add " . db . " " . path
    set cscopeverbose
  endif
endfunction
au BufEnter /* call LoadCscope()

" Matchit
source ~/.vim/plugin/matchit.vim

" Fix problem with not being able to delete autoindents
:set backspace=indent,eol,start
