angular.module('app').service('termsService', [
	'termsResource', (termsResource) ->

		search: (searchPattern, callback) ->
			termsResource.search {'searchPattern': searchPattern}, (response) ->
				callback(response)
])
