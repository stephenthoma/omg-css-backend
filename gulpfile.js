'use strict';

/**
  * Load Dependiencies
  */

var gulp       = require('gulp'),
	  coffeelint = require('gulp-coffeelint'),
		nodemon    = require('gulp-nodemon'),
		coffee     = require('gulp-coffee'),
		clean      = require('gulp-clean'),
		watch      = require('gulp-watch'),
		gutil      = require('gulp-util'),
    uglify     = require('gulp-uglify'),
		stylish    = require('coffeelint-stylish'),
    mocha      = require('gulp-mocha');

/**
  * Gulp Configurations
  */

var config = {
  prod: !!gutil.env.production,
  init: function(){
    this.env = this.prod ? 'production' : 'development';
    if(!!gutil.env.test){
      this.env = 'test'
    }
    return this;
  }
}.init();


/**
  * Build Tasks
  */

// Lint Coffee files
gulp.task('lint', function () {
  gulp.src('./server/**/*.coffee')
    .pipe(coffeelint())
    .pipe(coffeelint.reporter(stylish))
});

// Compile coffee files to js
gulp.task('coffee', function() {

  // Production Uglify (minify & compress)
  if(config.prod){
    gulp.src('./server/**/*.coffee')
      .pipe(coffee({bare: true}).on('error', gutil.log))
      .pipe(uglify())
      .pipe(gulp.dest('./dist'));
  }

  // Development Build
  else{
    gulp.src('./server/**/*.coffee')
      .pipe(coffee({bare: true}).on('error', gutil.log))
      .pipe(gulp.dest('./dist'));
  }

});

// Clean distribution folder
gulp.task('clean', function(){
	gulp.src('./dist/*')
	.pipe(clean({force:true}));
});

// Watch for changes in js
gulp.task('watch', function(){
	gulp.watch('./server/**/*.coffee', ['coffee', 'lint'])
});

/**
  * Testing Tasks
  */

gulp.task('test', function(){
  require('coffee-script/register'); // Required for mocha
  var reporter = !!process.env.CIRCLECI ? 'mocha-junit-reporter' : 'spec';
  gulp.src('tests/**/*.coffee', {read:false})
  .pipe(mocha({
    reporter: reporter,
    reporterOptions: {
      mochaFile: process.env.CIRCLE_TEST_REPORTS + '/junit-report.xml'
    },
    compilers: 'coffee'
  }));
});

/**
  * Serve Tasks
  */

// Start Nodemon Server
gulp.task('nodemon', function () {
  nodemon({
    script: './dist/index.js',
    ext: 'coffee',
    env: { 'NODE_ENV': config.env }
  });
});

// default task
gulp.task('default', ['coffee', 'lint', 'nodemon', 'watch']);
