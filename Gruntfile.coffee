module.exports = (grunt) ->

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-testem'
  grunt.loadNpmTasks 'grunt-text-replace'

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
        jqueries: [
          'test/assets/vendor/jquery-1.10.1.min.js'
          'test/assets/vendor/jquery-1.9.1.min.js'
          'test/assets/vendor/jquery-1.8.3.min.js'
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
      # "concat:development_js:0" uses "constants.js.jqueries[0]"
      development_js:
        src: [
          '<%= constants.js.jqueries[grunt.task.current.args[0]] %>'
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
        tasks: ['build']

    testem:
      options:
        launch_in_ci: [
          'phantomjs'
        ]
      main:
        src: [
          'test/index.html'
        ]
        dest: 'log/tests.tap'
      # Waring: Chrome can't finish tests occasionally.
      # Ref) https://github.com/airportyh/testem/issues/240
      all_launchers:
        options: {
          launch_in_ci: [
            'phantomjs'
            'firefox'
            'safari'
            'chrome'
          ]
        }
        src: [
          'test/index.html'
        ]
        dest: 'log/tests.tap'
      travis:
        options: {
          launch_in_ci: [
            'phantomjs'
            'firefox'
          ]
        }
        src: [
          'test/index.html'
        ]

    replace:
      version:
        src: [
          'package.json'
          'imageIndexer.jquery.json'
          'scripts/src/jquery.imageIndexer.coffee'
        ]
        overwrite: true
        replacements: [
          from: /(['"])0\.1\.4(['"])/
          to: '$10.1.5$2'
        ]

  # @TODO testem ci を実行するためのカスタムタスク
  #       とりあえずは grunt-testem を使う方針にする。
  #       なおこれは exit ステータスがテスト失敗しても 0 しか返さないバグがある
  #       Ref) https://github.com/airportyh/testem/issues/235
  #       (-b の意味がよくわからんが、とりあえずつけてる)
  #       とりあえずはエラーコードを使う予定が無いからこのまま
  #grunt.registerTask 'test', ->
  #  done = @async()
  #  cmd = 'testem ci -b -l phantomjs'
  #  opts = timeout: 60000
  #  callback = (error, stdout, stderr) ->
  #    if not error
  #      console.log stdout
  #      done()
  #    else
  #      console.log 'ERR', error, stderr
  #      done(false)
  #  require('child_process').exec(cmd, opts, callback)

  grunt.registerTask 'build', [
    'clean'
    'coffee:development'
    'concat:development_js:0'
    'concat:development_css'
  ]

  grunt.registerTask 'build:jquery19', [
    'clean'
    'coffee:development'
    'concat:development_js:1'
    'concat:development_css'
  ]

  grunt.registerTask 'build:jquery18', [
    'clean'
    'coffee:development'
    'concat:development_js:2'
    'concat:development_css'
  ]

  grunt.registerTask 'testall', [
    'build'
    'testem:all_launchers'
    'build:jquery19'
    'testem:all_launchers'
    'build:jquery18'
    'testem:all_launchers'
  ]

  grunt.registerTask 'travis', [
    'build'
    'testem:travis'
  ]

  grunt.registerTask 'release', [
    'replace:version'
    'coffee:production'
    'uglify:production'
  ]

  # Aliases
  grunt.registerTask 'default', ['build']
  grunt.registerTask 'test', ['testem:main']
