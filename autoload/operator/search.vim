scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

function! s:region_search_pattern(first, last, pattern)
	if a:first == a:last
		return printf('\%%%dl%s\%%%dc', a:first[0], a:pattern, a:first[1])
	elseif a:first[0] == a:last[0]
		return printf('\%%%dl\%%>%dc%s\%%<%dc', a:first[0], a:first[1]-1, a:pattern, a:last[1]+1)
	elseif a:last[0] - a:first[0] == 1
		return  printf('\%%%dl%s\%%>%dc', a:first[0], a:pattern, a:first[1]-1)
\		. "\\|" . printf('\%%%dl%s\%%<%dc', a:last[0], a:pattern, a:last[1]+1)
	else
		return  printf('\%%%dl%s\%%>%dc', a:first[0], a:pattern, a:first[1]-1)
\		. "\\|" . printf('\%%>%dl%s\%%<%dl', a:first[0], a:pattern, a:last[0])
\		. "\\|" . printf('\%%%dl%s\%%<%dc', a:last[0], a:pattern, a:last[1]+1)
	endif
endfunction


function! operator#search#do(motion_wise)
	let pattern = input("Input search pattern: ")
	if empty(pattern)
		return
	endif
	let @/ = s:region_search_pattern(getpos("'[")[1:], getpos("']")[1:], pattern)
	try
		normal! n
		call feedkeys(":set hlsearch\<CR>", 'n')
	catch /^Vim\%((\a\+)\)\=:E486/
		echohl ErrorMsg | echo "Not found pattern: " . pattern | echohl None
	endtry
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
