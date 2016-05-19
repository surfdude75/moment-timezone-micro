# coffeelint: disable=max_line_length
zeroFill = require './zerofill'

formattingTokens = /(\[[^\[]*\])|(\\)?([Hh]mm(ss)?|MM?M?M?|DD?|d|YYYYYY|YYYYY|YYYY|YY|hh?|HH?|kk?|mm?|ss?|S{1,3}|ZZ?|.)/g

formatTokenFunctions = {}
formatFunctions = {}

removeFormattingTokens = (input) ->
  if input.match /\[[\s\S]/
    return input.replace /^\[|\]$/g, ''
  input.replace /\\/g, ''

makeFormatFunction = (format) ->
  array = format.match formattingTokens
  length = array.length
  for i in [0...length]
    if formatTokenFunctions[array[i]]
      array[i] = formatTokenFunctions[array[i]]
    else
      array[i] = removeFormattingTokens array[i]
  (mom) ->
    output = ''
    for i in [0...length]
      output += if array[i] instanceof Function then array[i].call(mom, format) else array[i]
    output

###
  token:    'M'
  padded:   ['MM', 2]
  callback: function () { this.month() + 1 }
###
addFormatToken = (token, padded, callback) ->
  func = callback
  if token
    formatTokenFunctions[token] = func
  if padded
    formatTokenFunctions[padded[0]] = ->
      zeroFill func.apply(this, arguments), padded[1], padded[2]

# format date using native date object
format = (date, format, timezone) ->
  offset = date.getTimezoneOffset()
  offset = (timezone.offset date) if timezone
  date2 = new Date(date.getTime()-offset*60000)
  date2.offset = offset
  formatFunctions[format] = formatFunctions[format] || makeFormatFunction(format)
  formatFunctions[format](date2)

addFormatToken 'S', 0, -> @getUTCMilliseconds() // 100
addFormatToken 0, ['SS', 2], -> @getUTCMilliseconds() // 10
addFormatToken 0, ['SSS', 3], -> @getUTCMilliseconds()
addFormatToken 's', ['ss', 2], -> @getUTCSeconds()
addFormatToken 'm', ['mm', 2], -> @getUTCMinutes()
hFormat = -> @getUTCHours() % 12 || 12
kFormat = -> @getUTCHours() || 24
addFormatToken 'H', ['HH', 2], -> @getUTCHours()
addFormatToken 'h', ['hh', 2], hFormat
addFormatToken 'k', ['kk', 2], kFormat
addFormatToken 'hmm', 0, -> '' + hFormat.apply @ + zeroFill @getUTCMinutes(), 2
addFormatToken 'hmmss', 0, ->
  '' + hFormat.apply @ + zeroFill @getUTCMinutes(), 2  + zeroFill @getUTCSeconds(), 2
addFormatToken 'Hmm', 0, -> '' + @getUTCHours() + zeroFill @getUTCMinutes(), 2
addFormatToken 'Hmmss', 0, ->
  '' + @getUTCHours() + zeroFill @getUTCMinutes(), 2 + zeroFill @getUTCSeconds(), 2
addFormatToken 'D', ['DD', 2], -> @getUTCDate()
addFormatToken 'Y', 0, -> @getUTCFullYear()
addFormatToken 0, ['YY', 2], -> @getUTCFullYear() % 100
addFormatToken 0, ['YYYY',   4], -> @getUTCFullYear()
addFormatToken 0, ['YYYYY',  5], -> @getUTCFullYear()
addFormatToken 0, ['YYYYYY', 6, true], -> @getUTCFullYear()
addFormatToken 'd', 0, -> @getUTCDay()
addFormatToken 'M', ['MM', 2], -> @getUTCMonth() + 1

offset =  (token, separator) ->
  addFormatToken token, 0, ->
    offset = -@offset
    sign = '+'
    if offset < 0
      offset = -offset
      sign = '-'
    sign + (zeroFill offset // 60, 2) + separator + (zeroFill offset % 60, 2)

offset 'Z', ':'
offset 'ZZ', ''

module.exports = format

