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
    $.imageIndexer._addShortcut = function(methodName) {
      return this[methodName] = function() {
        var ins;
        ins = ImageIndexer.getInstance();
        return ins[methodName].apply(ins, arguments);
      };
    };
    $.imageIndexer._addShortcut('clip');
    $.imageIndexer._addShortcut('upload');
    $.imageIndexer._addShortcut('partition');
    $.imageIndexer.getClass = function() {
      return ImageIndexer;
    };
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
        this._indexes = {};
      }

      ImageIndexer.prototype.clip = function(imageKey, url, fullSize, clipPos, clipSize) {
        if (this._hasIndex(imageKey)) {
          throw new Error("The imageKey=" + imageKey + " already exists.");
        }
      };

      ImageIndexer.prototype.upload = function(imageKey, url, fullSize) {
        return this.clip(imageKey, url, fullSize, [0, 0], fullSize.slice());
      };

      ImageIndexer.prototype.partition = function(imageKey, url, fullSize, partSize, options) {
        var opts, pos, size;
        if (options == null) {
          options = {};
        }
        if (this._hasIndex(imageKey)) {
          throw new Error("The imageKey=" + imageKey + " already exists.");
        }
        opts = _.extend({
          targetPos: [0, 0],
          targetSize: fullSize.slice()
        }, options);
        pos = opts.targetPos.slice();
        size = opts.targetSize.slice();
        if (!this._withinSize(fullSize, pos, size)) {
          throw new Error("Pos=" + pos + ", size=" + size + " is not within " + fullSize + ".");
        }
        if (!this._isEqualDevidable(size, partSize)) {
          throw new Error("Size=" + size + " can't be devide equally by " + partSize + ".");
        }
        return this._indexes[imageKey] = {
          type: 'partition',
          url: url,
          fullSize: fullSize,
          partSize: partSize,
          targetPos: pos,
          targetSize: size
        };
      };

      ImageIndexer.prototype._getIndex = function(imageKey) {
        var _ref, _ref1;
        return (_ref = (_ref1 = this._indexes) != null ? _ref1[imageKey] : void 0) != null ? _ref : null;
      };

      ImageIndexer.prototype._hasIndex = function(imageKey) {
        return this._getIndex(imageKey) !== null;
      };

      ImageIndexer.prototype._withinSize = function(parentSize, childPos, childSize) {
        return (parentSize[0] >= childPos[1] + childSize[0]) && (parentSize[1] >= childPos[0] + childSize[1]);
      };

      ImageIndexer.prototype._isEqualDevidable = function(size, partSize) {
        return (size[0] % partSize[0] === 0) && (size[1] % partSize[1] === 0);
      };

      ImageIndexer.prototype.asChip = function() {
        var imageKey, indexInfo;
        imageKey = arguments[0], indexInfo = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      };

      ImageIndexer.prototype.setAlias = function() {
        var aliasImageKey, imageKey, indexInfo;
        aliasImageKey = arguments[0], imageKey = arguments[1], indexInfo = 3 <= arguments.length ? __slice.call(arguments, 2) : [];
      };

      return ImageIndexer;

    })();
  })(jQuery);

}).call(this);
