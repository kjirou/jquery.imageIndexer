module.exports = (grunt) ->

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  # @TODO tests を coffee/tests に置く

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
          'test/assets/vendor/underscore-min.js'
          'test/assets/vendor/jquery-1.10.1.min.js'
        ]
        src: [
          'jquery.imageIndexer.js'
        ]
        test: [
          'node_modules/mocha/mocha.js'
          'node_modules/expect.js/expect.js'
          'test/assets/build/_test.js'
        ]
      css:
        vendors: [
        ]
        src: [
        ]
        test: [
          'node_modules/mocha/mocha.css'
        ]

    clean: ['test/assets/build']

    coffee:
      compile_and_join_src:
        files:
          'jquery.imageIndexer.js': [
            '<%= constants.coffee.src %>'
          ]
          'test/assets/build/_test.js': [
            '<%= constants.coffee.test %>'
          ]
        options:
          join: true
          bare: false

    concat:
      options:
        separator: ';\n'
      test_all_js:
        src: [
          '<%= constants.js.vendors %>'
          '<%= constants.js.src %>'
          '<%= constants.js.test %>'
        ]
        dest: 'test/assets/build/all.js'
      test_all_css:
        src: [
          '<%= constants.css.vendors %>'
          '<%= constants.css.src %>'
          '<%= constants.css.test %>'
        ]
        dest: 'test/assets/build/all.css'

    watch:
      coffee:
        files: [
          '<%= constants.coffee.src %>'
          '<%= constants.coffee.test %>'
        ]
        tasks: ['clean', 'coffee', 'concat']

  grunt.registerTask 'default', ['clean', 'coffee', 'concat']
