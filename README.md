jQuery ImageIndexer [![Build Status](https://travis-ci.org/kjirou/jquery.imageIndexer.png)](https://travis-ci.org/kjirou/jquery.imageIndexer)
===================

A jQuery plugin for supporting image management.

User's document is [here](http://kjirou.github.io/jquery.imageIndexer/).


## Development

### Dependencies

- `node.js` >= `11.0`, e.g. `brew install node`
- `PhantomJS`, e.g. `brew install phantomjs`
- `gem install terminal-notifier` (for npm `growl`)

```
$ npm install -g grunt-cli testem
```

### Deploy

```
$ git clone git@github.com:kjirou/jquery.imageIndexer.git
$ cd jquery.imageIndexer
$ npm install
$ grunt
```

### Build commands

- `grunt` builds all files for development.
- `grunt watch` executes `grunt` each time at updating CoffeeScript files.
- `grunt release` generates JavaScript files for release.

### Testing

- Open [test/index.html](test/index.html)
- Execute `testem` or `testem -g` and open [http://localhost:7357/](http://localhost:7357/)
- `grunt test` is CI test by PhantomJS only.
- `grunt testall` is CI test for all browsers and all jQuery versions, but it has bugs.

### Test images credits

- [test/assets/images/denzi/](test/assets/images/denzi/) images are created by [Denzi](http://www3.wind.ne.jp/DENZI/diary/)
  under license from [CC BY-SA 2.1 JP](http://creativecommons.org/licenses/by-sa/2.1/jp/).
- [test/assets/images/sunayume.jp/](test/assets/images/sunayume.jp/) images are created by [沙夢](http://sunayume.jp/)
  under license from [here](http://sunayume.jp/?page_id=11).
