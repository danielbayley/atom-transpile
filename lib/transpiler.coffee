{CompositeDisposable} = require 'atom'
{readFileSync, writeFile, unlink} = require 'fs'

module.exports =
class Transpiler
	subs: new CompositeDisposable

	package: require '../package.json'
	#config: -> atom.config.get @package.name
	options:
		select: true
		autoIndent: true
		autoIndentNewline: true
		autoDecreaseIndent: true

#-------------------------------------------------------------------------------

	constructor: (@plugin) ->
		name = @plugin.name.replace 'transpile-','' #.split( /-([a-z-]+)/ )[1]
		command = "transpile:#{name}"

		{scopeName, fileTypes} = @plugin.from
		selector = scopeName?.replace /\./g,' '
		context = ["atom-text-editor:not([mini])[data-grammar^='#{selector}']"]

		#@subs.add atom.grammars.onDidAddGrammar (grammar) =>
			#if grammar.scopeName == scopeName
				# {fileTypes} = atom.grammars.grammarForScopeName scopeName
				#@fileTypes = fileTypes#.filter (ext) -> //.test ext
		unless fileTypes? # FIXME
			try {fileTypes} = atom.grammars.grammarForScopeName scopeName
		#fileTypes = [fileTypes] unless Array.isArray fileTypes
		for selector in fileTypes #? []

			unless selector.startsWith '['
				selector = selector.replace /^([.\w]+)/,'$="$1"'
				selector = "[data-name#{selector}]"

			context.push ".tree-view .file #{selector}"

		@subs.add atom.commands.add context.join(),
			command, ({target}) => @transpile target?.dataset.path

		submenu = [
			label: "Transpile"
			submenu: [
				label: name #name[0].toUpperCase() + name[1..-1]
				command: command
		]	]
		@subs.add atom.menu.add [
			label: "Packages"
			submenu: submenu
		]
		menu = {}
		menu[context] = submenu
		@subs.add atom.contextMenu.add menu

#-------------------------------------------------------------------------------
	transpile: (file) ->
		{scopeName, ext} = @plugin.to
		# {scopeName} = atom.grammars.selectGrammar ext
		grammar = atom.grammars.grammarForScopeName scopeName
		try
			if file?
				{softTabs, tabLength} = atom.config.get 'editor', scope: [scopeName]
				indent =
					if softTabs ? true
						' '.repeat tabLength ? 2
					else '\t'

				source = readFileSync file,'utf8'
				code = @plugin.transpile source, indent

				unlink file if atom.config.get "#{@package.name}.replace"

				ext = ext?.replace '.',''
				ext ?= grammar.fileTypes[0]

				writeFile "#{file.split('.')[0]}.#{ext}", code
			else
				editor = atom.workspace.getActiveTextEditor()
				indent = editor.getTabText()

				unless editor.getSelectedText()

					source = editor.buffer.getText()
					editor.setText @plugin.transpile source, indent, editor
					editor.setGrammar grammar
				else
					for selection in editor.getSelections()
						#unless selection.isEmpty()
						code = @plugin.transpile selection.getText(), indent, editor
						selection.insertText code, @options
		catch err
			atom.notifications.addError @plugin.name, detail: err

#-------------------------------------------------------------------------------
	deactivate: -> @subs.dispose()
