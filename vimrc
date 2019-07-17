"=================================================
" plug.vim setup
call plug#begin('~/.vim/plugged')
" Make sure you use single quotes

Plug 'micha/vim-colors-solarized'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'https://github.com/tpope/vim-fugitive.git'
Plug 'nvie/vim-flake8'
Plug 'sheerun/vim-polyglot'  " syntax highlighting for lots of languages
"Plug 'Valloric/YouCompleteMe'

" Tag bar displays functions, classes, etc. in file
" Will need to install exuberant ctags: brew install ctags-exuberant
Plug 'majutsushi/tagbar'
nmap tt :TagbarToggle<CR>

" Tools for pull request code review locally (DONT WORK)
" Plug 'google/vim-maktaba'
" Plug 'google/vim-codereview'

" Initialize plugin system
call plug#end()
"=================================================

colorscheme solarized
set background=light

" Setup editing appearance
set rnu " relative line numbers!
set ruler "Displayer line and column at bottom
set cursorline " Highlight current cursorline
set hlsearch " Highlight search results

" Highlight line when too long
"highlight OverLength ctermbg=red ctermfg=white guibg=#592929
"match OverLength /\%100v.\+/

set tabstop=4
set expandtab
set shiftwidth=4

set guifont=Monaco:h14

" fzf settings
:nnoremap <C-p> :Files<Return>
let g:fzf_buffers_jump = 1
" The following function was necessary to open an existing tab for a file if
" it exists. Otherwise you end up with a million tabs for the same file every
" time you search for and open it
function! s:GotoOrOpen(command, ...)
  for file in a:000
    if a:command == 'e'
      exec 'e ' . file
    else
      exec "tab drop " . file
    endif
  endfor
endfunction
command! -nargs=+ GotoOrOpen call s:GotoOrOpen(<f-args>)
let g:fzf_action = {
  \ 'ctrl-t': 'GotoOrOpen tab',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

