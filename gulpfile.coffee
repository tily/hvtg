fs = require 'fs-extra'
path = require 'path'
gulp = require 'gulp'
gulpUtil = require 'gulp-util'
gulpIf = require 'gulp-if'
sourceStream = require 'vinyl-source-stream'
browserify = require 'browserify'
watchify = require 'watchify'
uglify = require 'gulp-uglify'
streamify = require 'gulp-streamify'
coffeeReactify = require 'coffee-reactify'
browserifyCss = require 'browserify-css'
_ = require 'lodash'
jade = require 'gulp-jade'
rename = require 'gulp-rename'
watching = false

gulp.task 'watching', => watching = true
gulp.task 'build', ['build:html', 'build:script']
gulp.task 'watch', ['watching', 'build:html', 'build:script']

gulp.task 'build:html', =>
  gulp.src('client.jade')
    .pipe jade(pretty: true)
    .pipe rename('client.html')
    .pipe gulp.dest('public')

gulp.task 'build:script', =>
  dir = 'public'
  file = 'client.js'
  browserify = browserify
    cache: {}
    packageCache: {}
    fullPaths: true
    entries: ['client.cjsx']
    extensions: ['.coffee', '.js', '.cjsx', '.css']
  browserify
    .transform coffeeReactify
    .transform browserifyCss,
      rootDir: 'public'
      processRelativeUrl: (relativeUrl)->
        stripQueryStringAndHashFromPath = (url)-> url.split('?')[0].split('#')[0]
        rootDir = path.resolve(process.cwd(), 'public')
        relativePath = stripQueryStringAndHashFromPath(relativeUrl)
        queryStringAndHash = relativeUrl.substring(relativePath.length)
        prefix = '../node_modules/'
        if (_.startsWith(relativePath, prefix))
          vendorPath = 'vendor/' + relativePath.substring(prefix.length)
          source = path.join(rootDir, relativePath)
          target = path.join(rootDir, vendorPath)
          gulpUtil.log('Copying file from ' + JSON.stringify(source) + ' to ' + JSON.stringify(target))
          fs.copySync(source, target)
          return vendorPath + queryStringAndHash
        relativeUrl
  if watching
    watchified = watchify(browserify)
    watchified.on 'update', ()=> bundle(browserify, dir, file)
    watchified.on 'log', gulpUtil.log
  bundle(browserify, dir, file)
  
bundle = (browserify, dir, file)->
  browserify
    .bundle()
    .pipe sourceStream file
    .pipe gulpIf(!watching, streamify(uglify(compress: {drop_console: !watching})))
    .pipe gulp.dest dir
