do ($=jQuery) ->
  if $.imageIndexer?
    return

  # @TODO 引数無しは Singleton で ImageIndexer オブジェクトを返す
  # @TODO $.imageIndexer('key') で名前付きオブジェクトを返す
  # @TODO $.imageIndexer.xxx() にショートカット登録
  $.imageIndexer = () ->
    null

  class ImageIndexer

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

    clip: (key, url, fullSize, clipPos, clipSize) =>

    upload: (key, url, fullSize) =>
      @clip(key, url, fullSize, [0, 0], fullSize.slice())

    partition: (key, url, fullSize, partSize, options={}) =>
      opts = _.extend({
        uploadPos: [0, 0]
        uploadSize: fullSize.slice()
      }, options)


#    /**
#     * 画像全体を一定幅で分割して索引リストとして登録する
#     *
#     * options.uploadPos: 分割開始位置の明示指定
#     * options.uploadSize: 分割対象サイズ指定
#     *
#     * 画像実サイズがfullSizeで、uploadSizeはその中の自動分割する領域
#     * 1画像に複数の規格の画像セットをまとめる際に必要になる
#     */
#    kls.prototype.upload = function(key, url, fullSize, partSize, options){
#        var opts = options || {};
#        var uploadPos = ('uploadPos' in opts)? opts.uploadPos: [0, 0];
#        var uploadSize = ('uploadSize' in opts)? opts.uploadSize: fullSize.slice();
#
#        if (this._has(key)) {
#            throw new Error('RPGMaterial:ImageIndexer.upload, already key=`' + key + '`');
#        };
#        if (uploadSize[0] % partSize[0] !== 0 || uploadSize[1] % partSize[1] !== 0) {
#            throw new Error('RPGMaterial:ImageIndexer.upload, can\'t be devided');
#        };
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
#    };
#
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
#    kls.prototype._has = function(key){
#        return key in this._data;
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
