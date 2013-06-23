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

    it('_argsToPartIndex', ->
      pi = ImageIndexer::_argsToPartIndex([1, 2], 10)
      expect(pi).to.eql([1, 2])
      pi = ImageIndexer::_argsToPartIndex([[1, 2]], 10)
      expect(pi).to.eql([1, 2])
      pi = ImageIndexer::_argsToPartIndex([22], 10)
      expect(pi).to.eql([2, 1])
      expect(->
        ImageIndexer::_argsToPartIndex([])
      ).to.throwException((e) -> console.log e.message)
    )

    it('_partDataToPos', ->
      pos = ImageIndexer::_partDataToPos([2, 3], [20, 30], [1, 2])
      expect(pos[0]).to.be(30 * 2 + 1)
      expect(pos[1]).to.be(20 * 3 + 2)
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

  describe('image-key management', ->
    it('Check duplication', ->
      indexer = new ImageIndexer()
      indexer.upload('foo', 'http://notexists.kjirou.net/a.png', [16, 16])
      expect(->
        indexer.upload('foo', 'http://notexists.kjirou.net/a.png', [16, 16])
      ).to.throwException((e) -> console.log e.message)
      expect(->
        indexer.partition('foo', 'http://notexists.kjirou.net/a.png', [16, 16], [4, 4])
      ).to.throwException((e) -> console.log e.message)
    )
  )

  describe('A "clip" API', ->
    it('Normal actions don\'t throw error', ->
      indexer = new ImageIndexer()
      indexer.clip('icons', 'http://notexists.kjirou.net/icons.png',
        [512, 512], [96, 192], [24, 24])
    )

    it('Throw a error when clip size is not within image size', ->
      indexer = new ImageIndexer()

      indexer.clip('test', 'http://notexists.kjirou.net/a.png',
        [100, 200], [0, 0], [100, 200]) # Not error

      expect(->
        indexer.clip('test', 'http://notexists.kjirou.net/a.png',
          [100, 200], [0, 1], [100, 200])
      ).to.throwException((e) -> console.log e.message)
      expect(->
        indexer.clip('test', 'http://notexists.kjirou.net/a.png',
          [100, 200], [1, 0], [100, 200])
      ).to.throwException((e) -> console.log e.message)
      expect(->
        indexer.clip('test', 'http://notexists.kjirou.net/a.png',
          [200, 100], [2, 0], [199, 100])
      ).to.throwException((e) -> console.log e.message)
      expect(->
        indexer.clip('test', 'http://notexists.kjirou.net/a.png',
          [200, 100], [0, 2], [200, 99])
      ).to.throwException((e) -> console.log e.message)
    )
  )

  describe('A "partition" API', ->
    it('Normal actions don\'t throw error', ->
      indexer = new ImageIndexer()
      indexer.partition('icons', 'http://notexists.kjirou.net/icons.png',
        [512, 512], [32, 32])
      indexer.partition('faces', 'http://notexists.kjirou.net/faces.png',
        [192, 384], [96, 96])
      indexer.partition('complex', 'http://notexists.kjirou.net/complex.png',
        [500, 1000], [24, 12], { targetPos:[200, 50], targetSize:[96, 48] })
    )

    it('Throw a error when target size is not within image size', ->
      indexer = new ImageIndexer()
      expect(->
        indexer.partition('test', 'http://notexists.kjirou.net/test.png',
          [50, 50], [10, 10], { targetPos:[26, 0], targetSize:[25, 25] })
      ).to.throwException((e) -> console.log e.message)
      expect(->
        indexer.partition('test', 'http://notexists.kjirou.net/test.png',
          [50, 50], [10, 10], { targetPos:[0, 26], targetSize:[25, 25] })
      ).to.throwException((e) -> console.log e.message)
    )

    it('Throw a error when size can\'t be divided equally', ->
      indexer = new ImageIndexer()
      expect(->
        indexer.partition('test', 'http://notexists.kjirou.net/test.png',
          [50, 50], [26, 25])
      ).to.throwException((e) -> console.log e.message)
      expect(->
        indexer.partition('test', 'http://notexists.kjirou.net/test.png',
          [50, 50], [25, 26])
      ).to.throwException((e) -> console.log e.message)
    )
  )

  describe('A "asChip" API', ->
    it('Create a chip by clipped image data', ->
      indexer = new ImageIndexer()

      indexer.clip('girl', 'assets/images/sunayume.jp/my005B.png',
        [256, 256], [0, 0], [16, 16])
      indexer.clip('book', 'assets/images/sunayume.jp/my005B.png',
        [256, 256], [32, 16], [16, 16])

      $girl = indexer.asChip('girl')
      expect($girl).to.be.a(jQuery)
      $('#views').append($girl)

      $book = indexer.asChip('book')
      expect($book).to.be.a(jQuery)
      $('#views').append($book)
    )

    it('Create a chip by partitioned image data', ->
      indexer = new ImageIndexer()

      indexer.partition('icons16', 'assets/images/sunayume.jp/my005B.png',
        [256, 256], [16, 16])

      $girl = indexer.asChip('icons16', 0, 0)
      expect($girl).to.be.a(jQuery)
      $('#views').append($girl)

      $book = indexer.asChip('icons16', [2, 1])
      expect($book).to.be.a(jQuery)
      $('#views').append($book)

      $bow = indexer.asChip('icons16', 18)
      expect($bow).to.be.a(jQuery)
      $('#views').append($bow)
    )
  )
)
