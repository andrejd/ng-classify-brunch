ngClassify  = require 'ng-classify'
pathLib     = require 'path'
fs          = require 'fs'

###
  Wrapper for ng-classify node module
###
class NgClassifyBrunch

  brunchPlugin: yes
  type: 'javascript'
  extension: 'coffee'
  pattern: /\.(coffee(\.md)?|litcoffee)$/

  constructor: (@config) ->

    if 'package' of @config
        console.warn 'Warning: config.package is deprecated, please move it to config.plugins.package'

    @options = {}

    # Merge config
    cfg = @config.plugins?.ngclassify ? @config.ngclassify ? {}

    unless cfg instanceof Function
      @options[k] = cfg[k] for k of cfg
      @origAppName = @options.appName
      # check if valid path to modules Root path
      try
        if @options.modulesRoot?
          fs.openSync "./#{@options.modulesRoot}/", 'r'
      catch event
        @options.foldersToModules = false
        console.error "Error: Path in 'config.plugins.ngclassify.modulesRoot' is illegal, please enter valid path!"
    else
      @options = cfg




  #Handler executed on compilation
  compile: (data, path, callback) ->

    isFunction = @options instanceof Function

    str = data.toString 'utf8'

    if not isFunction and @options.foldersToModules
      modulesRoot = pathLib.normalize "./#{@options.modulesRoot}/"
      module = pathLib.relative(modulesRoot, path).split(pathLib.sep).filter (x)-> !/\.(coffee(\.md)?|litcoffee)$/.test x
      moduleName = module.join '.'
      @options.appName = moduleName || @origAppName
      #console.log "#{path} -> #{@options.appName}"

      txt = """

                `
                try {
                  angular.module('#{@options.appName || 'app'}');
                } catch (error) {
                  angular.module('#{@options.appName || 'app'}', []);
                }
                `

            """

      str = txt + str

    data = ''

    try
      data = ngClassify str, if isFunction then @options(path) else @options

    catch err
      error = err.toString()
      return callback error

    return callback null, data

module.exports = NgClassifyBrunch
