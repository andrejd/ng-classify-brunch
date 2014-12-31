var gulp 			= require('gulp');
var plugins         = require('gulp-load-plugins')();

gulp.task('build', function () {

    gulp.src('src/*.coffee')
    .pipe(plugins.coffee({bare:true}))
    .pipe(gulp.dest('./lib'));

});

//watching for changes
gulp.task('watch', function() {

    gulp.watch(['./src/*.coffee'],['build']);

});
