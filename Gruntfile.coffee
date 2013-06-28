module.exports = (grunt) ->

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  #grunt.loadNpmTasks 'grunt-testem'

  grunt.initConfig

    pkg: grunt.file.readJSON('package.json')

    constants:
      coffee:
        src: [
          'scripts/src/jquery.imageIndexer.coffee'
        ]
        test: [
          'scripts/test/setup.coffee'
          'scripts/test/tests.coffee'
          'scripts/test/run.coffee'
        ]
      js:
        vendors: [
          'test/assets/vendor/jquery-1.10.1.min.js'
        ]
        build:
          development: 'test/assets/build/_jquery.imageIndexer.js'
          production: 'jquery.imageIndexer.js'
        test: [
          'node_modules/mocha/mocha.js'
          'node_modules/expect.js/expect.js'
          'node_modules/sinon/pkg/sinon.js'
          'test/assets/build/_test.js'
        ]
      css:
        test: [
          'node_modules/mocha/mocha.css'
        ]

    clean: ['test/assets/build']

    coffee:
      development:
        options:
          join: true
          bare: false
        files:
          '<%= constants.js.build.development %>': [
            '<%= constants.coffee.src %>'
          ]
          'test/assets/build/_test.js': [
            '<%= constants.coffee.test %>'
          ]
      production:
        options:
          join: true
          bare: false
        files:
          '<%= constants.js.build.production %>': [
            '<%= constants.coffee.src %>'
          ]

    concat:
      options:
        separator: ';\n'
      development_js:
        src: [
          '<%= constants.js.vendors %>'
          '<%= constants.js.build.development %>'
          '<%= constants.js.test %>'
        ]
        dest: 'test/assets/build/all.js'
      development_css:
        src: [
          '<%= constants.css.test %>'
        ]
        dest: 'test/assets/build/all.css'

    uglify:
      production:
        files:
          'jquery.imageIndexer.min.js': '<%= constants.js.build.production %>'

    watch:
      coffee:
        files: [
          '<%= constants.coffee.src %>'
          '<%= constants.coffee.test %>'
        ]
        tasks: [
          'clean'
          'coffee:development'
          'concat:development_js'
          'concat:development_css'
        ]

    # @TODO Don't act it now
    #       Ref) https://github.com/sideroad/grunt-testem/issues/11
    #testem:
    #  options:
    #    launch_in_ci: [
    #      'phantomjs'
    #    ]
    #  main:
    #    src: [
    #      'test/index.html'
    #    ]
    #    dest: 'tests.tap'

  # @TODO testem ci を実行するためのカスタムタスク
  #       grunt-testem を使いたかったが、testem 3.00 だと動いてないっぽくて修正待ち
  #       またこれも、exit ステータスがテスト失敗しても 0 しか返さないバグがあるらしい
  #       Ref) https://github.com/airportyh/testem/issues/235
  #       (-b の意味がよくわからんが、とりあえずつけてる)
  #       とりあえずはエラーコードを使う予定が無いからこのまま
  grunt.registerTask 'test', ->
    done = @async()
    cmd = 'testem ci -b -l phantomjs'
    opts = timeout: 60000
    callback = (error, stdout, stderr) ->
      if not error
        console.log stdout
        done()
      else
        console.log 'ERR', error, stderr
        done(false)
    require('child_process').exec(cmd, opts, callback)

  grunt.registerTask 'default', [
    'clean'
    'coffee:development'
    'concat:development_js'
    'concat:development_css'
  ]
  grunt.registerTask 'release', [
    'coffee:production'
    'uglify:production'
  ]
