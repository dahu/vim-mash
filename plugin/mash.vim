" ============================================================================
" File:        mash - Motion Activated Search Highlighter for Vim
" Description: Differently highlight search under cursor for better clarity
" Author:      Barry Arthur <barry dot arthur at gmail dot com>
" Created:     8 August, 2011
" Last Change: 1 January, 2012
" Website:     http://github.com/dahu/vim-mash
"
" See mash.txt for help.  This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help mash
"
" Licensed under the same terms as Vim itself.
" ============================================================================
let s:Mash_version = '0.0.2'

" History:{{{1
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

" Funcs:{{{1
function! Mash()
  if exists('b:mash_search_item')
    try
      call matchdelete(b:mash_search_item)
    catch /^Vim\%((\a\+)\)\=:E/   " ignore E802/E803
    endtry
  endif
  let b:mash_search_item = matchadd('IncSearch',  (&ignorecase ? '\c' : '') . '\%#'.@/, 1)
endfunction

" Maps:{{{1
nnoremap <silent> n n:call Mash()<CR>
nnoremap <silent> N N:call Mash()<CR>
nnoremap <silent> # #:call Mash()<CR>
nnoremap <silent> * *:call Mash()<CR>

" Teardown:{{{1
"reset &cpo back to users setting
let &cpo = s:old_cpo

" vim: set sw=2 sts=2 et fdm=marker:
