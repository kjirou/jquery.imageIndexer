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

  afterEach(->
    ImageIndexer.cleanInstances()
  )

  describe('Instances management', ->
    it('Create instance', ->
      ins = new ImageIndexer()
      expect(ins).to.be.a('object')
    )

    it('Create instance by getInstance', ->
      ins = ImageIndexer.getInstance()
      expect(ins).to.be.a('object')
      expect('default' of ImageIndexer._instances).to.be.ok()
    )

    it('Manage multi instances', ->
      a = ImageIndexer.getInstance('a')
      b = ImageIndexer.getInstance('b')
      expect(a).to.be.a('object')
      expect(b).to.be.a('object')
      expect(a isnt b).to.be.ok()
    )

    it('Singleton', ->
      s1 = ImageIndexer.getInstance('i_am_singleton')
      s2 = ImageIndexer.getInstance('i_am_singleton')
      expect(s1 is s2).to.be.ok()
    )
  )
)
