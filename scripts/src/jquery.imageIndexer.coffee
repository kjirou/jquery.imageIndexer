do ($=jQuery) ->

  if $.imageIndexer?
    return


  $.imageIndexer = (instanceKey) ->
    ImageIndexer.getInstance(instanceKey)

  $.imageIndexer.getClass = ->
    ImageIndexer

  $.imageIndexer.version = '0.1.5'


  class ImageIndexer

    # Common Local Rules:
    # - A "position" is declared as [top, left].
    # - A "size" is declared as [width, height].

    @_instances = {}

    @getInstance = (instanceKey='default') ->
      if instanceKey of @_instances
        @_instances[instanceKey]
      else
        @_instances[instanceKey] = new ImageIndexer()

    @cleanInstances = ->
      @_instances = {}

    @InvalidArgsError = class InvalidArgsError extends Error
      constructor: (@message) ->
        @name = 'InvalidArgsError'
        super

    # If this class inherit InvalidArgsError,
    #   then @name returns 'InvalidArgsError'.
    @NotFoundImageKeyError = class NotFoundImageKeyError extends Error
      constructor: (@message) ->
        @name = 'NotFoundImageKeyError'
        super

    @DuplicatedImageKeyError = class DuplicatedImageKeyError extends Error
      constructor: (@message) ->
        @name = 'DuplicatedImageKeyError'
        super

    constructor: () ->
      @_images = {}

      @withPreloading = true

    clip: (imageKey, url, realSize, clipPos, clipSize, options={}) ->
      opts = $.extend({
        # true || false || null=Use @withPreloading
        withPreloading: null
      }, options)

      if @_hasImageData(imageKey)
        throw new DuplicatedImageKeyError "The imageKey=#{imageKey} already exists."

      if not @_withinSize realSize, clipPos, clipSize
        throw new InvalidArgsError(
          "Pos=[#{clipPos}] size=[#{clipSize}] is not within [#{realSize}].")

      if opts.withPreloading ? @withPreloading
        @_preload(url)

      @_images[imageKey] =
        type: 'clip'
        url: url
        realSize: realSize.slice()
        clipPos: clipPos.slice()
        clipSize: clipSize.slice()

    upload: (imageKey, url, realSize) ->
      @clip(imageKey, url, realSize, [0, 0], realSize.slice())

    partition: (imageKey, url, realSize, partSize, options={}) ->
      opts = $.extend({
        targetPos: [0, 0]
        targetSize: realSize.slice()
        withPreloading: null  # Ref "clip" method
      }, options)

      if @_hasImageData(imageKey)
        throw new DuplicatedImageKeyError "The imageKey=#{imageKey} already exists."

      pos = opts.targetPos.slice()
      size = opts.targetSize.slice()

      if not @_withinSize realSize, pos, size
        throw new InvalidArgsError "Pos=[#{pos}] size=[#{size}] is not within [#{realSize}]."

      if not @_isEqualDevidable size, partSize
        throw new InvalidArgsError "Size=[#{size}] can't be divide equally by [#{partSize}]."

      if opts.withPreloading ? @withPreloading
        @_preload(url)

      @_images[imageKey] =
        type: 'partition'
        url: url
        realSize: realSize
        partSize: partSize
        targetPos: pos
        targetSize: size

    _getImageData: (imageKey) ->
      @_images?[imageKey] ? null

    _hasImageData: (imageKey) ->
      @_getImageData(imageKey) isnt null

    _getImageDataOrError: (imageKey) ->
      @_getImageData(imageKey) ?
        throw new NotFoundImageKeyError "Not found image key=#{imageKey}."

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
      throw new InvalidArgsError "[#{args}] is invalid part-index."

    _partDataToPos: (partIndex, partSize, startPos=[0, 0]) ->
      [partSize[1] * partIndex[0] + startPos[0],
        partSize[0] * partIndex[1] + startPos[1]]

    asChip: (imageKey, argsForPartIndex...) ->
      data = @_getImageDataOrError imageKey

      if data.type is 'clip'
        $('<div>').css(
          width: data.clipSize[0]
          height: data.clipSize[1]
          overflow: 'hidden'
        ).append(
          $('<img>').css(
            display: 'block'
            position: 'relative'
            top: -data.clipPos[0]
            left: -data.clipPos[1]
            width: data.realSize[0]
            height: data.realSize[1]
          ).attr(
            src: data.url
          )
        )
      else if data.type is 'partition'
        partIndex = @_argsToPartIndex(
          argsForPartIndex, data.targetSize[0] / data.partSize[0])
        pos = @_partDataToPos partIndex, data.partSize, data.targetPos
        $('<div>').css(
          width: data.partSize[0]
          height: data.partSize[1]
          overflow: 'hidden'
        ).append(
          $('<img>').css(
            display: 'block'
            position: 'relative'
            top: -pos[0]
            left: -pos[1]
            width: data.realSize[0]
            height: data.realSize[1]
          ).attr(
            src: data.url
          )
        )

    asData: (imageKey) ->
      @_getImageData(imageKey)

