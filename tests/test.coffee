assert = require('chai').assert;
zeroFill = require '../src/zerofill'
moment = require '../src/index'

concatedString = (date) -> date.getFullYear().toString() + (date.getMonth()+1) \
+ date.getDate() + date.getHours() + date.getMinutes() + date.getSeconds() \
+ zeroFill date.getMilliseconds(), 3

concatedStringFormat = "YMDHmsSSS"
ISOFormat = "YYYY-MM-DDTHH:mm:ss.SSS\\Z"
samplesFormat = "MM/DD/YYYY HH:mm:ss.SSS Z"

tzs =
  UTC:
    # value from https://github.com/moment/moment-timezone/blob/develop/data/packed/latest.json
    string: "Etc/UTC|UTC|0|0|"
    tests: [
      ( time: 1413687600000, result: '10/19/2014 03:00:00.000 +00:00' )
    ]
  BRT:
    # value from https://github.com/moment/moment-timezone/blob/develop/data/packed/latest.json
    string: "America/Sao_Paulo|LMT BRT BRST|36.s 30 20|012121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212|-2glwR.w HdKR.w 1cc0 1e10 1bX0 Ezd0 So0 1vA0 Mn0 1BB0 ML0 1BB0 zX0 pTd0 PX0 2ep0 nz0 1C10 zX0 1C10 LX0 1C10 Mn0 H210 Rb0 1tB0 IL0 1Fd0 FX0 1EN0 FX0 1HB0 Lz0 1EN0 Lz0 1C10 IL0 1HB0 Db0 1HB0 On0 1zd0 On0 1zd0 Lz0 1zd0 Rb0 1wN0 Wn0 1tB0 Rb0 1tB0 WL0 1tB0 Rb0 1zd0 On0 1HB0 FX0 1C10 Lz0 1Ip0 HX0 1zd0 On0 1HB0 IL0 1wp0 On0 1C10 Lz0 1C10 On0 1zd0 On0 1zd0 Rb0 1zd0 Lz0 1C10 Lz0 1C10 On0 1zd0 On0 1zd0 On0 1zd0 On0 1C10 Lz0 1C10 Lz0 1C10 On0 1zd0 On0 1zd0 Rb0 1wp0 On0 1C10 Lz0 1C10 On0 1zd0 On0 1zd0 On0 1zd0 On0 1C10 Lz0 1C10 Lz0 1C10 Lz0 1C10 On0 1zd0 Rb0 1wp0 On0 1C10 Lz0 1C10 On0 1zd0|20e6"
    tests: [
      # Testing values around Daylight saving boundary
      ( time: 1413687600000, result: '10/19/2014 01:00:00.000 -02:00' )
      ( time: 1413687600000 - 3600000, result: '10/18/2014 23:00:00.000 -03:00' )
      ( time: 1413687600000 + 3600000, result: '10/19/2014 02:00:00.000 -02:00' )
    ]

describe 'Equal', ->
  it 'Concatenated strings verification for random values without timezone', ->
    for i in [0..20]
      date = new Date (Date.now() * Math.random())
      assert.equal (moment.format date, concatedStringFormat), concatedString date, date.toString()

  it 'ISO string verification for random values', ->
    timezone = new moment.Timezone tzs.UTC.string
    for i in [0..20]
        date = new Date (Date.now() * Math.random())
        assert.equal (moment.format date, ISOFormat, timezone), date.toISOString(), date.toString()

  it 'samples tests for different timezones', ->
    for code, data of tzs
      timezone = new moment.Timezone data.string
      for test in data.tests
        date = new Date(test.time)
        assert.equal (moment.format date, samplesFormat, timezone), test.result, "#{code} #{date.toString()}"
