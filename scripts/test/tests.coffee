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

  describe('Alone functions', ->
    it('_withinSize', ->
      parentSize = [50, 100]

      expect(
        ImageIndexer::_withinSize(parentSize, [0, 0], [50, 100])
      ).to.be.ok()

      expect(
        ImageIndexer::_withinSize(parentSize, [0, 0], [51, 100])
      ).to.not.be.ok()

      expect(
        ImageIndexer::_withinSize(parentSize, [0, 0], [50, 101])
      ).to.not.be.ok()

      expect(
        ImageIndexer::_withinSize(parentSize, [1, 0], [50, 99])
      ).to.be.ok()

      expect(
        ImageIndexer::_withinSize(parentSize, [0, 1], [49, 100])
      ).to.be.ok()

      expect(
        ImageIndexer::_withinSize(parentSize, [2, 0], [50, 99])
      ).to.not.be.ok()

      expect(
        ImageIndexer::_withinSize(parentSize, [0, 2], [49, 100])
      ).to.not.be.ok()
    )

    it('_isEqualDevidable', ->
      size = [64, 96]

      expect(
        ImageIndexer::_isEqualDevidable(size, [32, 32])
      ).to.be.ok()

      expect(
        ImageIndexer::_isEqualDevidable(size, [16, 16])
      ).to.be.ok()

      expect(
        ImageIndexer::_isEqualDevidable(size, [64, 96])
      ).to.be.ok()

      expect(
        ImageIndexer::_isEqualDevidable(size, [32, 33])
      ).to.not.be.ok()

      expect(
        ImageIndexer::_isEqualDevidable(size, [33, 32])
      ).to.not.be.ok()
    )
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
