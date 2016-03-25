angular.module('app').service('elasticService', [
	'esFactory', (esFactory) ->
		esFactory({host: 'localhost:9200'})
])
