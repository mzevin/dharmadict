Dharma Dictionary
==============

Prerequisites:
* install [Git](http://git-scm.com/)
* install [node.js (v0.10.20)](http://nodejs.org/) with npm (Node Package Manager)
* install [Grunt](https://github.com/gruntjs/grunt) package globally.  `npm install -g grunt-cli`
* install [Karma](http://karma-runner.github.io/0.10/index.html) package globally, version = 0.10.0  `npm install -g karma@0.10.0`
* install [Bower] (https://github.com/bower/bower) ` npm install -g bower `

To run:
* `cd ./Client`
* install nodejs dependencies `npm install`  (`sudo npm install` for mac)
* remove directives depend on bower `grunt clean:bower`
* install bower dependencies `bower install`
* to open the app in the browser run `grunt server`
* to run the tests run `grunt test`


