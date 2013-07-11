module.exports = (grunt) ->

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-notify'
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
      jqueries: [
        'test/assets/vendor/jquery-1.10.1.min.js'
        'test/assets/vendor/jquery-1.9.1.min.js'
        'test/assets/vendor/jquery-1.8.3.min.js'
      ]
      css:
        test: [
          'node_modules/mocha/mocha.css'
        ]
      builded:
        js:
          src: 'test/assets/build/src.js'
          test: 'test/assets/build/test.js'
          minified: 'jquery.imageIndexer.min.js'
          notminified: 'jquery.imageIndexer.js'
        css:
          all: 'test/assets/build/all.css'

    clean: ['test/assets/build']

    coffee:
      options:
        join: true
        bare: false
      development:
        files:
          '<%= constants.builded.js.src %>': [
            '<%= constants.coffee.src %>'
          ]
          '<%= constants.builded.js.test %>': [
            '<%= constants.coffee.test %>'
          ]
      production:
        files:
          '<%= constants.builded.js.notminified %>': [
            '<%= constants.coffee.src %>'
          ]

    concat:
      development_js:
        options:
          separator: ';\n'
        src: [
          '<%= constants.jqueries[grunt.task.current.args[0]] %>'
          '<%= constants.builded.js.src %>'
        ]
        dest: '<%= constants.builded.js.src %>'
      development_css:
        options:
          separator: '\n'
        src: [
          '<%= constants.css.test %>'
        ]
        dest: '<%= constants.builded.css.all %>'

    uglify:
      production:
        files:
          '<%= constants.builded.js.minified %>': '<%= constants.builded.js.notminified %>'

    watch:
      main:
        files: [
          '<%= constants.coffee.src %>'
          '<%= constants.coffee.test %>'
        ]
        tasks: ['build']

    testem:
      _src: ['test/index.html']
      options:
        launch_in_ci: [
          'PhantomJS'
        ]
      main:
        src: '<%= testem._src %>'
        dest: 'log/tests.tap'
      xb:
        options: {
          launch_in_ci: [
            'PhantomJS'
            'Chrome'
            'Firefox'
            'Safari'
          ]
        }
        src: '<%= testem._src %>'
        dest: 'log/tests.tap'
      travis:
        src: '<%= testem._src %>'

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

  grunt.registerTask 'test', [
    'build'
    'testem:main'
  ]

  grunt.registerTask 'test:xb', [
    'build'
    'testem:xb'
  ]

  grunt.registerTask 'test:xb:xjq', [
    'build'
    'testem:xb'
    'build:jquery19'
    'testem:xb'
    'build:jquery18'
    'testem:xb'
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
  grunt.registerTask 'testall', ['test:xb:xjq']
