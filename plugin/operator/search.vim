scriptencoding utf-8
if exists('g:loaded_operator_search')
  finish
endif
let g:loaded_search = 1

let s:save_cpo = &cpo
set cpo&vim


call operator#user#define('search', 'operator#search#do')


let &cpo = s:save_cpo
unlet s:save_cpo
