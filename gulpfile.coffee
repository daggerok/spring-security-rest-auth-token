path              =
  public: 'src/main/resources/public'
  scripts: 'src/main/coffee'
  vendors: 'build/vendors'
  styles: 'src/main/css'
  html: 'src/main/html'
  dist: 'build/dist'
  css: 'index.css'
  js: 'index.js'

jsFilesToPackage  = [
  "#{path.vendors}/jquery/dist/jquery.js"
  "#{path.vendors}/knockout/dist/knockout.debug.js"
  "#{path.vendors}/sockjs-client/dist/sockjs-0.3.4.js"
  "#{path.vendors}/stomp/lib/stomp.js"
  "#{path.dist}/**/*.js"
]

cssFilesToPackage = [
  "#{path.vendors}/bootstrap/dist/css/bootstrap.css"
  "#{path.styles}/**/*.css"
]

gulp              = require 'gulp'
remove            = require 'gulp-rimraf'
coffee            = require 'gulp-coffee'
concat            = require 'gulp-concat'
uglify            = require 'gulp-uglify'
cssnano           = require 'gulp-cssnano'

require 'colors'
log = (error) ->
  console.log [
    "BUILD FAILED: #{error.name ? ''}".red.underline
    '\u0007' # beep
    "#{error.code ? ''}"
    "#{error.message ? error}"
    "in #{error.filename ? ''}"
    "gulp plugin: #{error.plugin ? ''}"
  ].join '\n'
  this.end()

gulp.task 'clean', ->
  gulp.src("#{path.public}", read: false)
    .pipe(remove force: true)

gulp.task 'coffee', ->
  gulp.src("#{path.scripts}/**/*.coffee", base: path.scripts)
    .pipe(coffee bare: true)
    .on('error', log)
    .pipe(gulp.dest path.dist)

gulp.task 'js', ['coffee'], ->
  gulp.src(jsFilesToPackage)
    .pipe(concat path.js)
    .pipe(uglify())
    .pipe(gulp.dest path.public)

gulp.task 'css', ->
  gulp.src(cssFilesToPackage)
    .pipe(concat path.css)
    .pipe(cssnano())
    .pipe(gulp.dest path.public)

gulp.task 'html', ->
  gulp.src("#{path.html}/**/*.html")
    .pipe(gulp.dest path.public)

gulp.task 'default', ['js', 'css', 'html']

gulp.task 'dev-js', ['coffee'], ->
  gulp.src(jsFilesToPackage)
    .pipe(concat path.js)
    .pipe(gulp.dest path.public)

gulp.task 'dev-css', ->
  gulp.src(cssFilesToPackage)
    .pipe(concat path.css)
    .pipe(gulp.dest path.public)

gulp.task 'dev', ['dev-js', 'dev-css', 'html']

gulp.task 'watch', ['dev'], ->
  gulp.watch "#{path.scripts}/**/*.coffee", ['coffee']
  gulp.watch "#{path.styles}/**/*.css", ['dev-css']
  gulp.watch "#{path.html}/**/*.html", ['html']
  gulp.watch "#{path.dist}/**/*.js", ['dev-js']