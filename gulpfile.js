var gulp 			= require('gulp');
var plugins         = require('gulp-load-plugins')();
var pkg             = require('./package.json');
var conChangelog    = require('conventional-changelog');
var fs              = require('fs');
var gutil           = require('gulp-util');

var CHANGELOG_FILE  = 'CHANGELOG.md';

gulp.task('build', function () {

    gulp.src('src/*.coffee')
    .pipe(plugins.coffee({bare:true}))
    .pipe(gulp.dest('./lib'));

});

//watching for changes
gulp.task('watch', function() {

    gulp.watch(['./src/*.coffee'],['build']);

});

gulp.task('changelog', function(){
	options = {
		repository : pkg.repository.url,
		version    : pkg.version,
		file       : CHANGELOG_FILE,
		log        : gutil.log
	};

	conChangelog(options, function(err, log) {
		fs.writeFile(CHANGELOG_FILE, log);
	});
});
