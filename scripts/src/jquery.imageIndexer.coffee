do ($=jQuery) ->

  if $.imageIndexer?
    return


  $.imageIndexer = (instanceKey) ->
    ImageIndexer.getInstance(instanceKey)

  $.imageIndexer.getClass = ->
    ImageIndexer


  class ImageIndexer

    # Common Local Rules:
    # - "position" is declare by [top, left]
    # - "size" is  declare by [width, height]

    # @TODO エラーの出し方を Coffeeを使って & モダンブラウザ限定で 洗練したい

    @_instances = {}

    @getInstance = (instanceKey='default') ->
      if instanceKey of @_instances
        @_instances[instanceKey]
      else
        @_instances[instanceKey] = new ImageIndexer()

    @cleanInstances = ->
      @_instances = {}

    constructor: () ->
      @_images = {}

    clip: (imageKey, url, fullSize, clipPos, clipSize) ->
      if @_hasImageData(imageKey)
        throw new Error("The imageKey=#{imageKey} already exists.")

    upload: (imageKey, url, fullSize) ->
      @clip(imageKey, url, fullSize, [0, 0], fullSize.slice())

    partition: (imageKey, url, fullSize, partSize, options={}) ->
      if @_hasImageData(imageKey)
        throw new Error "The imageKey=#{imageKey} already exists."

      opts = $.extend({
        targetPos: [0, 0]
        targetSize: fullSize.slice()
      }, options)

      pos = opts.targetPos.slice()
      size = opts.targetSize.slice()

      if not @_withinSize fullSize, pos, size
        throw new Error "Pos=[#{pos}] size=[#{size}] is not within [#{fullSize}]."

      if not @_isEqualDevidable size, partSize
        throw new Error "Size=[#{size}] can't be divide equally by [#{partSize}]."

      @_images[imageKey] =
        type: 'partition'
        url: url
        fullSize: fullSize
        partSize: partSize
        targetPos: pos
        targetSize: size

    alias: (aliasImageKey, imageKey, index...) ->
      null

    _getImageData: (imageKey) ->
      @_images?[imageKey] ? null

    _hasImageData: (imageKey) ->
      @_getImageData(imageKey) isnt null

    _getImageDataOrError: (imageKey) ->
      @_getImageData(imageKey) ?
        throw new Error "Not found image key=#{imageKey}."

    # @TODO
    _preLoad: (imageUrl) ->

    # Can a parent square contain a child square within itself?
    _withinSize: (parentSize, childPos, childSize) ->
      (parentSize[0] >= childPos[1] + childSize[0]) and
        (parentSize[1] >= childPos[0] + childSize[1])

    _isEqualDevidable: (size, partSize) ->
      (size[0] % partSize[0] is 0) and
        (size[1] % partSize[1] is 0)

    # Convert variable arguments to part-index.
    # *)That "part-index" is coord for partitioned image
    #   that is declared as [rowIndex(0-n), columnIndex(0-n)].
    _argsToPartIndex: (args, columnCount) ->
      if args.length is 2
        return [args[0], args[1]]
      else if args.length is 1
        if args[0] instanceof Array
          return [args[0][0], args[0][1]]
        else if typeof args[0] is 'number' and args[0] >= 1
          seq = args[0] - 1  # 1 start(by user input) to 0 start
          return [parseInt(seq / columnCount, 10), seq % columnCount]
      throw new Error "[#{args}] is invalid part-index."

    _partDataToPos: (partIndex, partSize, startPos=[0, 0]) ->
      [partSize[1] * partIndex[0] + startPos[0],
        partSize[0] * partIndex[1] + startPos[1]]

    asChip: (imageKey, index...) ->
      data = @_getImageDataOrError imageKey

      if data.type is 'clip'
        null
      else if data.type is 'partition'
        partIndex = @_argsToPartIndex(
          index, data.targetSize[0] / data.partSize[0])
        pos = @_partDataToPos partIndex, data.partSize, data.targetPos
        $('<div>').css(
          width: data.partSize[0]
          height: data.partSize[1]
          overflow: 'hidden'
        ).append(
          $('<img>').css(
            display: 'block'
            marginTop: -pos[0]
            marginLeft: -pos[1]
            width: data.fullSize[0]
            height: data.fullSize[1]
          ).attr(
            src: data.url
          )
        )
      else if data.type is 'alias'
        null

    asData: (imageKey) ->
      @_getImageData(imageKey)

#    /** 画像の一部をくり抜いて、ひとつの索引を登録する */
#    kls.prototype.clip = function(key, url, fullSize, clipPos, clipSize){
#        if (this._has(key)) {
#            throw new Error('RPGMaterial:ImageIndexer.clip, already key=`' + key + '`');
#        };
#        if (arguments.length < 5) {// upload と間違えそう
#            throw new Error('RPGMaterial:ImageIndexer.clip, not enough arguments=`' + arguments + '`');
#        };
#        if (fullSize[0] < clipPos[1] + clipSize[0] || fullSize[1] < clipPos[0] + clipSize[1]) {
#            throw new Error('RPGMaterial:ImageIndexer.clip, too small image');
#        };
#        this._data[key] = {
#            type: 'clip',
#            url: url,
#            fullSize: fullSize,
#            partSize: null,
#            uploadPos: null,
#            uploadSize: null,
#            clipPos: clipPos,
#            clipSize: clipSize
#        };
#    };
