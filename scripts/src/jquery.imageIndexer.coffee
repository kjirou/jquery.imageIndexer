do ($=jQuery) ->

  if $.imageIndexer?
    return


  $.imageIndexer = (instanceKey) ->
    ImageIndexer.getInstance(instanceKey)

  $.imageIndexer.getClass = ->
    ImageIndexer

  $.imageIndexer.version = '0.1.3'


  class ImageIndexer

    # Common Local Rules:
    # - "position" is declare by [top, left]
    # - "size" is  declare by [width, height]

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

      @withPreloading = true

    clip: (imageKey, url, fullSize, clipPos, clipSize, options={}) ->
      opts = $.extend({
        # true || false || null=Use @withPreloading
        withPreloading: null
      }, options)

      if @_hasImageData(imageKey)
        throw new Error "The imageKey=#{imageKey} already exists."

      if not @_withinSize fullSize, clipPos, clipSize
        throw new Error(
          "Pos=[#{clipPos}] size=[#{clipSize}] is not within [#{fullSize}].")

      if opts.withPreloading ? @withPreloading
        @_preload(url)

      @_images[imageKey] =
        type: 'clip'
        url: url
        fullSize: fullSize.slice()
        clipPos: clipPos.slice()
        clipSize: clipSize.slice()

    upload: (imageKey, url, fullSize) ->
      @clip(imageKey, url, fullSize, [0, 0], fullSize.slice())

    partition: (imageKey, url, fullSize, partSize, options={}) ->
      opts = $.extend({
        targetPos: [0, 0]
        targetSize: fullSize.slice()
        withPreloading: null  # Ref "clip" method
      }, options)

      if @_hasImageData(imageKey)
        throw new Error "The imageKey=#{imageKey} already exists."

      pos = opts.targetPos.slice()
      size = opts.targetSize.slice()

      if not @_withinSize fullSize, pos, size
        throw new Error "Pos=[#{pos}] size=[#{size}] is not within [#{fullSize}]."

      if not @_isEqualDevidable size, partSize
        throw new Error "Size=[#{size}] can't be divide equally by [#{partSize}]."

      if opts.withPreloading ? @withPreloading
        @_preload(url)

      @_images[imageKey] =
        type: 'partition'
        url: url
        fullSize: fullSize
        partSize: partSize
        targetPos: pos
        targetSize: size

    _getImageData: (imageKey) ->
      @_images?[imageKey] ? null

    _hasImageData: (imageKey) ->
      @_getImageData(imageKey) isnt null

    _getImageDataOrError: (imageKey) ->
      @_getImageData(imageKey) ?
        throw new Error "Not found image key=#{imageKey}."

    _preload: (imageUrl) ->
      (new Image()).src = imageUrl

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
        $('<div>').css(
          width: data.clipSize[0]
          height: data.clipSize[1]
          overflow: 'hidden'
        ).append(
          $('<img>').css(
            display: 'block'
            marginTop: -data.clipPos[0]
            marginLeft: -data.clipPos[1]
            width: data.fullSize[0]
            height: data.fullSize[1]
          ).attr(
            src: data.url
          )
        )
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

    asData: (imageKey) ->
      @_getImageData(imageKey)

