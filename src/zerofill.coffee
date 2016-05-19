module.exports = (number, targetLength, forceSign) ->
  absNumber = '' + Math.abs number
  zerosToFill = targetLength - absNumber.length
  sign = number >= 0
  (if sign then (if forceSign then '+' else '') else '-') \
  + Math.pow(10, Math.max(0, zerosToFill)).toString().substr(1) + absNumber
