module.exports = (grunt) ->

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'

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
