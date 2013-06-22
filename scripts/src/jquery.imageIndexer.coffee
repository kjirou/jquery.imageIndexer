do ($=jQuery) ->

  if $.imageIndexer?
    return


  $.imageIndexer = (instanceKey) ->
    ImageIndexer.getInstance(instanceKey)

  $.imageIndexer._addShortcut = (methodName) ->
    @[methodName] = () ->
      ins = ImageIndexer.getInstance()
      ins[methodName].apply(ins, arguments)

  $.imageIndexer._addShortcut('clip')
  $.imageIndexer._addShortcut('upload')
  $.imageIndexer._addShortcut('partition')

  $.imageIndexer.getClass = () ->
    ImageIndexer


  class ImageIndexer

    # @TODO エラーの出し方を Coffeeを使って & モダンブラウザ限定で 洗練したい

    @_instances = {}

    @getInstance = (instanceKey='default') ->
      if instanceKey of @_instances
        @_instances[instanceKey]
      else
        @_instances[instanceKey] = new ImageIndexer()

    constructor: () ->
  #      '<任意のキー>': {
  #          type: '<upload||clip>',
  #          url: '<URL>',
  #          fullSize: [width, height],
  #          // upload 時必須, clip時不要
  #          partSize: [width, height],
  #          // upload 時オプション, clip時は不要
  #          uploadPos: [top, left],
  #          uploadSize: [width, height],
  #          // clip 時必須, upload時は自動設定
  #          clipPos: [top, left],
  #          clipSize: [width, height],
      @_images = {}

    clip: (imageKey, url, fullSize, clipPos, clipSize) ->
      if @_hasImageData(imageKey)
        throw new Error("The imageKey=#{imageKey} already exists.")

    upload: (imageKey, url, fullSize) ->
      @clip(imageKey, url, fullSize, [0, 0], fullSize.slice())

    partition: (imageKey, url, fullSize, partSize, options={}) ->
      if @_hasImageData(imageKey)
        throw new Error("The imageKey=#{imageKey} already exists.")

      opts = _.extend({
        targetPos: [0, 0]
        targetSize: fullSize.slice()
      }, options)

      pos = opts.targetPos.slice()
      size = opts.targetSize.slice()

#        if (uploadSize[0] % partSize[0] !== 0 || uploadSize[1] % partSize[1] !== 0) {
#            throw new Error('RPGMaterial:ImageIndexer.upload, can\'t be devided');
#        };

      if not @_isFullSize内に収まっている()
        null

      if not @_isSizeがpartSizeで割り切れる()
        null

      @_images[imageKey] = {
      }
#        this._data[key] = {
#            type: 'upload',
#            url: url,
#            fullSize: fullSize,
#            partSize: partSize,
#            uploadPos: uploadPos,
#            uploadSize: uploadSize,
#            clipPos: [0, 0],
#            clipSize: fullSize.slice()
#        };
#

    _getImageData: (imageKey) ->
      @_images?[imageKey] ? null

    _hasImageData: (imageKey) ->
      @_getImage(imageKey) isnt null

    _withinSize: (parentSize, pos, size) ->

    asChip: (imageKey, indexInfo...) ->

    setAlias: (aliasImageKey, imageKey, indexInfo...) ->

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
#
#    /** idx num=連番指定 || arr=行,列指定 || (undefined or null)=指定無し */
#    kls.prototype._get = function(key, idx){
#        if (this._has(key) === false) {
#            throw new Error('RPGMaterial:ImageIndexer._get, not defined key=`' + key + '`');
#        };
#        var dat = this._data[key];
#        if (dat.type === 'clip' && idx !== undefined && idx !== null) {// 'clip'はidx指定不可
#            throw new Error('RPGMaterial:ImageIndexer._get, clipped image is not selectable idx, key=`' + key + '`');
#        };
#        var pos, size;
#        // 連番で指定, 1スタート
#        // ex) 1234
#        //     56..
#        if (typeof idx === 'number') {
#            var columnCount = dat.uploadSize[0] / dat.partSize[0];
#            var rowCount = parseInt((idx - 1) / columnCount);
#            pos = [
#                rowCount * dat.partSize[1] + dat.uploadPos[0],
#                ((idx - 1) % columnCount) * dat.partSize[0] + dat.uploadPos[1]
#            ];
#            size = dat.partSize;
#        // [行,列] で指定
#        // ex) [0,0][0,1][0,2] ..
#        //     [1,0][1,0][1,2] ..
#        } else if (idx instanceof Array) {
#            pos = [
#                idx[0] * dat.partSize[1] + dat.uploadPos[0],
#                idx[1] * dat.partSize[0] + dat.uploadPos[1]
#            ];
#            size = dat.partSize;
#        // 指定無し, 唯一の画像を取得, type=uplold の場合は全画像取得
#        } else {
#            pos = dat.clipPos;
#            size = dat.clipSize;
#        };
#        if (dat.fullSize[0] < pos[1] + size[0] || dat.fullSize[1] < pos[0] + size[1]) {
#            throw new Error('RPGMaterial:ImageIndexer._get, bad image index=`' + idx + '`');
#        };
#        return {
#            url: dat.url,
#            fullSize: dat.fullSize,
#            clipPos: pos,
#            clipSize: size
#        };
#    };
#
#    /** データを受け取る
#        'normal'チップならば、そのままvariationへ登録可能 */
#    kls.prototype.get = function(key, idx){
#        return this._get.apply(this, arguments);
#    };
#
#    kls.prototype.getUrl = function(key){
#        return this._get(key).url;
#    };
#
#    kls.prototype.getUrlForBackground = function(key){
#        return 'url(' + this._get(key).url + ')';
#    };
#
#    /** データをチップ化して受け取る
#        @param resizing arr=その[サイズ]にリサイズ, default=しない */
#    kls.prototype.asChip = function(key, idx, resizing){
#        var dat = this._get(key, idx);
#        var size;
#        if (resizing instanceof Array) {
#            size = resizing;
#            dat.type = 'resize';
#        } else {
#            size = dat.clipSize;
#            delete dat.clipSize;
#        };
#        return cls.$chips.PlainChip.factory(size, null, dat);
#    };
#
#    /** データを非オートタイルとして受け取る
#        64x96規格のみ対応で、最左上の32x32をチップとして返す */
#    kls.prototype.asTile = function(key, idx){
#        var dat = this._get(key, idx);
#        if (dat.clipSize[0] !== 64 || dat.clipSize[1] !== 96) {
#            throw new Error('RPGMaterial:ImageIndexer.asTile, image size is not 64x96');
#        };
#        delete dat.clipSize;
#        return cls.$chips.PlainChip.factory([32, 32], null, dat);
#    };
#
#    /** データを非オートタイルとして受け取る, 64x96規格のみ対応 */
#    kls.prototype.asAutoTile = function(key, idx){
#        var dat = this._get(key, idx);
#        if (dat.clipSize[0] !== 64 || dat.clipSize[1] !== 96) {
#            throw new Error('RPGMaterial:ImageIndexer.asAutoTile, image size is not 64x96');
#        };
#        delete dat.clipSize;
#        dat.type = 'auto_tiling';
#        return cls.$chips.PlainChip.factory([32, 32], null, dat);
#    };
#
#    kls.factory = function(){
#        var obj = new this();
#        return obj;
#    };
#
#    return kls;
#})();
