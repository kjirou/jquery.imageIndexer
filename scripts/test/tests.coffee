# @TODO これを全テストファイルの頭に付けたくない
# In console
if 'undefined' isnt typeof require
  expect = require 'expect.js'
# In browser
else
  expect = @expect


describe('初期化', ->
  it('$.imageIndexer が定義されている', ->
    expect($.imageIndexer).to.be.a('function')
  )
)

describe('画像読み込み', ->
  it('画像を取得できる', ->
  )
)
