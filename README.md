[![apm]](https://atom.io/packages/transpile)

Transpile code in [Atom]
========================
Easily [transpile] code between languages within [Atom] in a standard way.

Transpile selected blocks of code in the editor, or else the current _[buffer]_, in which case the appropriate _target [grammar]_ will automatically be applied on success.

Relevant files can also be converted directly in Tree view, but will transpile to a new adjacent file by default.

Transpiler commands are context aware to prevent unnecessary menu clutter, and are grouped into a single _Transpile_ submenu.

Plugins
-----------------------------------------------------------------------
| Plugin                              |     From     |       To       |
|:------------------------------------|:------------:|:--------------:|
| [transpile-][-js2coffee][js2coffee] |  JavaScript  | [CoffeeScript] |
| [transpile-][-decaf][decaf]         | CoffeeScript |   JavaScript   |
| [transpile-][-lebab][lebab]         |     ES5      |   [ES6]/2015   |
| [transpile-][-cson][cson]           | [CSON]/JSON  |   JSON/CSON    |
| [transpile-][-pug][pug]             |     HTML     |     [Pug]      |

API
---
Creating a plugin is as simple as possible. See the base example below, or the multiple [existing packages] for examples of how to implement your own.

~~~ js
// package.json
"providedServices": {
  "transpile": {
    "versions": {
      "1.0.0": "activate"
    }
  }
},
~~~
This provides your transpiler as a _[service]_ for _this_ base package to build on.

~~~ coffee
# index.coffee
module.exports =
  activate: ->
    name: 'transpile-plugin'
    from:
      scopeName: 'source.coffee'
      fileTypes: ['.coffee','[data-name*=coffee]','Cakefile']
    to:
      scopeName: 'source.js'
      ext: '.js' # Optional

    transpile: (source) => #, indent, editor)
      {transpile} = require 'transpiler'
      transpile source #, { options: indent }
~~~
Notice that the `from.fileTypes` `[array]` can contain either file `.ext`ensions, complete file names, or a valid _CSS [attribute selector]_.

Your `transpile:` _method_ should simply **return the transpiled code**, and will be supplied with the `source` code, along with the following [optional] arguments:
* An `indent`ation `'string'` provided as a potential option to pass on to the underlying transpiler, since formatting should be preserved if possible.
* The current [Text`editor`] `{object}` instance.

Multiple transpilers can also be bundled in the same package; _[transpile-decaf]_ for example [provides a choice] between _[decaf]_ or _[decaffeinate]_, whereas _[transpile-cson]_ can transpile between both _[CSON] and_ JSON.

Install
-------
`apm install transpile` or search “transpile” under Packages within Atom.

License
-------
[MIT] © [Daniel Bayley]

[MIT]:											LICENSE.md
[Daniel Bayley]:						https://github.com/danielbayley
[atom]:											https://atom.io
[apm]:											https://img.shields.io/apm/v/transpile.svg?style=flat-square

[existing packages]:				https://atom.io/packages/search?q=transpile-
[transpile]:								https://en.wikipedia.org/wiki/Source-to-source_compiler
[-js2coffee]:								https://atom.io/packages/transpile-js2coffee
[-decaf]:					          https://atom.io/packages/transpile-decaf
[-lebab]:										https://atom.io/packages/transpile-lebab
[-cson]:										https://atom.io/packages/transpile-cson
[-pug]:											https://atom.io/packages/transpile-pug

[js2coffee]:								http://js2.coffee
[coffeescript]:							http://coffeescript.org
[decaf]:										https://github.com/rainforestapp/decaf#decaf-js
[decaffeinate]:							https://github.com/decaffeinate/decaffeinate#decaffeinate-
[lebab]:										http://lebab.io
[ES6]:											http://babeljs.io/#es2015
[CSON]:											https://github.com/bevry/cson#what-is-cson
[pug]:											https://github.com/pugjs/pug

[service]:									http://flight-manual.atom.io/behind-atom/sections/interacting-with-other-packages-via-services
[grammar]:									http://flight-manual.atom.io/using-atom/sections/grammar
[buffer]:										http://flight-manual.atom.io/getting-started/sections/atom-basics/#basic-terminology
[Text`editor`]:							https://atom.io/docs/api/latest/TextEditor
[attribute selector]:				https://css-tricks.com/almanac/selectors/a/attribute
[transpile-decaf]:					https://github.com/danielbayley/atom-transpile-decaf/blob/master/index.coffee#L14-L22
[provides a choice]:				https://github.com/danielbayley/atom-transpile-decaf/blob/master/package.json#L40-L50
[transpile-cson]:						https://github.com/cazala/atom-transpile-cson/blob/master/lib/index.coffee
