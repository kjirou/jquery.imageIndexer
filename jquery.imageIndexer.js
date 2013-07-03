(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

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
    $.imageIndexer.version = '0.1.5';
    return ImageIndexer = (function() {
      var DuplicatedImageKeyError, InvalidArgsError, NotFoundImageKeyError;

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

      ImageIndexer.InvalidArgsError = InvalidArgsError = (function(_super) {
        __extends(InvalidArgsError, _super);

        function InvalidArgsError(message) {
          this.message = message;
          this.name = 'InvalidArgsError';
          InvalidArgsError.__super__.constructor.apply(this, arguments);
        }

        return InvalidArgsError;

      })(Error);

      ImageIndexer.NotFoundImageKeyError = NotFoundImageKeyError = (function(_super) {
        __extends(NotFoundImageKeyError, _super);

        function NotFoundImageKeyError(message) {
          this.message = message;
          this.name = 'NotFoundImageKeyError';
          NotFoundImageKeyError.__super__.constructor.apply(this, arguments);
        }

        return NotFoundImageKeyError;

      })(Error);

      ImageIndexer.DuplicatedImageKeyError = DuplicatedImageKeyError = (function(_super) {
        __extends(DuplicatedImageKeyError, _super);

        function DuplicatedImageKeyError(message) {
          this.message = message;
          this.name = 'DuplicatedImageKeyError';
          DuplicatedImageKeyError.__super__.constructor.apply(this, arguments);
        }

        return DuplicatedImageKeyError;

      })(Error);

      function ImageIndexer() {
        this._images = {};
        this.withPreloading = true;
      }

      ImageIndexer.prototype.clip = function(imageKey, url, realSize, clipPos, clipSize, options) {
        var opts, _ref;
        if (options == null) {
          options = {};
        }
        opts = $.extend({
          withPreloading: null
        }, options);
        if (this._hasImageData(imageKey)) {
          throw new DuplicatedImageKeyError("The imageKey=" + imageKey + " already exists.");
        }
        if (!this._withinSize(realSize, clipPos, clipSize)) {
          throw new InvalidArgsError("Pos=[" + clipPos + "] size=[" + clipSize + "] is not within [" + realSize + "].");
        }
        if ((_ref = opts.withPreloading) != null ? _ref : this.withPreloading) {
          this._preload(url);
        }
        return this._images[imageKey] = {
          type: 'clip',
          url: url,
          realSize: realSize.slice(),
          clipPos: clipPos.slice(),
          clipSize: clipSize.slice()
        };
      };

      ImageIndexer.prototype.upload = function(imageKey, url, realSize) {
        return this.clip(imageKey, url, realSize, [0, 0], realSize.slice());
      };

      ImageIndexer.prototype.partition = function(imageKey, url, realSize, partSize, options) {
        var opts, pos, size, _ref;
        if (options == null) {
          options = {};
        }
        opts = $.extend({
          targetPos: [0, 0],
          targetSize: realSize.slice(),
          withPreloading: null
        }, options);
        if (this._hasImageData(imageKey)) {
          throw new DuplicatedImageKeyError("The imageKey=" + imageKey + " already exists.");
        }
        pos = opts.targetPos.slice();
        size = opts.targetSize.slice();
        if (!this._withinSize(realSize, pos, size)) {
          throw new InvalidArgsError("Pos=[" + pos + "] size=[" + size + "] is not within [" + realSize + "].");
        }
        if (!this._isEqualDevidable(size, partSize)) {
          throw new InvalidArgsError("Size=[" + size + "] can't be divide equally by [" + partSize + "].");
        }
        if ((_ref = opts.withPreloading) != null ? _ref : this.withPreloading) {
          this._preload(url);
        }
        return this._images[imageKey] = {
          type: 'partition',
          url: url,
          realSize: realSize,
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
            throw new NotFoundImageKeyError("Not found image key=" + imageKey + ".");
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
        throw new InvalidArgsError("[" + args + "] is invalid part-index.");
      };

      ImageIndexer.prototype._partDataToPos = function(partIndex, partSize, startPos) {
        if (startPos == null) {
          startPos = [0, 0];
        }
        return [partSize[1] * partIndex[0] + startPos[0], partSize[0] * partIndex[1] + startPos[1]];
      };

      ImageIndexer.prototype.asChip = function() {
        var argsForPartIndex, data, imageKey, partIndex, pos;
        imageKey = arguments[0], argsForPartIndex = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        data = this._getImageDataOrError(imageKey);
        if (data.type === 'clip') {
          return $('<div>').css({
            margin: 0,
            padding: 0,
            width: data.clipSize[0],
            height: data.clipSize[1],
            overflow: 'hidden'
          }).append($('<img>').css({
            display: 'block',
            position: 'relative',
            margin: 0,
            padding: 0,
            top: -data.clipPos[0],
            left: -data.clipPos[1],
            width: data.realSize[0],
            height: data.realSize[1],
            border: 'none'
          }).attr({
            src: data.url
          }));
        } else if (data.type === 'partition') {
          partIndex = this._argsToPartIndex(argsForPartIndex, data.targetSize[0] / data.partSize[0]);
          pos = this._partDataToPos(partIndex, data.partSize, data.targetPos);
          return $('<div>').css({
            margin: 0,
            padding: 0,
            width: data.partSize[0],
            height: data.partSize[1],
            overflow: 'hidden'
          }).append($('<img>').css({
            display: 'block',
            position: 'relative',
            margin: 0,
            padding: 0,
            top: -pos[0],
            left: -pos[1],
            width: data.realSize[0],
            height: data.realSize[1],
            border: 'none'
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
