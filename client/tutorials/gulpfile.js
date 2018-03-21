var gulp    = require('gulp');
var elm     = require('gulp-elm');
var rename  = require('gulp-rename');
var plumber = require('gulp-plumber');
var del     = require('del');
var sass    = require('gulp-sass');
var browserSync = require('browser-sync').create();
var jsonServer = require('gulp-json-srv').create({
    port: 8080
});

// builds elm files and static resources (i.e. html and css) from src to dist folder
var paths = {
    dest: 'dist',
    elmApp: 'src/App.elm',
    introApp: 'src/Intro.elm',
    shapesApp: 'src/Shapes.elm',
    elm: 'src/**/*.elm',
    staticAssets: 'src/static/index.html',
    staticAssetsIntro: 'src/static/intro.html',
    staticAssetsShapes: 'src/static/shapes.html',
    css: 'node_modules/todomvc-app-css/index.css',
    sass: 'src/sass/*.scss'
};

gulp.task('clean', function(cb){
    del([paths.dest], cb);
});

gulp.task('sass', function(){
    return gulp.src(paths.sass)
        .pipe(sass().on('error', sass.logError))
        .pipe(gulp.dest(paths.dest + "/css"))
        .pipe(browserSync.stream());
});

gulp.task('elm-init', elm.init);

gulp.task('elm', ['elm-init'], function(){
    return gulp.src(paths.elmApp)
        .pipe(plumber())
        .pipe(elm())
        .pipe(gulp.dest(paths.dest))        
        .pipe(browserSync.stream());
});

gulp.task('elm-intro', ['elm-init'], function(){
    return gulp.src(paths.introApp)
        .pipe(plumber())
        .pipe(elm())
        .pipe(gulp.dest(paths.dest))
        .pipe(browserSync.stream());
});

gulp.task('elm-shapes', ['elm-init'], function(){
    return gulp.src(paths.shapesApp)
        .pipe(plumber())
        .pipe(elm())
        .pipe(gulp.dest(paths.dest))
        .pipe(browserSync.stream());
});

gulp.task('staticAssets', function(){
    return gulp.src(paths.staticAssets)
        .pipe(plumber())
        .pipe(gulp.dest(paths.dest));
});

gulp.task('staticAssets-intro', function(){
    return gulp.src(paths.staticAssetsIntro)
        .pipe(plumber())
        .pipe(rename("index.html"))
        .pipe(gulp.dest(paths.dest));
});

gulp.task('staticAssets-shapes', function(){
    return gulp.src(paths.staticAssetsShapes)
        .pipe(plumber())
        .pipe(rename("index.html"))
        .pipe(gulp.dest(paths.dest));
});

gulp.task('css', function(){
    return gulp.src(paths.css)
        .pipe(plumber())
        .pipe(gulp.dest(paths.dest + "/css"));
});

gulp.task('browser-sync', function(){
    browserSync.init({
        server: {
            baseDir: "dist/"
        }
    });
});

gulp.task('elm-watch', ['elm'], browserSync.reload);

gulp.task('elm-watch-intro', ['elm-intro'], browserSync.reload);

gulp.task('elm-watch-shapes', ['elm-shapes'], browserSync.reload);

gulp.task('jsonServer', function(){
    return gulp.src('json-data.json')
        .pipe(jsonServer.pipe());
});

gulp.task('watch', ['browser-sync'], function(){
    gulp.watch(["json-data.json"], ["jsonServer"]).on('change', browserSync.reload);
    gulp.watch(paths.elm, ['elm-watch']);
    gulp.watch(paths.staticAssets, ['staticAssets']).on('change', browserSync.reload);
    gulp.watch(paths.sass, ['sass']);
});

gulp.task('watch-intro', ['browser-sync'], function(){
    gulp.watch(["json-data.json"], ["jsonServer"]).on('change', browserSync.reload);
    gulp.watch(paths.elm, ['elm-watch-intro']);
    gulp.watch(paths.staticAssets, ['staticAssets-intro']).on('change', browserSync.reload);
    gulp.watch(paths.sass, ['sass']);
});

gulp.task('watch-shapes', ['browser-sync'], function(){
    gulp.watch(["json-data.json"], ["jsonServer"]).on('change', browserSync.reload);
    gulp.watch(paths.elm, ['elm-watch-shapes']);
    gulp.watch(paths.staticAssets, ['staticAssets-shapes']).on('change', browserSync.reload);
    gulp.watch(paths.sass, ['sass']);
});

gulp.task('build', ['elm', 'staticAssets', 'css', 'sass']);
gulp.task('build-intro', ['elm-intro', 'staticAssets-intro', 'sass']);
gulp.task('build-shapes', ['elm-shapes', 'staticAssets-shapes', 'sass']);
gulp.task('intro', ['jsonServer', 'build-intro', 'watch-intro']);
gulp.task('shapes', ['jsonServer', 'build-shapes', 'watch-shapes']);
gulp.task('dev', ['jsonServer', 'build', 'watch']);
gulp.task('default', ['build']);