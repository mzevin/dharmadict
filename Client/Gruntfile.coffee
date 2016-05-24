# Build configurations.
moment = require 'moment'
time = start = end = 0
module.exports = (grunt) ->

	grunt.registerMultiTask 'start', 'Start timer', ->
		start = new Date()

	grunt.registerMultiTask 'end', 'End timer and print time', ->
		end = new Date()
		time = end - start
		console.log moment(time).format('mm:ss.SSS')

	grunt.registerMultiTask 'fileconstruct', 'Build a file', ->
		src = @data.src
		dist = @data.dist
		return grunt.log.warn('src is required') if !src
		return grunt.log.warn('dist is required') if !dist
		cwd = @data.cwd ? './'
		files = grunt.file.expand {cwd}, src
		return grunt.verbose.warn('No src files found') if !files.length is 0

		path = require 'path'
		return grunt.log.warn('path lib is required') if !path

		console.log 'files:', files
		console.log dist

		grunt.file.delete(dist) if grunt.file.exists(dist)

		scripts = "<% if (config.environment === 'dev') { %>\n"

		files.forEach (file) ->
			scripts += "<script src='#{file}'></script>\n"

		scripts += "<% } %>\n"

		grunt.file.write dist, scripts
		grunt.template.process


	grunt.registerMultiTask "wrap", "Wraps source files with specified header and footer", ->
		data = @data
		path = require("path")
		header = grunt.file.read(grunt.template.process(data.header))
		footer = grunt.file.read(grunt.template.process(data.footer))
		contents = grunt.file.read(grunt.template.process(data.content))
		prodScripts = grunt.file.read(grunt.template.process(data.prodScripts))
		devScripts = grunt.file.read(grunt.template.process(data.devScripts)) if data.devScripts

		tag = grunt.option 'tag' || ''
		if tag and tag != true
			tagBlock = '<div class="tag-information">' + moment().format('YYYY-MM-DD HH:mm') + ' ' + tag + '</div>'

		tmp = header + contents + prodScripts
		tmp = tmp + devScripts if data.devScripts
		tmp = tmp + tagBlock if tagBlock
		tmp = tmp + footer

		grunt.file.write "./.temp/index.html", tmp

		grunt.file.delete(grunt.template.process(data.devScripts)) if data.devScripts
		grunt.log.writeln "File \"" + "./.temp/index.html" + "\" created."


	grunt.registerTask "upload", "Uploads CSV file into Elasticsearch", (inputFile, author, elasticHost) ->
		console.log "inputFile: #{inputFile}"
		console.log "author: #{author}"

		# when 'author' parmameter is missed, it means that we are loading basic terms description file (w/o translations field)
		loadTermsDesc = author == null || author == undefined
		if author == "HOP" then lang = "eng" else lang = "rus"
		if author?
			author = "М.Н. Кожевникова" if author == "MK"
			author = "А. Кугявичус - А.А. Терентьев" if author == "KT"
			author = "Б.И. Загуменнов" if author == "BZ"
			author = "J. Hopkins" if author == "JH"

		elasticHost = "localhost" unless elasticHost?
		indexName = "dharmadict"
		typeName = "terms"

		fs = require('fs')
		return grunt.log.warn('fs lib is required') if !fs
		parse = require('csv-parse')
		return grunt.log.warn('csv-parse lib is required') if !parse
		elasticsearch = require('elasticsearch')
		return grunt.log.warn('elasticsearch lib is required') if !elasticsearch

		done = this.async()	# this task is async!

		client = new elasticsearch.Client
			host: elasticHost + ':9200'
			log: 'trace'
			keepAlive: false
		client.indices.create {index: indexName} unless client.indices.exists {index: indexName}

		bulkObject = {body: []}

		addTerm = (term) ->
			if term?
				termId = term.wylie.split(" ").join("_")
				# add action
				bulkObject.body.push { update: { _index: indexName, _type: typeName, _id: termId } }
				# add document
				if loadTermsDesc
					bulkObject.body.push
						doc: term
						doc_as_upsert : true
				else
					bulkObject.body.push
						script: "if (ctx._source.containsKey('translations')) {ctx._source.translations += translation;} else {ctx._source.translations = [translation]}"
						upsert: term
						params:
							translation: term.translation

		updateDB = ->
			client.bulk(bulkObject, (err, response) ->
				grunt.log.warn  "Error :" + err.message if err?
				done true
				)

		inputStream = fs.createReadStream __dirname + '/' + inputFile
		parser = parse {columns: true, delimiter: ','}

		parser.on 'readable', ->
			while (record = parser.read())?
				continue unless record.wylie?
				if loadTermsDesc
					addTerm
						wylie: record.wylie
						sanskrit_rus: record.sanskrit_rus
						sanskrit_eng: record.sanskrit_eng
						wikipedia: record.wikipedia
				else if !!record.translations
					comments = if record.comment? then record.comment.split('+') else []
					mngs = []
					record.translations.split('+').map (val, i) =>
						mngs.push {
							versions: {rus: ver.trim()} for ver in val.split(',') # TODO: language
							comment: if comments.length > i then comments[i].trim() else null
						}
					addTerm
						wylie: record.wylie
						translation:
							translator: author
							meanings: mngs

		parser.on 'finish', ->
			updateDB()
			#console.log JSON.stringify(bulkObject, null, 2)
			client.close		# close elasticsearch connection

		parser.on 'error', (err) ->
			grunt.log.warn err.message
			done false

		inputStream.pipe(parser).pipe(process.stdout)

	grunt.initConfig
	# Deletes deployment and temp directories.
	# The temp directory is used during the build process.
	# The deployment directory contains the artifacts of the build.
	# These directories should be deleted before subsequent builds.
	# These directories are not committed to source control.
		start:
			scripts:
				true

		end:
			scripts:
				true

		fileconstruct:
			scripts:
				cwd: "./.temp"
				dist: "./src/devScripts.html"
				src: [
					"vendors/underscore/underscore.js"
					"vendors/jquery/jquery.js"
					"vendors/angular/angular.js"
					"vendors/angular-resource/angular-resource.js"
					"vendors/angular-route/angular-route.js"
					"vendors/angular-ui-scroll/dist/ui-scroll.js"
					"vendors/elasticsearch/elasticsearch.angular.js"
					"vendors/**/ui-bootstrap-tpls.js"
					"vendors/**/module/*.js"
					"vendors/**/scripts/*.js"
					"!**/test/**"
					"scripts/config/development.js"
					"scripts/app.js"
					"scripts/routes.js"
					"scripts/responseInterceptors/*.js"
					"scripts/controllers/**/*.js"
					"scripts/directives/**/*.js"
					"scripts/services/**/*.js"
					"scripts/filters/**/*.js"
					"scripts/resources/**/*.js"
					"scripts/viewsMandatory.js"
				]

		wrap:
			dev:
				header: './src/header.html'
				content: './src/content.html'
				prodScripts : './src/prodScripts.html'
				devScripts: './src/devScripts.html'
				footer: './src/footer.html'
				dest: '.'
			prod:
				header: './src/header.html'
				content: './src/content.html'
				prodScripts : './src/prodScripts.html'
				footer: './src/footer.html'
				dest: '.'

		clean:
			bower:
				src: [
					'./src/libs/vendors/'
					'./src/styles/vendors/'
					'./bower_components/'
					'./src/views/vendors/'
					'./test/vendors/'
				]
			dev:
				src: [
					'./public/'
					'./.test/'
					'./.temp/'
				]
			prod:
				src: [
					'./.test/'
					'./.temp/'
				]

	# Compile CoffeeScript (.coffee) files to JavaScript (.js).
		coffee:
			dev:
				files: [
					cwd: './.temp/'
					src: ['scripts/**/*.coffee', 'vendors/**/*.coffee']
					dest: './.temp/'
					expand: true
					ext: '.js'
				]
				options:
					bare: true
			prod:
				files: [
					'./.temp/scripts/env.js': [ './.temp/scripts/config/production.coffee' ]
					'./.temp/scripts/scripts.js': [
						"./.temp/vendors/**/module/*.coffee"
						"./.temp/vendors/**/scripts/*.coffee"
						"!**/test/**"
						'./.temp/scripts/app.coffee'
						'./.temp/scripts/routes.coffee'
						'./.temp/scripts/responseInterceptors/**/*.coffee'
						'./.temp/scripts/resources/**/*.coffee'
						'./.temp/scripts/services/**/*.coffee'
						'./.temp/scripts/directives/**/*.coffee'
						'./.temp/scripts/controllers/**/*.coffee'
						'./.temp/scripts/filters/**/*.coffee'
					]
					'./.temp/scripts/views.js': [ './.temp/scripts/views.coffee' ]
				]
				options:
					bare: true
					sourceMap: false
			server:
				files:
					'../Server/app.js': './server/prod-server.coffee'
				options:
					bare: true

	# Compile LESS (.less) files to CSS (.css).
		less:
			styles:
				files:
					'./.temp/styles/custom/styles.css': ['./.temp/styles/custom/styles.less']
	#options:
	#  sourcemap: true

		connect:
			app:
				options:
					base: './public/'
					middleware: require './server/middleware'
					port: 5000
					hostname: '0.0.0.0'
					livereload: false

	# Copies directories and files from one location to another.
		copy:
			bower:
				files: [
					cwd: './bower_components/'
					src: '**'
					dest: './.temp/vendors/'
					expand: true
				]

		# Copies the contents of the temp directory, except views, to the dist directory.
		# In 'dev' individual files are used.
			dev:
				files: [
					cwd: './.temp/'
					src: '**'
					dest: './public/'
					expand: true
				]

		# Copies img directory to temp.
			img:
				files: [
					cwd: './src/'
					src: ['img/**/*.png','img/**/*.jpg','img/**/*.gif']
					dest: './.temp/'
					expand: true
				]
		# Copies favicon to temp.
			favicon:
				files: [
					cwd: './src/'
					src: 'favicon.ico'
					dest: './.temp/'
					expand: true
				]
		# Copies csslib directory to temp.
			csslib:
				files: [
					cwd: './src/'
					src: ['styles/lib/**/*','styles/vendors/**/*']
					dest: './.temp/'
					expand: true
				]
		# Copies styles directory with less to temp.
			styleSource:
				files: [
					cwd: './src/'
					src: 'styles/**/*'
					dest: './.temp/'
					expand: true
				]
		# Copies fonts directory to temp.
			fonts:
				files: [
					cwd: './src/'
					src: 'fonts/**/*'
					dest: './.temp/'
					expand: true
				]
		# Copies js files to the temp directory
			scriptSource:
				files: [
					cwd: './src/scripts'
					src: '**/*.js'
					dest: '.temp/scripts'
					expand: true
				,
					cwd: './src/scripts'
					src: '**/*.coffee'
					dest: '.temp/scripts'
					expand: true
				,
					cwd: './src/libs/'
					src: '**/*.js'
					dest: '.temp/scripts/libs'
					expand: true
				,
					cwd: './src/libs/'
					src: '**/*.coffee'
					dest: '.temp/scripts/libs'
					expand: true
				]
			less:
				files: [
					cwd: './bower_components/'
					src: ['**/styles/*.less']
					dest: './.temp/styles/vendors'
					expand: true
					flatten: true
				]
		# Copies select files from the temp directory to the dist directory.
		# In 'prod' minified files are used along with img and libs.
		# The dist artifacts contain only the files necessary to run the application.
			prod:
				files: [
					cwd: './.temp/'
					src: [
						'styles/fonts/**/*.*'
						'img/**/*.png'
						'img/**/*.jpg'
						'img/**/*.gif'
						'scripts/jquery.min.js'
						'scripts/scripts.min.js'
						'scripts/vendors.min.js'
						'styles/custom/styles.min.css'
					]
					dest: '../Server'
					expand: true
				,
					'../Server/index.html': './.temp/index.min.html',
					'../Server/favicon.ico': './.temp/favicon.ico'
				]
		# Task is run when the watched index.template file is modified.
			index:
				files: [
					cwd: './.temp/'
					src: 'index.html'
					dest: './public/'
					expand: true
				]
		# Task is run when a watched script is modified.
			scripts:
				files: [
					cwd: './.temp/'
					src: 'scripts/**'
					dest: './public/'
					expand: true
				]
		# Task is run when a watched style is modified.
			styles:
				files: [
					cwd: './.temp/'
					src: 'styles/**'
					dest: './public/'
					expand: true
				]
		# Task is run when a watched view is modified.
			views:
				files: [
					cwd: './.temp/'
					src: 'views/**'
					dest: './public/'
					expand: true
				]

	# Compresses png files
		imagemin:
			img:
				files: [
					cwd: './src/'
					src: ['img/**/*.png','img/**/*.jpg','img/**/*.gif']
					dest: './.temp/'
					expand: true
				]
				options:
					optimizationLevel: 7

	# Install Bower components
		bower:
			install:
				options:
					layout: 'byType'
					install: true
					copy: false

	# Runs tests using karma
		karma:
			unit:
				options:
					autoWatch: true
					browsers: ['PhantomJS']
					singleRun: true
					colors: true
					configFile: './test/karma.conf.js'
					port: 8081
					reporters: ['progress', 'coverage']
					runnerPort: 9100
			e2e:
				options:
				#autoWatch: true
				#browsers: ['Chrome']
				#colors: true
					configFile: './test/karma-e2e.conf.js'

	# Runs test using Protractor
		protractor:
			options:
				keepAlive: false
				noColor: false
			e2e:
				options:
					configFile: "./test/e2e.conf.js"
			qa:
				options:
					configFile: "./test/e2e-qa.conf.js"
					keepAlive: true

	# Minifiy index.html.
	# Extra white space and comments will be removed.
	# Content within <pre /> tags will be left unchanged.
	# IE conditional comments will be left unchanged.
	# As of this writing, the output is reduced by over 14%.
		minifyHtml:
			prod:
				files:
					'./.temp/index.min.html': './.temp/index.html'

		uglify:
			prod:
				options:
					mangle: false
					compress: false
					beautify: true
				files:
					'./.temp/scripts/jquery.min.js': [
						'./.temp/vendors/jquery/jquery.js'
					]
					'./.temp/scripts/vendors.min.js': [
						'./.temp/vendors/underscore/underscore.js'
						'./.temp/vendors/angular/angular.js'
						'./.temp/vendors/angular-resource/angular-resource.js'
						'./.temp/vendors/angular-route/angular-route.js'
						'./.temp/vendors/angular-ui-scroll/dist/ui-scroll.js'
						'./.temp/vendors/angular-bootstrap/ui-bootstrap-tpls.js'
						'./.temp/vendors/elasticsearch/elasticsearch.angular.js'
						'./.temp/vendors/**/module/*.js'
						'./.temp/vendors/**/scripts/*.js'
					],
					'./.temp/scripts/scripts.min.js': [
						'./.temp/scripts/env.js'
						'./.temp/scripts/scripts.js'
						'./.temp/scripts/views.js'
						'./.temp/scripts/directives/*.js'
						'./.temp/scripts/services/*.js'
						'./.temp/scripts/controllers/*.js'
						'./.temp/scripts/filters/*.js'
					]
			miniprod:
				options:
					mangle: false
					compress: false
					beautify: true
				files:
					'./.temp/scripts/scripts.min.js': [
						'./.temp/scripts/env.js'
						'./.temp/scripts/scripts.js'
						'./.temp/scripts/views.js'
						'./.temp/scripts/directives/*.js'
						'./.temp/scripts/services/*.js'
						'./.temp/scripts/controllers/*.js'
						'./.temp/scripts/filters/*.js'
					]

		cssmin:
			combine:
				files:
					'.temp/styles/custom/styles.min.css': ['.temp/styles/custom/styles.css']

		concat:
			css:
				src: ['bower_components/bootstrap/dist/css/bootstrap.css', '.temp/styles/custom/styles.css']
				dest: '.temp/styles/custom/styles.css'

	# This file is then included in the output automatically.  AngularJS will use it instead of going to the file system for the views, saving requests.  Notice that the view content is actually minified.  :)
		ngTemplateCache:
			views:
				files:
					'./.temp/scripts/views.js': ['./.temp/views/**/*.html', './.temp/vendors/**/*.html']
				options:
					trim: './.temp/'
			mandatory:
				files:
					'./.temp/scripts/viewsMandatory.js': ['./.temp/views/dialogs/**/*.html']
				options:
					trim: './.temp/'

	# Restart server when server sources have changed, notify all browsers on change.
		watch:
			scripts:
				files: './src/scripts/**/*.coffee'
				tasks: [
					'copy:scriptSource'
					'coffee:dev'
					'copy:scripts'
				]
				options:
					livereload: false
			styles:
				files: './src/styles/**/*.less'
				tasks: [
					'copy:styleSource'
					'less:styles'
					'copy:styles'
				]
				options:
					livereload: false
			views:
				files: './src/views/**/*.html'
				tasks: [
					'template:views'
					'copy:views'
				]
			server:
				files: './server/server.coffee'
				options:
					livereload: true

			test:
				files: './test/**/*.*'
				tasks: []

		# Used to keep the web server alive
			none:
				files: 'none'
				options:
					livereload: true

		template:
			views:
				files:
					'./.temp/views/': './src/views/**/*.html'
			dev:
				files:
					'./.temp/index.html': './.temp/index.html'
				environment: 'dev'
			prod:
				files: '<%= template.dev.files %>'
				environment: 'prod'


	# Register grunt tasks supplied by grunt-contrib-*.
	# Referenced in package.json.
	# https://github.com/gruntjs/grunt-contrib

	grunt.loadNpmTasks 'grunt-contrib-clean'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-connect'
	grunt.loadNpmTasks 'grunt-contrib-copy'
	grunt.loadNpmTasks 'grunt-contrib-imagemin'
	grunt.loadNpmTasks 'grunt-contrib-uglify'
	grunt.loadNpmTasks 'grunt-contrib-cssmin'
	grunt.loadNpmTasks 'grunt-contrib-less'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-contrib-concat'

	# Express server + LiveReload
	# grunt.loadNpmTasks 'grunt-express'

	# Register grunt tasks supplied by grunt-hustler.
	# Referenced in package.json.
	# https://github.com/CaryLandholt/grunt-hustler
	grunt.loadNpmTasks 'grunt-hustler'

	# Register grunt tasks supplied by grunt-karma.
	# Referenced in package.json.
	# https://github.com/karma-runner/grunt-karma
	grunt.loadNpmTasks 'grunt-karma'

	# Grunt-Bower-Task.
	grunt.loadNpmTasks 'grunt-bower-task'

	# Grunt Protractor starter
	grunt.loadNpmTasks 'grunt-protractor-runner'

	# Compiles the app with non-optimized build settings, places the build artifacts in the dist directory, and runs unit tests.
	# Enter the following command at the command line to execute this build task:
	# grunt test

	# Async grunt
	grunt.loadNpmTasks 'grunt-wait-async'

	grunt.registerTask 'test', [
		'karma:unit'
	]

	grunt.registerTask 'e2e', [
		'karma:e2e'
	]

	grunt.registerTask 'e2e-ci', [
		'protractor:e2e'
	]

	grunt.registerTask 'e2e-ci-dev', [
		'protractor:dev'
	]

	# Starts a web server
	# Enter the following command at the command line to execute this task:
	# grunt server
	grunt.registerTask 'server', [
		'default'
		'connect'
		'watch'
	]

	# Compiles the app with non-optimized build settings and places the build artifacts in the dist directory.
	# Enter the following command at the command line to execute this build task:
	# grunt
	grunt.registerTask 'default', [
		'start'
		'clean:dev'
		'bower:install'
		'copy:bower'
		'copy:scriptSource'
		'coffee:dev'
		'fileconstruct'
		'wrap:dev'
		'copy:styleSource'
		'template:views'
		'copy:img'
		'copy:favicon'
		'copy:csslib'
		'copy:less'
		'less:styles'
		'concat:css'
		'copy:fonts'
		'template:dev'
		'copy:dev'
		'end'
	]

	# Compiles the app with non-optimized build settings, places the build artifacts in the dist directory, and watches for file changes.
	# Enter the following command at the command line to execute this build task:
	# grunt dev
	grunt.registerTask 'dev', [
		'default'
	]

	# Compiles the app with optimized build settings and places the build artifacts in the dist directory.
	# Enter the following command at the command line to execute this build task:
	# grunt prod
	grunt.registerTask 'prod', [
		'clean:prod'
		'bower:install'
		'copy:bower'
		'copy:scriptSource'
		#'coffee:scripts'
		'coffee:prod'
		'wrap:prod'
		'copy:styleSource'
		'copy:csslib'
		'copy:less'
		'less:styles'
		'concat:css'
		'cssmin'
		'template:views'
		'ngTemplateCache:views'
		'uglify'
		'imagemin'
		'copy:fonts'
		'template:prod'
		'minifyHtml'
		'copy:prod'
		'coffee:server'
	]

	grunt.registerTask 'localprod', [
		'clean:prod'
		'bower:install'
		'copy:bower'
		'copy:scriptSource'
		#'coffee:scripts'
		'wrap:prod'
		'coffee:prod'
		'copy:styleSource'
		'copy:csslib'
		'copy:less'
		'less:styles'
		'concat:css'
		'cssmin'
		'template:views'
		'ngTemplateCache:views'
		'uglify'
		'imagemin'
		'copy:fonts'
		'template:prod'
		'minifyHtml'
		'copy:prod'

		'copy:dev'
		'connect'
		'watch'
	]

	grunt.registerTask 'miniprod', [
		'copy:scriptSource'
		'coffee:prod'
		'template:views'
		'ngTemplateCache:views'
		'uglify:miniprod'
		'copy:prod'
	]


	###
	grunt.registerTask 'upload', [
		'upload_csv:data'
	]
	###
