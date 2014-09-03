AngularDep.vim

![Examples](https://raw.githubusercontent.com/MichaelRFairhurst/angular-dep.vim/master/examples.gif "Examples")

Automatically update angular injection syntax with vim:

    ["out", "of", "date", "dependencies", function($brand, $new, dependencies, here) {
		...
	}]

Simply put your cursor anywhere on the first line, and type

	<Leader>adu

to have the line updated to

    ["$brand", "$new", "dependencies", "here", function($brand, $new, dependencies, here) {

Should preserve most if not all formatting in the line.

Other features:

    <Leader>ado - order dependencies alphabetically
    <Leader>ada - add a new dependency with a prompt for the name
    <Leader>adr - choose to remove a dependency from a list
    <Leader>adc - newly wrap a function with dependency declarations (put your cursor on the f in function)

distributed under the MIT license
