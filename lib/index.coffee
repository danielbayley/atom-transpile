{Disposable} = require 'atom'
Transpiler = require './transpiler'

module.exports =
	#activate: ->

	transpiler: (plugins) ->
		plugins = [plugins] unless Array.isArray plugins
		for plugin in plugins
			new Transpiler plugin
			new Disposable -> stopUsingService plugin
