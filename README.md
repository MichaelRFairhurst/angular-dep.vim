AngularDep.vim

Automatically update angular injection syntax with vim:

    ["out", "of", "date", "dependencies", function($brand, $new, dependencies, here) {
		...
	}]

Simply put your cursor anywhere on the first line, and type

	<Leader>ad

to have the line updated to

    ["$brand", "$new", "dependencies", "here", function($brand, $new, dependencies, here) {

Should preserve most if not all formatting in the line.


distributed under the MIT license
