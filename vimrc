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
" if os ==? "linux"
     Plug '~/.fzf'
" else
     Plug '/usr/local/opt/fzf'
" endif

Plug 'micha/vim-colors-solarized'
Plug 'junegunn/fzf.vim'
Plug 'https://github.com/tpope/vim-fugitive.git'
Plug 'nvie/vim-flake8'
Plug 'sheerun/vim-polyglot'  " syntax highlighting for lots of languages
"Plug 'Valloric/YouCompleteMe'

" Tag bar displays functions, classes, etc. in file
" Will need to install exuberant ctags: brew install ctags-exuberant
"Plug 'majutsushi/tagbar'
"nmap tt :TagbarToggle<CR>

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

augroup FileTypeSpecificAutocommands
    autocmd FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType scss setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

set guifont=Monaco:h14

" fzf settings
" See https://github.com/junegunn/fzf.vim for explanations
command! -bang RandomFiles call fzf#vim#files('~/vm/random_dossier_files', <bang>0)
:nnoremap <C-p> :Files<Return>
:nnoremap <C-r><C-p> :RandomFiles<Return>
let g:fzf_buffers_jump = 1
let g:fzf_action = {
  \ 'ctrl-t': 'TabDropHere',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }


" Specify the ripgrep command to use for searching over file contents
" let g:rg_command = '
"   \ rg --column --line-number --no-heading --fixed-strings --no-ignore --hidden --follow --color "always"
"   \ -g "*.{js,php,md,styl,jade,html,config,py,cpp,c,go,hs,rb,conf}"
"   \ -g "!*.{csv}"
"   \ -g "!{.git,node_modules,vendor,3rdParty,gsapi}/*" '
" " Map :F to have fzf execute the ripgrep command (and provide fuzziness and search options on top)
" Disabled the following since it wasn't used. If fuzzy search over file
" contents is desired, can map the following command to a shortcut
" command! -bang -nargs=* F call fzf#vim#grep(g:rg_command .shellescape(<q-args>), {'options': ['-e']}, <bang>0)

" See https://github.com/junegunn/fzf.vim#example-advanced-ripgrep-integration
function! RipgrepFzf(query, fullscreen, files)
  let command_fmt = '
    \ rg --column --line-number --no-heading --color=always --smart-case 
    \ -g %s 
    \ -g "!{.git,node_modules,vendor,3rdParty,gsapi,s83}/*"
    \ -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:files), shellescape(a:query))
  let reload_command = printf(command_fmt, shellescape(a:files), '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0, "*.{js,php,md,styl,jade,html,config,py,cpp,c,go,hs,rb,conf,yaml,txt}")
command! -nargs=* -bang PYRG call RipgrepFzf(<q-args>, <bang>0, "*.{py}")
command! -nargs=* -bang JSRG call RipgrepFzf(<q-args>, <bang>0, "*.{js}")
command! -nargs=* -bang CRG call RipgrepFzf(<q-args>, <bang>0, "*.{c,cpp,cc,h}")
:nnoremap <C-f> :RG<Return>
:nnoremap <C-f><C-p> :PYRG<Return>
:nnoremap <C-f><C-j> :JSRG<Return>
:nnoremap <C-f><C-h> :CRG<Return>
