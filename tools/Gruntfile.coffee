'use strict'
LIVERELOAD_PORT = 35729
lrSnippet = require('connect-livereload')({ port: LIVERELOAD_PORT })
proxySnippet = require('grunt-connect-proxy/lib/utils').proxyRequest
checkForModifiedImports = require('./lib/grunt-newer-util').checkForModifiedImports
mountFolder = (connect, dir) ->
  return connect.static(require('path').resolve(dir))

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    sass:
      options:
        precision: 3

      default:
        files: [
          expand: true
          cwd: '../htdocs/_scss'
          src: ['*.scss']
          dest: '../htdocs/common/css'
          ext: '.css'
        ]
        options:
          style: 'expanded'

    autoprefixer:
      options:
        browser: [
          'last 2 version'
          'Firefox ESR'
          'ie 9'
          'ie 8'
        ]
        map: true
      dist:
        src: '../htdocs/common/css/*.css'

    connect:
      livereload:
        options:
          hostname: '0.0.0.0'
          port: 3501
          middleware: (connect, options) ->
            return [
              lrSnippet
              proxySnippet
              mountFolder(connect, '../htdocs')
            ]
          open:
            target: 'http://localhost:<%= connect.livereload.options.port %>'
            appName: 'Google Chrome'
      proxies: [
        context: '/contact'
        host: '<%= pkg.name %>.localhost'
        headers:
          'Host': '<%= pkg.name %>.localhost'
      ]

    watch:
      options:
        nospawn: true
        livereload: true

      sass:
        files: '../htdocs/**/*.scss'
        tasks: [
          'newer:sass:default'
          'newer:autoprefixer:dist'
        ]

      static:
        files: [
          '../htdocs/**/*.html'
        ]

      gruntfile:
        files: ['Gruntfile.coffee']

    replace:
      styleguide_css:
        src: ['../docs/styleguide/common/css/*.css']
        dest: '../docs/styleguide/common/css/'
        replacements: [
          {
            from: /\/common\/(images|fonts)/g
            to: '../$1'
          },
          {
            from: /\(\/(images|_dev)/g
            to: '(../../$1'
          },
        ]
      styleguide_html:
        src: ['../docs/styleguide/*.html']
        dest: '../docs/styleguide/'
        replacements: [
          {
            from: '/common/images'
            to: 'common/images'
          },
          {
            from: /"\/(images|_dev)/g
            to: '"$1'
          },
        ]

    clean:
      options:
        force: true
      styleguide:
        ['../docs/styleguide']

    exec:
      validator:
        cmd: 'env W3C_MARKUP_VALIDATOR_URI=http://`boot2docker ip | sed -e "s/is\:\s([0-9\.]+)$/$1/"`/check site_validator ../test/sitemap.xml ../test/validation_report.html'
      hologram:
        cmd: '(cd hologramStuff; bundle exec hologram config.yml; cd ../)'

    newer:
      options:
        override: checkForModifiedImports

  # Load grunt tasks.
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  # Register tasks.
  grunt.registerTask 'default', [
    'newer:sass:default'
    'newer:autoprefixer:dist'
    'configureProxies'
    'connect'
    'watch'
  ]

  grunt.registerTask 'styleguide', [
    'clean:styleguide'
    'sass:default'
    'autoprefixer:dist'
    'exec:hologram'
    'replace'
  ]

  grunt.registerTask 'server', [
    'configureProxies'
    'connect:livereload:keepalive'
  ]

  return;
