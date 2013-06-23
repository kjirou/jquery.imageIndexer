jquery.imageIndexer
===================

This jQuery plugin supports your image management.  
The following will be the main functions:

- You can manage images by granting key for each them
- You can clip a part of image that is merged many images like icon-collection


画像の管理を補助する jQuery プラグインです。  
以下が、主な機能となります:

- 画像にキーを付けて管理
- アイコン集などの複数画像が 1 枚にまとまめられた画像を、部分的に切り出し





## Example

```
// ---------------
// Resister images
// ---------------

// Register a full size image
//   upload(key, url, imageSize)
$.imageIndexer().upload('cat_with_man', 'images/cat_with_man.png', [300, 200]);

// Register a clipped image
//   clip(key, url, imageSize, clipStartPos, clipSize)
$.imageIndexer().clip('cat', 'images/cat_with_man.png', [300, 200], [0, 150], [150, 200]);

// Register a equal dividable image
//   partition(key, url, imageSize, partSize)
$.imageIndexer().partition('icons', 'images/icons.png', [128, 128], [16, 16]);


// ------------------------------
// Create images as jQuery object
// ------------------------------

// 300x200
$catWithMan = $.imageIndexer().asChip('cat_with_man');

// 150x200 is clipped from 300x200
$cat = $.imageIndexer().asChip('cat');

// 16x16 is clipped from 128x128
$icon1 = $.imageIndexer().asChip('icons', [1, 2]);
// Another 16x16
$icon2 = $.imageIndexer().asChip('icons', [1, 3]);
```

## Dependencies

- `jQuery` >= 1.8


## API References

- upload
- clip
- partition
- asChip
- asData
- $.imageIndexer
- $.imageIndexer.version
- $.imageIndexer.getClass


## Licence

MIT Licence


## Credits

- [test/assets/images/sunayume.jp/](test/assets/images/sunayume.jp/) images are provided by [沙夢 sunayume.jp](http://sunayume.jp/)


## Development

### Dependencies

- `node.js` >= 11.0
- `npm install -g grunt-cli`

### Deploy

```
$ git clone git@github.com:kjirou/jquery.imageIndexer.git
$ cd jquery.imageIndexer
$ npm install
$ grunt
```

### Commands

- `grunt` concats all files for development.
- `grunt watch` executes `grunt` each time at updating CoffeeScript files.
- `grunt release` generates JavaScript files for release.

### Testing

Open [test/index.html](test/index.html).
