(function() {
  var __slice = [].slice;

  (function($) {
    var ImageIndexer;
    if ($.imageIndexer != null) {
      return;
    }
    $.imageIndexer = function(instanceKey) {
      return ImageIndexer.getInstance(instanceKey);
    };
    $.imageIndexer.getClass = function() {
      return ImageIndexer;
    };
    $.imageIndexer.version = '0.1.3';
    return ImageIndexer = (function() {
      ImageIndexer._instances = {};

      ImageIndexer.getInstance = function(instanceKey) {
        if (instanceKey == null) {
          instanceKey = 'default';
        }
        if (instanceKey in this._instances) {
          return this._instances[instanceKey];
        } else {
          return this._instances[instanceKey] = new ImageIndexer();
        }
      };

      ImageIndexer.cleanInstances = function() {
        return this._instances = {};
      };

      function ImageIndexer() {
        this._images = {};
        this.withPreloading = true;
      }

      ImageIndexer.prototype.clip = function(imageKey, url, fullSize, clipPos, clipSize, options) {
        var opts, _ref;
        if (options == null) {
          options = {};
        }
        opts = $.extend({
          withPreloading: null
        }, options);
        if (this._hasImageData(imageKey)) {
          throw new Error("The imageKey=" + imageKey + " already exists.");
        }
        if (!this._withinSize(fullSize, clipPos, clipSize)) {
          throw new Error("Pos=[" + clipPos + "] size=[" + clipSize + "] is not within [" + fullSize + "].");
        }
        if ((_ref = opts.withPreloading) != null ? _ref : this.withPreloading) {
          this._preload(url);
        }
        return this._images[imageKey] = {
          type: 'clip',
          url: url,
          fullSize: fullSize.slice(),
          clipPos: clipPos.slice(),
          clipSize: clipSize.slice()
        };
      };

      ImageIndexer.prototype.upload = function(imageKey, url, fullSize) {
        return this.clip(imageKey, url, fullSize, [0, 0], fullSize.slice());
      };

      ImageIndexer.prototype.partition = function(imageKey, url, fullSize, partSize, options) {
        var opts, pos, size, _ref;
        if (options == null) {
          options = {};
        }
        opts = $.extend({
          targetPos: [0, 0],
          targetSize: fullSize.slice(),
          withPreloading: null
        }, options);
        if (this._hasImageData(imageKey)) {
          throw new Error("The imageKey=" + imageKey + " already exists.");
        }
        pos = opts.targetPos.slice();
        size = opts.targetSize.slice();
        if (!this._withinSize(fullSize, pos, size)) {
          throw new Error("Pos=[" + pos + "] size=[" + size + "] is not within [" + fullSize + "].");
        }
        if (!this._isEqualDevidable(size, partSize)) {
          throw new Error("Size=[" + size + "] can't be divide equally by [" + partSize + "].");
        }
        if ((_ref = opts.withPreloading) != null ? _ref : this.withPreloading) {
          this._preload(url);
        }
        return this._images[imageKey] = {
          type: 'partition',
          url: url,
          fullSize: fullSize,
          partSize: partSize,
          targetPos: pos,
          targetSize: size
        };
      };

      ImageIndexer.prototype._getImageData = function(imageKey) {
        var _ref, _ref1;
        return (_ref = (_ref1 = this._images) != null ? _ref1[imageKey] : void 0) != null ? _ref : null;
      };

      ImageIndexer.prototype._hasImageData = function(imageKey) {
        return this._getImageData(imageKey) !== null;
      };

      ImageIndexer.prototype._getImageDataOrError = function(imageKey) {
        var _ref;
        return (function() {
          if ((_ref = this._getImageData(imageKey)) != null) {
            return _ref;
          } else {
            throw new Error("Not found image key=" + imageKey + ".");
          }
        }).call(this);
      };

      ImageIndexer.prototype._preload = function(imageUrl) {
        return (new Image()).src = imageUrl;
      };

      ImageIndexer.prototype._withinSize = function(parentSize, childPos, childSize) {
        return (parentSize[0] >= childPos[1] + childSize[0]) && (parentSize[1] >= childPos[0] + childSize[1]);
      };

      ImageIndexer.prototype._isEqualDevidable = function(size, partSize) {
        return (size[0] % partSize[0] === 0) && (size[1] % partSize[1] === 0);
      };

      ImageIndexer.prototype._argsToPartIndex = function(args, columnCount) {
        var seq;
        if (args.length === 2) {
          return [args[0], args[1]];
        } else if (args.length === 1) {
          if (args[0] instanceof Array) {
            return [args[0][0], args[0][1]];
          } else if (typeof args[0] === 'number' && args[0] >= 1) {
            seq = args[0] - 1;
            return [parseInt(seq / columnCount, 10), seq % columnCount];
          }
        }
        throw new Error("[" + args + "] is invalid part-index.");
      };

      ImageIndexer.prototype._partDataToPos = function(partIndex, partSize, startPos) {
        if (startPos == null) {
          startPos = [0, 0];
        }
        return [partSize[1] * partIndex[0] + startPos[0], partSize[0] * partIndex[1] + startPos[1]];
      };

      ImageIndexer.prototype.asChip = function() {
        var data, imageKey, index, partIndex, pos;
        imageKey = arguments[0], index = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        data = this._getImageDataOrError(imageKey);
        if (data.type === 'clip') {
          return $('<div>').css({
            width: data.clipSize[0],
            height: data.clipSize[1],
            overflow: 'hidden'
          }).append($('<img>').css({
            display: 'block',
            marginTop: -data.clipPos[0],
            marginLeft: -data.clipPos[1],
            width: data.fullSize[0],
            height: data.fullSize[1]
          }).attr({
            src: data.url
          }));
        } else if (data.type === 'partition') {
          partIndex = this._argsToPartIndex(index, data.targetSize[0] / data.partSize[0]);
          pos = this._partDataToPos(partIndex, data.partSize, data.targetPos);
          return $('<div>').css({
            width: data.partSize[0],
            height: data.partSize[1],
            overflow: 'hidden'
          }).append($('<img>').css({
            display: 'block',
            marginTop: -pos[0],
            marginLeft: -pos[1],
            width: data.fullSize[0],
            height: data.fullSize[1]
          }).attr({
            src: data.url
          }));
        }
      };

      ImageIndexer.prototype.asData = function(imageKey) {
        return this._getImageData(imageKey);
      };

      return ImageIndexer;

    })();
  })(jQuery);

}).call(this);
