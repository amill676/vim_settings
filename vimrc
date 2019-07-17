" The 'tab drop' command opens a new tab if a tab doesnt
" already exist with the file. Unfortunately it only seems to be available
" on vim versions that were built with GUI support. Here is a replacement
" that was copied from
" https://github.com/ohjames/tabdrop/blob/master/plugin/tabdrop.vim
function! s:TabDropHelper(file, here)
  let visible = {}
  let path = fnamemodify(a:file, ':p')
  for t in range(1, tabpagenr('$'))
    for b in tabpagebuflist(t)
      if fnamemodify(bufname(b), ':p') == path
        if a:here
          let current = tabpagenr()
          exec "tabnext " . t
          exec "tabmove " . (current - 1)
        else
          exec "tabnext " . t
        endif
        return
      endif
    endfor
  endfor

  if bufname('') == '' && &modified == 0
    exec "edit " . a:file
  else
    exec "tabnew " . a:file
  end
endfunction

function! s:TabDrop(file)
  if exists(":drop")
    exec "tab drop " . a:file
  else
    call s:TabDropHelper(a:file, 0)
  end
endfunction

function! s:TabDropHere(file)
  call s:TabDropHelper(a:file, 1)
endfunction

command! -nargs=1 -complete=file TabDrop call s:TabDrop(<q-args>)
command! -nargs=1 -complete=file TabDropHere call s:TabDropHere(<q-args>)
"=================================================
" Figure out what OS this is
function! GetRunningOS()
  if has("win32")
    return "win"
  endif
  if has("unix")
    if system('uname')=~'Darwin'
      return "mac"
    else
      return "linux"
    endif
  endif
endfunction
let os = GetRunningOS()

"=================================================
" plug.vim setup
call plug#begin('~/.vim/plugged')
" Make sure you use single quotes

" On Mac OS homebrew puts fzf in /usr/local/opt. On linux we put in home dir
if os ==? "linux"
    Plug '~/.fzf'
else
    Plug '/usr/local/opt/fzf'
endif
Plug 'micha/vim-colors-solarized'
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
let g:fzf_action = {
  \ 'ctrl-t': 'TabDropHere',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }
