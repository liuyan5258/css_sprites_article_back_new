module.exports = (grunt)->

  require('load-grunt-tasks')(grunt)
  require('time-grunt')(grunt)
  fs = require('fs')
  path = require('path')
  exec = require('child_process').exec

  appConfig = {
    app: 'app'
    dist: 'dist'
    developer: grunt.file.read('.developer')
    version: grunt.template.today("yyyymmddHHMMss")
  }


  grunt.initConfig {
    ntes: appConfig

    watch:{
      coffee: 
        files: ['<%= ntes.app %>/scripts/{,*/}*.coffee'],
        tasks: ['newer:coffee:compile']
      compass:
        files: ['<%= ntes.app %>/styles/{,*/}*.scss'],
        tasks: ['compass:compile']
      js:
        files: ['<%= ntes.app %>/scripts/{,*/}*.js'],
        tasks: ['newer:copy:js']
      jsx:
        files: ['<%= ntes.app %>/jsx/{,*/}*.js'],
        tasks: ['react:compile']

      livereload:
        options:
          livereload: '<%= connect.options.livereload %>'
        files: [
          '<%= ntes.app %>/{,*/}*.html',
          '<%= ntes.app %>/styles/{,*/}*.css',
          '.tmp/scripts/{,*/}*.js',
          '<%= ntes.app %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}'
        ]
    }

    connect: {
      options: 
        port: 9000
        # Change this to '0.0.0.0' to access the server from outside.
        hostname: '0.0.0.0'
        livereload: 35729
      livereload:
        options: 
          open: true,
          middleware: (connect)->
            return [
              connect.static('.tmp')
              connect.static(appConfig.app)
            ]
      dist:
        options:
          open: true
          base: '<%= ntes.dist %>'
        
    }

    compass: {
      compile: 
        options: 
          config: 'config.rb'
    }

    # less:{
    #   options:
    #     compress: true
    #   compile:
    #     files: [{
    #       expand: true,
    #       cwd: '<%= ntes.app %>/styles/'
    #       src: ['{,*/}*.less', '!{,*/}*.mixin.less'],
    #       dest: '.tmp/styles/'
    #       ext: '.css'
    #     }]
    # }

    coffee: {
      compile: {
        files: [{
          expand: true
          cwd: '<%= ntes.app %>/scripts/'
          src: ['{,*/}*.coffee']
          dest: '.tmp/scripts/'
          ext: '.js'
        }]
      }
    }

    react: {
      compile:
        files: [
          expand: true
          cwd: '<%= ntes.app %>/jsx/'
          src: ['*.js']
          dest: '.tmp/scripts'
          ext: '.js'
        ]
    }

    uglify: {
      dist: 
        files: [{
          expand: true
          cwd: '.tmp/scripts/'
          src: ['*.js']
          dest: '.tmp/scripts/'
          ext: '.js'
        },{
          expand: true
          cwd: '<%= ntes.app %>/scripts/'
          src: ['*.js']
          dest: '.tmp/scripts/'
          ext: '.js'
        }]
          
    }
    htmlbuild: {
      test:
        src: '<%=ntes.app%>/*.html'
        dest: '<%=ntes.dist%>/'
        options:
          prefix: 'http://f2e.developer.163.com/<%= ntes.developer %>/article-share/'
          scripts:
            article_back_new:
              main: 'dist/scripts/article_back_new.js'
          styles:
            article_back_new:
              main: 'dist/styles/article_back_new.css'
      dist:
        src: '<%=ntes.app%>/*.html'
        dest: '<%=ntes.dist%>/<%= ntes.version %>/html'
        options:
          prefix: 'http://img1.cache.netease.com/utf8/3g/article-share/<%= ntes.version %>/holder/'
          # relative: false
          scripts:
            article_back_new:
              main: 'dist/<%= ntes.version %>/scripts/article_back_new.js'
          styles:
            article_back_new:
              main: 'dist/<%= ntes.version %>/styles/article_back_new.css'
    }

    clean: {
      dist: 
        files: [{
          dot: true,
          src: [
            '.tmp',
            '<%= ntes.dist %>/{,*/}*',
            '!<%= ntes.dist %>/.git*'
          ]
        }]
      
      server: '.tmp'
    }

    copy: {
      test: {
        files:[{
          expand: true
          cwd: '.tmp'
          dest: '<%= ntes.dist %>/'
          src: [
            'scripts/{,*/}*.js'
          ]
        },{
          expand: true
          cwd: '<%= ntes.app %>'
          dest: '<%= ntes.dist %>/'
          src: [
            'styles/*.css','!styles/*.mixin.css'
          ]
        },{
          expand: true
          cwd: '<%= ntes.app %>'
          dest: '<%= ntes.dist %>/'
          src: [
            'images/{,*/}*.*', '!images/icons/*.*', 'scripts/{,*/}*.js'
          ]
        }]
      }
      dist: {
        files: [{
          expand: true
          cwd: '.tmp'
          dest: '<%= ntes.dist %>/<%= ntes.version %>'
          src: [
            'scripts/{,*/}*.js'
          ]
        },{
          expand: true
          cwd: '<%= ntes.app %>'
          dest: '<%= ntes.dist %>/'
          src: [
            'styles/*.css','!styles/*.mixin.css'
          ]
        },{
          expand: true
          cwd: '<%= ntes.app %>'
          dest: '<%= ntes.dist %>/<%= ntes.version %>'
          src: [
            'images/{,*/}*.*','!images/icons/*.*'
          ]
        }]
      }
      # styles: {
      #   expand: true
      #   cwd: '<%= ntes.app %>/styles',
      #   dest: '.tmp/styles/',
      #   src: '{,*/}*.css'
      # }
      js: {
        expand: true,
        cwd: '<%= ntes.app %>/scripts',
        dest: '.tmp/scripts/',
        src: '{,*/}*.js'
      }
    }

    ftps_deploy: {
      deploy: {
        options: 
          auth:
            host:'61.135.251.132'
            port: 16321
            authKey: 'key1'
            secure: true
        
        files: [{
          expand: true,
          cwd:'<%= ntes.dist %>',
          src: ['**/*','!**/*.html'],
          dest: '/utf8/3g/article-share'
        }]
      }
    }
  }

  grunt.registerTask 'serve', 'Compile then start a connect web server', (target)->
    if target is 'dist'
      grunt.task.run ['build', 'connect:dist:keepalive']
      return

    grunt.task.run([
      'clean:server'
      'react'
      'coffee'
      # 'less'
      'compass:compile'
      # 'copy:styles'
      'copy:js'
      'connect:livereload'
      'watch'
    ])
    return

  grunt.registerTask 'build', (target)->
    if target
      target += '.html' if not /\.html$/.test(target)
      grunt.config.set('htmlbuild.dist.src', "<%=ntes.app%>/#{target}")
    grunt.task.run([
      'clean:dist'
      'react'
      'coffee'
      # 'less'
      'compass:compile'
      'uglify'
      'copy:dist'
      'htmlbuild:dist'
    ])

  grunt.registerTask 'deploy', (target)->
    target = '' if not target
    grunt.task.run ['build:' + target, 'ftps_deploy']
    return

  grunt.registerTask 'f2e', (target)->
    done = this.async()
    upload = exec "scp -r -P 16322 dist/* #{appConfig.developer}@223.252.197.245:/home/#{appConfig.developer}/article-share/", (error, stdout, stderr)->
      console.log('stdout: ' + stdout)
      console.log('stderr: ' + stderr)
      if error
        console.log('exec error: ' + error)
      else
        console.log('Upload done')
      done()
    return
  grunt.registerTask 'test', (target)->
    html = ""
    if target
      if not /\.html$/.test(target)
        html = target + '.html' 
      grunt.config.set('htmlbuild.test.src', "<%=ntes.app%>/#{html}")
    grunt.task.run([
      'clean:dist'
      'react'
      'coffee'
      # 'less'
      'compass:compile'
      # 'uglify'
      'copy:test'
      'htmlbuild:test'
      'f2e'
    ])


