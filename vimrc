" Syntax highlighting
syntax on
set hlsearch

" Colors
syntax enable
set background=dark
colorscheme solarized
se t_Co=16

" Tab formatting
set tabstop=2
set shiftwidth=2
set expandtab

" Numbering
set relativenumber
set ruler
set cursorline

" Pathogen stuffs
execute pathogen#infect()
filetype plugin indent on

" YouCompleteMe
nnoremap <leader>jd :YcmCompleter GoTo<CR>

noremap! \d <C-R>=fnamemodify('<C-R>%', ':h')."/"<CR>
"noremap! \d <C-R>=GetWorkingDirectory()<CR>
noremap! \af <C-R>=fnamemodify('<C-R>%', ':p')<CR>

" Inser t mode commandsto emulate emacs
imap <C-a> <Esc>I
imap <C-e> <Esc>A
imap <C-b> <Esc>i
imap <C-f> <Esc>la
imap <C-d> <Esc>lxi

" Get the CScope Vim mappings
source vim_files/cscope_maps.vim
