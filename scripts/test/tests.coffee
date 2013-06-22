# @TODO これを全テストファイルの頭に付けたくない
# In console
if 'undefined' isnt typeof require
  expect = require 'expect.js'
# In browser
else
  expect = @expect


describe('API definitions', ->
  it('$.imageIndexer', ->
    expect($.imageIndexer).to.be.a('function')
  )

  it('Shortcuts', ->
    expect($.imageIndexer.clip).to.be.a('function')
    expect($.imageIndexer.upload).to.be.a('function')
    expect($.imageIndexer.partition).to.be.a('function')
  )

  it('getClass', ->
    ImageIndexer = $.imageIndexer.getClass()
    expect(ImageIndexer).to.be.a('function')
  )
)


describe('ImageIndexer class', ->
  ImageIndexer = $.imageIndexer.getClass()

  it('Create instance', ->
    ins = new ImageIndexer()
    expect(ins).to.be.a('object')
  )
)
