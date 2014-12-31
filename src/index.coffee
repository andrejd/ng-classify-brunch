ngClassify = require 'ng-classify'

###
  Wrapper for ng-classify node module
###
class NgClassifyBrunch

  brunchPlugin: yes
  type = 'javascript';
  extension = 'coffee';
  pattern = /\.(coffee(\.md)?|litcoffee)$/;

  constructor: (@config) ->

    if 'package' of @config
        console.warn 'Warning: config.package is deprecated, please move it to config.plugins.package'

    # Merge config
    cfg = @config.plugins?.ngclassify ? @config.ngclassify ? {}
    @options[k] = cfg[k] for k of cfg

  #Handler executed on compilation
  compile: (data, path, callback) ->

    str = data.toString 'utf8'
    data = ''

    try
      data = ngClassify str, options
    catch err
      error = err.toString()
      return callback error

    return callback null, data

module.exports = NgClassifyBrunch
