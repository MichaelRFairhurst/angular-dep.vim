let _ad_nameregex = '[a-zA-Z_$]\+'
let _ad_qnameregex = '\("' . _ad_nameregex . '"\|''' . _ad_nameregex . '''\)'
let _ad_injectablesregex = '\[\s*\(' . _ad_qnameregex . ',\?\s*\)*'
let _ad_argsregex = '\(\s*' . _ad_nameregex . ',\?\)*\s*'

let _ad_fnregex = 'function\s*(' . _ad_argsregex . '\s*)'
let _ad_exprregex = _ad_injectablesregex . _ad_fnregex

if !exists('g:angular_dep_quote') | let g:angular_dep_quote = "'" | endif

fu! InvertString(str)
	" Courtesy of Preben Guldberg
	" This will invert/reverse a string
	let inverted = substitute(a:str, '.\(.*\)\@=',
	\ '\=a:str[strlen(submatch(1))]', 'g')

	return inverted
endfu

fu! ParseAngularDependencies()
	let line = getline(".")

	let start = match(line, g:_ad_exprregex)

	if start == -1
		echo "Couldn't parse angular dependencies from line"
		return []
	endif

	let end = matchend(line, g:_ad_exprregex)

	let args = []
	let place = match(line, g:_ad_fnregex, start)
	let place = matchend(line, 'function', place)

	let argstart = match(line, g:_ad_nameregex, place)
	while argstart != -1 && argstart < end
		let argend = matchend(line, g:_ad_nameregex, place)
		call add(args, strpart(line, argstart, argend - argstart))
		let place = argend
		let argstart = match(line, g:_ad_nameregex, place)
	endwhile

	return args
endfu

fu! ReplaceAngularDependencies(newcontent)
	call setline('.', substitute(getline('.'), g:_ad_exprregex, a:newcontent, ''))
endfu

fu! GenerateAngularDependencies(arglist)
	let generated = '['
	let quoted = []

	for an_arg in a:arglist
		call add(quoted, g:angular_dep_quote . an_arg . g:angular_dep_quote)
	endfor

	let generated = generated . join(quoted, ", ")

	if len(quoted)
		let generated = generated . ", "
	endif

	let generated = generated . "function("
	let generated = generated . join(a:arglist, ", ")
	let generated = generated . ")"

	return generated
endfu

fu! RegenerateAngularDependencies()
	call ReplaceAngularDependencies(GenerateAngularDependencies(ParseAngularDependencies()))
endfu

fu! OrderAngularDependencies()
	call ReplaceAngularDependencies(GenerateAngularDependencies(sort(ParseAngularDependencies())))
endfu

fu! AddAngularDependency()
	let deps = ParseAngularDependencies()
	let newdep = input('Enter Injectable Name: ')
	call add(deps, newdep)

	call ReplaceAngularDependencies(GenerateAngularDependencies(sort(deps)))
endfu

fu! RemoveAngularDependency()
	let deps = ParseAngularDependencies()
	let numbereddeps = ["Select a dependency to remove:"]
	let number = 1
	for dep in deps
		call add(numbereddeps, number . ' ' . dep)
		let number = number + 1
	endfor
	let selected = inputlist(numbereddeps)
	call remove(deps, selected - 1)
	call ReplaceAngularDependencies(GenerateAngularDependencies(sort(deps)))
endfu

map <silent> <Leader>adu :call RegenerateAngularDependencies()<CR>
map <silent> <Leader>ado :call OrderAngularDependencies()<CR>
map <silent> <Leader>ada :call AddAngularDependency()<CR>
map <silent> <Leader>adr :call RemoveAngularDependency()<CR>
map <silent> <Leader>adc i[<ESC><Leader>aduf{%a]<ESC>h%
