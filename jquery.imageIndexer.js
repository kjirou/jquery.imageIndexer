(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  (function($) {
    var ImageIndexer;
    if ($.imageIndexer != null) {
      return;
    }
    $.imageIndexer = function() {
      return null;
    };
    return ImageIndexer = (function() {
      function ImageIndexer() {
        this.partition = __bind(this.partition, this);
        this.upload = __bind(this.upload, this);
        this.clip = __bind(this.clip, this);
        this._images = {};
      }

      ImageIndexer.prototype.clip = function(key, url, fullSize, clipPos, clipSize) {};

      ImageIndexer.prototype.upload = function(key, url, fullSize) {
        return this.clip(key, url, fullSize, [0, 0], fullSize.slice());
      };

      ImageIndexer.prototype.partition = function(key, url, fullSize, partSize, options) {
        var opts;
        if (options == null) {
          options = {};
        }
        return opts = _.extend({
          uploadPos: [0, 0],
          uploadSize: fullSize.slice()
        }, options);
      };

      return ImageIndexer;

    })();
  })(jQuery);

}).call(this);
