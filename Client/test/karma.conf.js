// Karma configuration
// Generated on Wed Aug 07 2013 13:01:03 GMT+0400 (MSK)

module.exports = function(config) {
  config.set({

    // base path, that will be used to resolve files and exclude
    basePath: '',


    // frameworks to use
    frameworks: ['jasmine'],

    preprocessors: {
       '**/*.coffee': ['coffee']
    },
    // list of files / patterns to load in the browser
    files: [
        '../public/scripts/libs/**/require.js',
        '../public/scripts/libs/**/jquery.js',
        '../public/scripts/libs/**/angular.js',
        '../public/scripts/libs/**/angular-resource.js',
        '../public/scripts/libs/**/ui-bootstrap-tpls.js',
        '../test/libs/angular-mocks.js',
        '../test/scripts/directives/*.coffee',
        '../public/scripts/scripts.js',
        '../public/scripts/vendors.js',
        '../public/scripts/scripts.js',

    ]

    });
}
