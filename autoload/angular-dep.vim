fu! InvertString(str)
	" Courtesy of Preben Guldberg
	" This will invert/reverse a string
	let inverted = substitute(a:str, '.\(.*\)\@=',
	\ '\=a:str[strlen(submatch(1))]', 'g')

	return inverted
endfu


fu! RegenerateAngularDependencies()
	let place = col(".") - 1
	let line = getline(".")
	while place < len(line) - 8 && strpart(line, place, 8) != "function"
		let place = place + 1
	endwhile

	if place >= len(line) - 8
		while place >= 0 && strpart(line, place, 8) != "function"
			let place = place - 1
		endwhile
	endif

	let argplace = matchend(line, '^function\s*(', place)
	if argplace == -1
		echo "Could not find injectable"
	else
		let injectables = []
		let matchargstart = match(line, '[a-zA-Z_$]\+', argplace)

		while argplace < len(line) && matchargstart != -1
			let matchargend = matchend(line, '[a-zA-Z_$]\+', argplace)
			call add(injectables, '"' . strpart(line, matchargstart, matchargend - matchargstart) . '"')
			let argplace = matchargend
			let matchargstart = match(line, '[a-zA-Z_$]\+', argplace)
		endwhile

		let newinjectables = join(injectables, ', ')

		let revprefix = InvertString(strpart(line, 0, place))
		let revnewinjectables = InvertString('[' . newinjectables . ', ')

		" Backwards regex to find the closest occurence of ['a', 'b', function(...
		let prefix = InvertString(substitute(revprefix, '^\(\s*,\?\s*\("[a-zA-Z_$]\+"\|''[a-zA-Z_$]\+''\)\)*\s*\[', revnewinjectables, ''))

		let newLine = prefix . strpart(line, place)

		call setline('.', newLine)
	endif

endfu

map <silent> <Leader>ad :call RegenerateAngularDependencies()<CR>
