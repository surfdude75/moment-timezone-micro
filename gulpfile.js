var gulp = require("gulp");
var del = require('del');
var webpackStream = require('webpack-stream');
var mocha = require('gulp-mocha');
require('coffee-script/register');

gulp.task("build",function(){
  return gulp.src('src/entry.js')
    .pipe(webpackStream( require('./webpack.config.js') ))
    .pipe(gulp.dest('dist/'));
});

gulp.task("test",function(){
  return gulp.src(['tests/*.coffee'], { read: false })
    .pipe(mocha({reporter: 'nyan'}));
});

gulp.task('clean', del.bind(null, ['dist']));

gulp.task('default', ['clean','test'], () => {
  gulp.start('build');
});

