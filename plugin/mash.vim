" ============================================================================
" File:        mash - Motion Activated Search Highlighter for Vim
" Description: Differently highlight search under cursor for better clarity
" Author:      Barry Arthur <barry dot arthur at gmail dot com>
" Created:     8 August, 2011
" Last Change: 10 February, 2012
" Website:     http://github.com/dahu/vim-mash
"
" See mash.txt for help.  This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help mash
"
" Licensed under the same terms as Vim itself.
" ============================================================================
let s:Mash_version = '0.0.3'

" History:{{{1
" v.0.0.3 Mash Fog of War mode      - Magnus Woldrich
" * New maps
"   * <leader>mf - enable Fog of War
"   * <leader>mF - disable Fog of War
"   * <c-l> to clear mash mode
" v.0.0.2 honour ignorecase option  - Stanislav Seletskiy
" v.0.0.1 initial release:
" * Highlights current match under cursor. Uses IncSearch highlight group.
" * Issues:
"   * Fails if the search uses an offset other than start-of-pattern, like
"     /foo/e
"
" Mash Setup:{{{1
let s:old_cpo = &cpo
set cpo&vim

" grey fog of war
try | silent hi MashFOW | catch /^Vim\%((\a\+)\)\=:E411/ | hi MashFOW ctermfg=grey ctermbg=NONE guifg=grey guibg=NONE | endtry

" Options
" Mash FOW enabled?:{{{1
let b:mash_use_fow = 0

" Funcs:{{{1
function! s:Mash()
  try
    call matchdelete(b:mash_search_item)
    call matchdelete(b:mash_fow_item)
  catch /^Vim\%((\a\+)\)\=:E/   " ignore E802/E803
  endtry
  if exists('b:mash_use_fow') && b:mash_use_fow
    let b:mash_fow_item = matchadd('MashFOW', '.*', 1)
    let b:mash_search_item = matchadd('IncSearch',  (&ignorecase ? '\c' : '') . @/, 2)
  else
    let b:mash_search_item = matchadd('IncSearch',  (&ignorecase ? '\c' : '') . '\%#'.@/, 2)
  endif
endfunction

function! s:UnMash()
  try
    call matchdelete(b:mash_search_item)
    call matchdelete(b:mash_fow_item)
  catch /^Vim\%((\a\+)\)\=:E/
  endtry
endfunction

" Maps:{{{1
" Shadow Maps
nnoremap <silent> n n:call <SID>Mash()<CR>
nnoremap <silent> N N:call <SID>Mash()<CR>
nnoremap <silent> # #:call <SID>Mash()<CR>
nnoremap <silent> * *:call <SID>Mash()<CR>
nnoremap <silent> g# g#:call <SID>Mash()<CR>
nnoremap <silent> g* g*:call <SID>Mash()<CR>

" Customisable Maps
nnoremap <silent> <Plug>MashFOWEnable  :let b:mash_use_fow = 1<CR>:call <SID>Mash()<CR>
nnoremap <silent> <Plug>MashFOWDisable :let b:mash_use_fow = 0<CR>:call <SID>Mash()<CR>
nnoremap <silent> <Plug>MashUnMash     :call <SID>UnMash()<CR>:noh<cr>

if !hasmapto('<Plug>MashFOWEnable')
  nmap <leader>mf <Plug>MashFOWEnable
endif
if !hasmapto('<Plug>MashFOWDisable')
  nmap <leader>mF <Plug>MashFOWDisable
endif
if !hasmapto('<Plug>MashUnMash')
  nmap <c-l> <Plug>MashUnMash
endif

" Teardown:{{{1
"reset &cpo back to users setting
let &cpo = s:old_cpo

" vim: set sw=2 sts=2 et fdm=marker:
