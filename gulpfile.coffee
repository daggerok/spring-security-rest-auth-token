path      =
  public: 'src/main/resources/public'
  scripts: 'src/main/coffee'
  vendors: 'build/vendors'
  styles: 'src/main/css'
  html: 'src/main/html'
  dist: 'build/dist'
  api: 'build/api'
  css: 'index.css'
  js: 'index.js'

vendorJs  = [
  "#{path.vendors}/jquery/dist/jquery.js"
  "#{path.vendors}/sockjs/dist/sockjs-0.3.4.js"
  "#{path.vendors}/stomp/lib/stomp.js"
]
apiJs     = vendorJs.concat [
  "#{path.dist}/api.js"
]
appJs     = [
  "#{path.api}/*.js"
  "#{path.dist}/app.js"
]
vendorCss = [
  "#{path.vendors}/bootstrap/dist/css/bootstrap.css"
]
appCss    = vendorCss.concat [ "#{path.styles}/*.css" ]

gulp      = require 'gulp'
remove    = require 'gulp-rimraf'
coffee    = require 'gulp-coffee'
concat    = require 'gulp-concat'
uglify    = require 'gulp-uglify'
cssnano   = require 'gulp-cssnano'

gulp.task 'clean', ->
  gulp.src("#{path.public}", read: false)
    .pipe(remove force: true)

gulp.task 'coffee', ->
  gulp.src("#{path.scripts}/**/*.coffee", base: path.scripts)
    .pipe(coffee bare: true)
    .pipe(gulp.dest path.dist)

gulp.task 'api-js', ['coffee'], ->
  gulp.src(apiJs)
    .pipe(concat path.js)
    .pipe(gulp.dest path.api)

gulp.task 'js', ['api-js'], ->
  gulp.src(appJs)
    .pipe(concat path.js)
    .pipe(uglify())
    .pipe(gulp.dest path.public)

gulp.task 'css', ->
  gulp.src(appCss)
    .pipe(concat path.css)
    .pipe(cssnano())
    .pipe(gulp.dest path.public)

gulp.task 'html', ->
  gulp.src("#{path.html}/**/*.html")
    .pipe(gulp.dest path.public)

gulp.task 'default', ['js', 'css', 'html']

require("colors")
log = (error) ->
  console.log [
    "BUILD FAILED: #{error.name ? ''}".red.underline
    "\u0007" # beep
    "#{error.code ? ''}"
    "#{error.message ? ''}"
    "in #{error.filename ? ''}"
    "gulp plugin: #{error.plugin ? ''}"
    "error: #{error}"
  ].join "\n"
  this.end()

gulp.task 'dev-coffee', ->
  gulp.src("#{path.scripts}/**/*.coffee", base: path.scripts)
    .pipe(coffee bare: true)
      .on('error', log)
    .pipe(gulp.dest path.dist)

gulp.task 'dev-api-js', ['dev-coffee'], ->
  gulp.src(apiJs)
    .pipe(concat path.js)
    .pipe(gulp.dest path.api)

gulp.task 'dev-js', ['dev-api-js'], ->
  gulp.src(appJs)
    .pipe(concat path.js)
    .pipe(gulp.dest path.public)

gulp.task 'dev-css', ->
  gulp.src(appCss)
    .pipe(concat path.css)
    .pipe(gulp.dest path.public)

gulp.task 'dev', ['dev-js', 'dev-css', 'html']

gulp.task 'watch', ['dev'], ->
  gulp.watch "#{path.scripts}/**/*.coffee", ['dev-js']
  gulp.watch "#{path.styles}/**/*.css", ['dev-css']
  gulp.watch "#{path.html}/**/*.html", ['html']