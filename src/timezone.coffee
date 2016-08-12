## https://github.com/moment/moment-timezone/blob/develop/moment-timezone.js

moveInvalidForward   = true
moveAmbiguousForward = false

charCodeToInt = (charCode) ->
  if charCode > 96
    return charCode - 87
  else if charCode > 64
    return charCode - 29
  charCode - 48

unpackBase60 = (string) ->
  i = 0
  parts = string.split '.'
  whole = parts[0]
  fractional = parts[1] || ''
  multiplier = 1
  out = 0
  sign = 1
  #handle negative numbers
  if string.charCodeAt(0) is 45
    i = 1
    sign = -1
  #handle digits before the decimal
  for i in [i...whole.length]
    num = charCodeToInt whole.charCodeAt(i)
    out = 60 * out + num
  #handle digits after the decimal
  for i in [0...fractional.length]
    multiplier = multiplier / 60
    num = charCodeToInt(fractional.charCodeAt(i))
    out += num * multiplier
  out * sign

arrayToInt = (array) ->
  for i in [0...array.length]
    array[i] = unpackBase60 array[i]

intToUntil = (array, length) ->
  for i in [0...length]
    array[i] = Math.round((array[i - 1] || 0) + (array[i] * 60000))
  array[length - 1] = Infinity

mapIndices = (source, indices) ->
  out = []
  for i in [0...indices.length]
    out[i] = source[indices[i]]
  out

unpack = (string) ->
  data = string.split '|'
  offsets = data[2].split ' '
  indices = data[3].split ''
  untils  = data[4].split ' '

  arrayToInt offsets
  arrayToInt indices
  arrayToInt untils

  intToUntil untils, indices.length

  name       : data[0]
  abbrs      : mapIndices (data[1].split ' '), indices
  offsets    : mapIndices offsets, indices
  untils     : untils
  population : data[5] | 0

class Zone
  constructor: (packedString) ->
    @_set unpack(packedString) if packedString

  _set: (unpacked) ->
    @name = unpacked.name
    @abbrs = unpacked.abbrs
    @untils = unpacked.untils
    @offsets = unpacked.offsets
    @population = unpacked.population
  _index: (timestamp) ->
    target = +timestamp
    untils = @untils
    for i in [0...untils.length]
      return i if target < untils[i]
  abbr: (mom) ->
    @abbrs[@_index(mom)]
  offset: (mom) ->
    @offsets[@_index(mom)]

module.exports = Zone
